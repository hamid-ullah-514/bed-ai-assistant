import sqlite3
import json
import re
from typing import List, Dict, Any, Optional
from config import DB_PATH

STOP_WORDS = {
    'what', 'when', 'where', 'which', 'who', 'whom', 'whose', 'why', 'how',
    'does', 'explain', 'describe', 'discuss', 'detail', 'details', 'briefly',
    'define', 'concept', 'about', 'with', 'from', 'into', 'during', 'including',
    'until', 'against', 'among', 'throughout', 'despite', 'towards', 'upon',
    'concerning', 'to', 'in', 'for', 'on', 'by', 'at', 'an', 'a', 'the', 'is',
    'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do',
    'did', 'will', 'would', 'shall', 'should', 'can', 'could', 'may', 'might',
    'must', 'and', 'or', 'not', 'but', 'if', 'then', 'else', 'so', 'as',
    'کیا', 'ہے', 'ہیں', 'تھا', 'تھی', 'تھے', 'اور', 'یا', 'پر', 'سے', 'کا', 'کی', 'کے',
    'میں', 'کو', 'نے', 'تک', 'کون', 'کب', 'کہاں', 'کیوں', 'کیسے', 'وضاحت', 'بیان', 'کریں'
}

def get_connection():
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_number INTEGER UNIQUE,
        course_code TEXT,
        title TEXT,
        author_dept TEXT,
        university TEXT,
        total_pages INTEGER,
        is_scanned BOOLEAN,
        pdf_path TEXT,
        indexed_pages INTEGER DEFAULT 0
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS pages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_number INTEGER,
        course_code TEXT,
        book_title TEXT,
        pdf_page INTEGER,
        printed_page TEXT,
        unit_number INTEGER,
        unit_title TEXT,
        section_heading TEXT,
        text TEXT,
        word_count INTEGER,
        UNIQUE(book_number, pdf_page)
    )
    """)

    cursor.execute("""
    CREATE VIRTUAL TABLE IF NOT EXISTS fts_pages USING fts5(
        page_id UNINDEXED,
        book_number UNINDEXED,
        course_code UNINDEXED,
        book_title UNINDEXED,
        pdf_page UNINDEXED,
        printed_page UNINDEXED,
        unit_number UNINDEXED,
        unit_title UNINDEXED,
        section_heading,
        text,
        tokenize='porter unicode61'
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        question TEXT,
        language TEXT,
        book_numbers TEXT,
        answer_json TEXT,
        summary TEXT
    )
    """)

    conn.commit()
    conn.close()

def save_page(
    book_number: int,
    course_code: str,
    book_title: str,
    pdf_page: int,
    printed_page: str,
    unit_number: int,
    unit_title: str,
    section_heading: str,
    text: str
):
    conn = get_connection()
    cursor = conn.cursor()
    word_count = len(text.split())

    cursor.execute("""
    INSERT INTO pages (book_number, course_code, book_title, pdf_page, printed_page, unit_number, unit_title, section_heading, text, word_count)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(book_number, pdf_page) DO UPDATE SET
        printed_page = excluded.printed_page,
        unit_number = excluded.unit_number,
        unit_title = excluded.unit_title,
        section_heading = excluded.section_heading,
        text = excluded.text,
        word_count = excluded.word_count
    """, (book_number, course_code, book_title, pdf_page, printed_page, unit_number, unit_title, section_heading, text, word_count))

    cursor.execute("SELECT id FROM pages WHERE book_number = ? AND pdf_page = ?", (book_number, pdf_page))
    row = cursor.fetchone()
    page_id = row["id"] if row else 0

    cursor.execute("DELETE FROM fts_pages WHERE page_id = ?", (page_id,))
    cursor.execute("""
    INSERT INTO fts_pages (page_id, book_number, course_code, book_title, pdf_page, printed_page, unit_number, unit_title, section_heading, text)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (page_id, book_number, course_code, book_title, pdf_page, printed_page, unit_number, unit_title, section_heading, text))

    conn.commit()
    conn.close()

def update_book_progress(book_number: int, indexed_count: int, total_pages: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    UPDATE books SET indexed_pages = ?, total_pages = ? WHERE book_number = ?
    """, (indexed_count, total_pages, book_number))
    conn.commit()
    conn.close()

def extract_significant_keywords(query: str) -> List[str]:
    cleaned = re.sub(r'["\'\*\^\:\(\)\-\+\~\[\]\{\}\<\>\,\.\?\!\;\/]', ' ', query.lower())
    words = [w.strip() for w in cleaned.split() if len(w.strip()) > 2]
    sig_words = [w for w in words if w not in STOP_WORDS]
    return sig_words if sig_words else words

def clean_search_query(sig_words: List[str]) -> str:
    if not sig_words:
        return ""
    return " OR ".join(f'"{w}"' for w in sig_words[:10])

def search_pages(query: str, book_numbers: Optional[List[int]] = None, limit: int = 15) -> List[Dict[str, Any]]:
    sig_keywords = extract_significant_keywords(query)
    if not sig_keywords:
        return []

    conn = get_connection()
    cursor = conn.cursor()
    fts_q = clean_search_query(sig_keywords)
    raw_results = []

    if fts_q:
        try:
            sql = """
            SELECT page_id, book_number, course_code, book_title, pdf_page, printed_page,
                   unit_number, unit_title, section_heading, snippet(fts_pages, 9, '<b>', '</b>', '...', 25) as snippet,
                   text, bm25(fts_pages) as rank
            FROM fts_pages
            WHERE fts_pages MATCH ?
            """
            params = [fts_q]
            if book_numbers:
                placeholders = ",".join("?" for _ in book_numbers)
                sql += f" AND book_number IN ({placeholders})"
                params.extend(book_numbers)

            sql += " ORDER BY rank LIMIT ?"
            params.append(limit * 2)
            cursor.execute(sql, params)
            for row in cursor.fetchall():
                raw_results.append(dict(row))
        except Exception as e:
            print(f"FTS search error: {e}")

    # Verify substantive keyword overlap
    verified_results = []
    for r in raw_results:
        text_lower = r["text"].lower()
        matched_count = sum(1 for kw in sig_keywords if kw in text_lower)
        # Require matching at least 2 significant terms, or 1 if only 1 term queried
        min_required = 1 if len(sig_keywords) == 1 else 2
        if matched_count >= min_required:
            r["keyword_matches"] = matched_count
            verified_results.append(r)

    # Sort by keyword matches descending, then bm25 rank
    verified_results.sort(key=lambda x: (x.get("keyword_matches", 0), -x.get("rank", 0)), reverse=True)
    conn.close()
    return verified_results[:limit]

def get_page_by_id(book_number: int, pdf_page: int) -> Optional[Dict[str, Any]]:
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT * FROM pages WHERE book_number = ? AND pdf_page = ?
    """, (book_number, pdf_page))
    row = cursor.fetchone()
    conn.close()
    return dict(row) if row else None

def get_db_stats() -> Dict[str, Any]:
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT book_number, title, total_pages, indexed_pages, is_scanned FROM books ORDER BY book_number")
    books = [dict(r) for r in cursor.fetchall()]
    cursor.execute("SELECT COUNT(*) as total_indexed, SUM(word_count) as total_words FROM pages")
    stats = dict(cursor.fetchone() or {"total_indexed": 0, "total_words": 0})
    conn.close()
    return {"books": books, "total_indexed_pages": stats["total_indexed"], "total_words": stats["total_words"] or 0}

def save_history_record(question: str, language: str, book_numbers: List[int], answer_json: Dict[str, Any], summary: str):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    INSERT INTO history (question, language, book_numbers, answer_json, summary)
    VALUES (?, ?, ?, ?, ?)
    """, (question, language, json.dumps(book_numbers), json.dumps(answer_json), summary))
    conn.commit()
    history_id = cursor.lastrowid
    conn.close()
    return history_id

def get_history_records(limit: int = 50) -> List[Dict[str, Any]]:
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
    SELECT id, timestamp, question, language, book_numbers, answer_json, summary
    FROM history ORDER BY id DESC LIMIT ?
    """, (limit,))
    rows = [dict(r) for r in cursor.fetchall()]
    for r in rows:
        try:
            r["book_numbers"] = json.loads(r["book_numbers"])
            r["answer_json"] = json.loads(r["answer_json"])
        except Exception:
            pass
    conn.close()
    return rows

def delete_history_record(record_id: int):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM history WHERE id = ?", (record_id,))
    conn.commit()
    conn.close()
