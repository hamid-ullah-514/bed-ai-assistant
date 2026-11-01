import os
import asyncio
from typing import List, Optional, Dict, Any
from fastapi import FastAPI, HTTPException, BackgroundTasks, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse, Response
import fitz
from pydantic import BaseModel
import uvicorn

from config import BOOKS_METADATA, HOST, PORT, GEMINI_API_KEY, OPENAI_API_KEY
from database import (
    init_db, get_db_stats, search_pages, get_page_by_id,
    save_history_record, get_history_records, delete_history_record, get_connection
)
from extractor import extract_and_index_all_books
from ai_generator import generate_ai_answer, is_urdu_text

app = FastAPI(
    title="B.Ed AI Book Assistant Backend",
    version="1.0.0",
    description="Academic retrieval and answer generation system exclusively grounded in the 6 B.Ed PDF books."
)

# Enable CORS for Flutter Android, Web, and Desktop
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

indexing_status = {
    "is_indexing": False,
    "progress": "",
    "error": None
}

from pathlib import Path
from fastapi.staticfiles import StaticFiles

WEB_DIR = Path(__file__).resolve().parent.parent / "web"

class SearchRequest(BaseModel):
    query: str
    book_numbers: Optional[List[int]] = None
    limit: int = 15

class AskRequest(BaseModel):
    question: str
    book_numbers: Optional[List[int]] = None
    language: Optional[str] = None  # "urdu" or "english"
    detail_level: Optional[str] = "concise"  # "concise" or "detailed"
    api_key: Optional[str] = None
    model_provider: str = "groq"

class SettingsRequest(BaseModel):
    gemini_api_key: Optional[str] = None
    openai_api_key: Optional[str] = None

@app.on_event("startup")
async def startup_event():
    init_db()
    stats = get_db_stats()
    print(f"[Backend Started] Current indexed pages: {stats['total_indexed_pages']}")

@app.get("/api/status")
def get_status():
    stats = get_db_stats()
    return {
        "status": "online",
        "indexing": indexing_status,
        "database": stats
    }

@app.get("/api/books")
def list_books():
    return BOOKS_METADATA

@app.get("/api/books/{book_number}/pages/{pdf_page}")
def get_page(book_number: int, pdf_page: int):
    page_data = get_page_by_id(book_number, pdf_page)
    if not page_data:
        raise HTTPException(status_code=404, detail="Page not found")
    return page_data

@app.get("/api/books/{book_number}/pdf")
def get_book_pdf(book_number: int):
    for b in BOOKS_METADATA:
        if b["book_number"] == book_number:
            pdf_path = b["pdf_path"]
            if os.path.exists(pdf_path):
                return FileResponse(
                    pdf_path,
                    media_type="application/pdf",
                    filename=os.path.basename(pdf_path),
                    headers={
                        "Accept-Ranges": "bytes",
                        "Cache-Control": "public, max-age=86400",
                    }
                )
            else:
                raise HTTPException(status_code=404, detail="PDF file not found on disk")
    raise HTTPException(status_code=404, detail="Book not found")

@app.get("/api/books/{book_number}/page-image/{pdf_page}")
def get_book_page_image(book_number: int, pdf_page: int):
    for b in BOOKS_METADATA:
        if b["book_number"] == book_number:
            pdf_path = b["pdf_path"]
            if os.path.exists(pdf_path):
                try:
                    with fitz.open(pdf_path) as doc:
                        # pdf_page is 1-indexed
                        page_idx = max(0, min(pdf_page - 1, len(doc) - 1))
                        page = doc[page_idx]
                        pix = page.get_pixmap(dpi=120)
                        img_bytes = pix.tobytes("jpeg", jpg_quality=80)
                        return Response(
                            content=img_bytes,
                            media_type="image/jpeg",
                            headers={"Cache-Control": "public, max-age=86400"}
                        )
                except Exception as e:
                    raise HTTPException(status_code=500, detail=f"Error rendering page: {e}")
            else:
                raise HTTPException(status_code=404, detail="PDF file not found on disk")
    raise HTTPException(status_code=404, detail="Book not found")

@app.post("/api/search")
def search_books(req: SearchRequest):
    results = search_pages(query=req.query, book_numbers=req.book_numbers, limit=req.limit)
    return {
        "query": req.query,
        "results_count": len(results),
        "results": results
    }

@app.post("/api/ask")
async def ask_question(req: AskRequest):
    if not req.question.strip():
        raise HTTPException(status_code=400, detail="Question cannot be empty.")

    answer_data = await generate_ai_answer(
        question=req.question,
        book_numbers=req.book_numbers,
        language=req.language,
        detail_level=req.detail_level or "concise",
        api_key=req.api_key or GEMINI_API_KEY,
        model_provider=req.model_provider
    )

    is_urdu = is_urdu_text(req.question)
    lang = "Urdu" if is_urdu else "English"
    summary = answer_data.get("introduction", "")[:120]

    # Save to history
    try:
        hist_id = save_history_record(
            question=req.question,
            language=lang,
            book_numbers=req.book_numbers or [1, 2, 3, 4, 5, 6],
            answer_json=answer_data,
            summary=summary
        )
        answer_data["history_id"] = hist_id
    except Exception as e:
        print(f"Error saving history: {e}")

    return answer_data

@app.get("/api/history")
def get_history(limit: int = Query(50, ge=1, le=100)):
    return get_history_records(limit=limit)

@app.delete("/api/history/{record_id}")
def delete_history(record_id: int):
    delete_history_record(record_id)
    return {"success": True, "message": f"Record {record_id} deleted."}

async def run_indexing_task():
    global indexing_status
    indexing_status["is_indexing"] = True
    indexing_status["error"] = None
    try:
        def on_prog(b_num, curr, tot):
            indexing_status["progress"] = f"Book {b_num}: {curr}/{tot} pages"
        await extract_and_index_all_books(progress_callback=on_prog)
        indexing_status["progress"] = "Completed indexing all 6 books."
    except Exception as e:
        indexing_status["error"] = str(e)
    finally:
        indexing_status["is_indexing"] = False

@app.post("/api/index/start")
def start_indexing(background_tasks: BackgroundTasks):
    global indexing_status
    if indexing_status["is_indexing"]:
        return {"message": "Indexing is already in progress.", "status": indexing_status}
    background_tasks.add_task(run_indexing_task)
    return {"message": "Indexing task started in background."}

@app.get("/api/books/index")
def get_books_index(book_number: Optional[int] = None, q: Optional[str] = None):
    """Returns all chapters, unit headings, and page numbers across all 6 B.Ed textbooks."""
    conn = get_connection()
    c = conn.cursor()
    query = """
        SELECT book_number, course_code, book_title, unit_number, unit_title, 
               section_heading, pdf_page, printed_page, substr(text, 1, 140) as snippet
        FROM pages 
        WHERE length(section_heading) > 2
    """
    params = []
    if book_number:
        query += " AND book_number = ?"
        params.append(book_number)
    if q and q.strip():
        query += " AND (section_heading LIKE ? OR unit_title LIKE ? OR text LIKE ?)"
        wildcard = f"%{q.strip()}%"
        params.extend([wildcard, wildcard, wildcard])
    query += " ORDER BY book_number, pdf_page"
    c.execute(query, params)
    rows = c.fetchall()
    conn.close()
    return [
        {
            "book_number": r["book_number"],
            "course_code": r["course_code"],
            "book_title": r["book_title"],
            "unit_number": r["unit_number"],
            "unit_title": r["unit_title"],
            "heading": r["section_heading"],
            "pdf_page": r["pdf_page"],
            "printed_page": r["printed_page"],
            "snippet": (r["snippet"] or "").strip().replace("\n", " ") + "..."
        }
        for r in rows
    ]

# Mount static web frontend at root (must be after all /api routes)
if os.path.exists(WEB_DIR):
    app.mount("/", StaticFiles(directory=str(WEB_DIR), html=True), name="web")
else:
    @app.get("/")
    def read_root():
        return {
            "app": "B.Ed AI Book Assistant Backend",
            "status": "Online",
            "books_count": len(BOOKS_METADATA),
            "docs_url": "/docs"
        }

if __name__ == "__main__":
    uvicorn.run("main:app", host=HOST, port=PORT, reload=False)
