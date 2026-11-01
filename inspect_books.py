import os
import pypdf

books = [
    {"book_num": 1, "path": r"D:\AI corse\b.ed\8601.pdf", "code": "8601"},
    {"book_num": 2, "path": r"D:\AI corse\b.ed\8602.pdf", "code": "8602"},
    {"book_num": 3, "path": r"D:\AI corse\b.ed\8603.pdf", "code": "8603"},
    {"book_num": 4, "path": r"D:\AI corse\b.ed\8604.pdf", "code": "8604"},
    {"book_num": 5, "path": r"D:\AI corse\b.ed\8605.pdf", "code": "8605"},
    {"book_num": 6, "path": r"D:\AI corse\b.ed\8606", "code": "8606"},
]

print("=== INSPECTING B.ED BOOKS WITH PYPDF ===")

for b in books:
    p = b["path"]
    code = b["code"]
    if os.path.isfile(p):
        reader = pypdf.PdfReader(p)
        page_count = len(reader.pages)
        sample_text = ""
        has_text_pages = 0
        for i in range(min(10, page_count)):
            try:
                txt = reader.pages[i].extract_text() or ""
                if len(txt.strip()) > 30:
                    has_text_pages += 1
                if i < 4 and len(sample_text) < 1500:
                    sample_text += f"\n--- Page {i+1} ---\n" + txt[:400]
            except Exception as e:
                sample_text += f"\nError page {i+1}: {e}"
        
        is_scanned = (has_text_pages == 0)
        print(f"\n==========================================")
        print(f"[Book {b['book_num']}] Course Code: {code}")
        print(f"Path: {p}")
        print(f"Total Pages: {page_count}")
        print(f"Scanned (no direct text): {is_scanned} (text detected in {has_text_pages}/10 sample pages)")
        print(f"Sample text preview:\n{sample_text[:500]}")
    elif os.path.isdir(p):
        files = sorted(os.listdir(p))
        pdf_files = [f for f in files if f.endswith(".pdf")]
        print(f"\n==========================================")
        print(f"[Book {b['book_num']}] Course Code: {code} (Folder with {len(pdf_files)} PDF units)")
        print(f"Path: {p}")
        total_p = 0
        for pf in pdf_files:
            subp = os.path.join(p, pf)
            subr = pypdf.PdfReader(subp)
            cnt = len(subr.pages)
            total_p += cnt
            txt = ""
            for i in range(min(2, cnt)):
                txt += subr.pages[i].extract_text() or ""
            print(f"  - {pf}: {cnt} pages (starts: {txt[:80].replace(chr(10), ' ')})")
        print(f"Total Combined Pages: {total_p}")
