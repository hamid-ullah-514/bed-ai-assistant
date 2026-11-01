import os
import re
import asyncio
from typing import Optional, Tuple
from PIL import Image
import pypdf
import winocr
from config import BOOKS_METADATA, BOOKS_DIR
from database import init_db, save_page, update_book_progress, get_connection

def detect_printed_page(text: str, pdf_page: int) -> str:
    lines = [line.strip() for line in text.split("\n") if line.strip()]
    if not lines:
        return str(pdf_page)
    
    # Check first 2 lines and last 2 lines
    candidates = lines[:2] + lines[-2:]
    for c in candidates:
        # Match single isolated number
        m = re.match(r'^(?:page\s*)?([0-9]{1,4})$', c, re.IGNORECASE)
        if m:
            num = int(m.group(1))
            # Sensible range check compared to pdf_page
            if 1 <= num <= 400:
                return str(num)
        # Roman numerals for preliminary pages
        m_rom = re.match(r'^([ivxlcdm]{1,6})$', c, re.IGNORECASE)
        if m_rom and pdf_page <= 20:
            return m_rom.group(1).lower()

    # If not found explicitly, infer based on standard offset
    return str(pdf_page)

def detect_unit_and_heading(text: str, current_unit: int, units_list: list) -> Tuple[int, str, str]:
    lines = [line.strip() for line in text.split("\n") if line.strip()]
    unit_num = current_unit
    unit_title = ""
    section_heading = ""

    # Look for "Unit 1", "UNIT - 2", "Unit: 3", etc.
    for line in lines[:8]:
        m = re.search(r'unit\s*[:\-–—]?\s*([1-9])', line, re.IGNORECASE)
        if m:
            unit_num = int(m.group(1))
            break

    # Get unit title from metadata if known
    for u in units_list:
        if u["unit"] == unit_num:
            unit_title = f"Unit {unit_num}: {u['title']}"
            break

    # Look for section headings like "1.1 Concept of...", "2.3.1 Principles..."
    for line in lines:
        m = re.match(r'^([0-9]+\.[0-9]+(?:\.[0-9]+)?\s+[A-Za-z\s]{3,60})$', line)
        if m:
            section_heading = m.group(1).strip()
            break
        # Or uppercase headings
        if line.isupper() and 5 < len(line) < 50 and not re.search(r'allama|university|isbn|copyright', line, re.IGNORECASE):
            section_heading = line.strip()
            break

    return unit_num, unit_title, section_heading

async def extract_and_index_all_books(progress_callback=None):
    init_db()
    conn = get_connection()
    cursor = conn.cursor()

    # Ensure books are registered in database
    for meta in BOOKS_METADATA:
        cursor.execute("""
        INSERT OR IGNORE INTO books (book_number, course_code, title, author_dept, university, total_pages, is_scanned, pdf_path)
        VALUES (?, ?, ?, ?, ?, 0, ?, ?)
        """, (meta["book_number"], meta["course_code"], meta["title"], meta["author_dept"], meta["university"], meta["is_scanned"], meta["pdf_path"]))
    conn.commit()
    conn.close()

    total_books = len(BOOKS_METADATA)

    for b_idx, meta in enumerate(BOOKS_METADATA):
        b_num = meta["book_number"]
        pdf_path = meta["pdf_path"]
        title = meta["title"]
        code = meta["course_code"]
        is_scanned = meta["is_scanned"]
        units_list = meta["units"]

        if not os.path.exists(pdf_path):
            print(f"[Extractor] Book {b_num} ({code}) not found at {pdf_path}")
            continue

        reader = pypdf.PdfReader(pdf_path)
        total_pages = len(reader.pages)
        print(f"\n[Extractor] Processing Book {b_num}: {title} ({code}) - {total_pages} pages (Scanned: {is_scanned})...")

        # Check existing indexed pages
        conn = get_connection()
        c = conn.cursor()
        c.execute("SELECT COUNT(*) FROM pages WHERE book_number = ?", (b_num,))
        already_indexed = c.fetchone()[0]
        conn.close()

        if already_indexed >= total_pages - 2 and total_pages > 0:
            print(f"[Extractor] Book {b_num} already fully indexed ({already_indexed}/{total_pages} pages). Skipping.")
            update_book_progress(b_num, already_indexed, total_pages)
            continue

        current_unit = 1
        current_unit_title = f"Unit 1: {units_list[0]['title']}" if units_list else "Unit 1"

        temp_dir = BOOKS_DIR / "temp_ocr"
        os.makedirs(temp_dir, exist_ok=True)

        for p_idx in range(total_pages):
            pdf_page_num = p_idx + 1
            page = reader.pages[p_idx]
            text = ""

            if not is_scanned:
                try:
                    text = page.extract_text() or ""
                except Exception as e:
                    text = f"[Text extraction error: {e}]"
            else:
                # Scanned PDF: Extract images and run winocr
                try:
                    for img_idx, img_obj in enumerate(page.images):
                        temp_file = temp_dir / f"ocr_{b_num}_{pdf_page_num}_{img_idx}.jpg"
                        with open(temp_file, "wb") as f_img:
                            f_img.write(img_obj.data)
                        pil_img = Image.open(temp_file)
                        ocr_res = await winocr.recognize_pil(pil_img, lang='en')
                        text += ocr_res.text + "\n"
                        try:
                            os.remove(temp_file)
                        except Exception:
                            pass
                except Exception as e:
                    print(f"Error OCR on Book {b_num} Page {pdf_page_num}: {e}")
                    text = f"[Scanned page - OCR error: {e}]"

            # Detect metadata
            printed_p = detect_printed_page(text, pdf_page_num)
            u_num, u_title, sec_heading = detect_unit_and_heading(text, current_unit, units_list)
            if u_num != current_unit:
                current_unit = u_num
                current_unit_title = u_title

            save_page(
                book_number=b_num,
                course_code=code,
                book_title=title,
                pdf_page=pdf_page_num,
                printed_page=printed_p,
                unit_number=current_unit,
                unit_title=current_unit_title,
                section_heading=sec_heading,
                text=text.strip()
            )

            if pdf_page_num % 25 == 0 or pdf_page_num == total_pages:
                print(f"  > Book {b_num} ({code}): Indexed {pdf_page_num}/{total_pages} pages")
                update_book_progress(b_num, pdf_page_num, total_pages)
                if progress_callback:
                    progress_callback(b_num, pdf_page_num, total_pages)

        update_book_progress(b_num, total_pages, total_pages)
        print(f"[Extractor] Completed Book {b_num} ({total_pages} pages).")

    # Clean up temp_dir
    try:
        if os.path.exists(temp_dir):
            for f in os.listdir(temp_dir):
                os.remove(temp_dir / f)
            os.rmdir(temp_dir)
    except Exception:
        pass

    print("[Extractor] All 6 books indexed successfully!")

if __name__ == "__main__":
    asyncio.run(extract_and_index_all_books())
