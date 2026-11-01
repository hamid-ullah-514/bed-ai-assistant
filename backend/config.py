import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
BOOKS_DIR = BASE_DIR.parent

# Load local .env if present
env_file = BASE_DIR / ".env"
if env_file.exists():
    with open(env_file, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip())

DB_PATH = BASE_DIR / "bed_knowledge.db"

BOOKS_METADATA = [
    {
        "book_number": 1,
        "course_code": "8601",
        "title": "General Methods of Teaching",
        "urdu_title": "تعلیم و تربیت کے اصول",
        "author_dept": "Department of Early Childhood Education and Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8601.pdf"),
        "is_scanned": False,
        "total_pages": 249,
        "units": [
            {"unit": 1, "title": "Teaching and Learning"},
            {"unit": 2, "title": "Lesson Planning"},
            {"unit": 3, "title": "Instructional Objectives"},
            {"unit": 4, "title": "Methods of Teaching"},
            {"unit": 5, "title": "Student-Centered Teaching Strategies"},
            {"unit": 6, "title": "Teacher-Centered Teaching Strategies"},
            {"unit": 7, "title": "Instructional Media and Technology"},
            {"unit": 8, "title": "Classroom Management"},
            {"unit": 9, "title": "Assessment of Learning"}
        ]
    },
    {
        "book_number": 2,
        "course_code": "8602",
        "title": "Educational Assessment and Evaluation",
        "urdu_title": "بچوں کی نفسیات و جائزہ",
        "author_dept": "Department of Early Childhood Education and Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8602.pdf"),
        "is_scanned": False,
        "total_pages": 240,
        "units": [
            {"unit": 1, "title": "Concept of Assessment and Evaluation"},
            {"unit": 2, "title": "Educational Objectives and Taxonomy"},
            {"unit": 3, "title": "Types of Assessment (Formative and Summative)"},
            {"unit": 4, "title": "Achievement Tests (Construction and Types)"},
            {"unit": 5, "title": "Objective Type Tests"},
            {"unit": 6, "title": "Subjective/Essay Type Tests"},
            {"unit": 7, "title": "Test Administration and Scoring"},
            {"unit": 8, "title": "Validity and Reliability"},
            {"unit": 9, "title": "Grading, Reporting and Modern Trends in Assessment"}
        ]
    },
    {
        "book_number": 3,
        "course_code": "8603",
        "title": "Curriculum Development",
        "urdu_title": "تدریسی طریق اور اسالیب (نصاب سازی)",
        "author_dept": "Department of Early Childhood Education & Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8603.pdf"),
        "is_scanned": True,
        "total_pages": 258,
        "units": [
            {"unit": 1, "title": "Introducing Curriculum: Concepts and Foundations"},
            {"unit": 2, "title": "History of Curriculum Development in Pakistan"},
            {"unit": 3, "title": "Foundations of Curriculum (Philosophical, Sociological, Psychological)"},
            {"unit": 4, "title": "Curriculum Planning and Process"},
            {"unit": 5, "title": "Curriculum Design Models"},
            {"unit": 6, "title": "Curriculum Development in Pakistan"},
            {"unit": 7, "title": "Textbook Development and Instructional Materials"},
            {"unit": 8, "title": "Curriculum Implementation and Evaluation"},
            {"unit": 9, "title": "Curriculum Issues, Trends and Research"}
        ]
    },
    {
        "book_number": 4,
        "course_code": "8604",
        "title": "Research Methods in Education",
        "urdu_title": "تعلیمی منصوبہ بندی و تحقیق",
        "author_dept": "Department of Early Childhood Education & Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8604.pdf"),
        "is_scanned": False,
        "total_pages": 341,
        "units": [
            {"unit": 1, "title": "Scientific Method and Educational Research"},
            {"unit": 2, "title": "Identification of Research Problem and Hypotheses"},
            {"unit": 3, "title": "Review of Related Literature"},
            {"unit": 4, "title": "Sampling Techniques and Procedures"},
            {"unit": 5, "title": "Descriptive Research Methods"},
            {"unit": 6, "title": "Experimental Research Methods"},
            {"unit": 7, "title": "Historical and Qualitative Research"},
            {"unit": 8, "title": "Research Tools (Questionnaire, Interview, Observation)"},
            {"unit": 9, "title": "Data Analysis, Report Writing and Referencing"}
        ]
    },
    {
        "book_number": 5,
        "course_code": "8605",
        "title": "Educational Leadership and Management",
        "urdu_title": "کلاس روم مینجمنٹ و قیادت",
        "author_dept": "Department of Early Childhood Education & Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8605.pdf"),
        "is_scanned": False,
        "total_pages": 231,
        "units": [
            {"unit": 1, "title": "Concept of Educational Management and Leadership"},
            {"unit": 2, "title": "Theories of Leadership and Management"},
            {"unit": 3, "title": "Educational Planning and Decision Making"},
            {"unit": 4, "title": "Educational Supervision and Inspection"},
            {"unit": 5, "title": "Human Resource Management in Education"},
            {"unit": 6, "title": "Financial Management and School Budgeting"},
            {"unit": 7, "title": "School Discipline and Conflict Management"},
            {"unit": 8, "title": "Educational Organization and Structure in Pakistan"},
            {"unit": 9, "title": "Total Quality Management (TQM) in Education"}
        ]
    },
    {
        "book_number": 6,
        "course_code": "8606",
        "title": "Citizenship Education and Community Engagement",
        "urdu_title": "تعلیمی تحقیق، جدت اور شہریت",
        "author_dept": "Department of Early Childhood Education & Elementary Teacher Education",
        "university": "Allama Iqbal Open University, Islamabad",
        "pdf_path": str(BOOKS_DIR / "8606.pdf"),
        "is_scanned": False,
        "total_pages": 215,
        "units": [
            {"unit": 1, "title": "Society and Culture"},
            {"unit": 2, "title": "Group and Group Dynamics"},
            {"unit": 3, "title": "Socialization and Personality Development"},
            {"unit": 4, "title": "Social Institutions (Family, Religion, Education)"},
            {"unit": 5, "title": "Social Control and Deviance"},
            {"unit": 6, "title": "School and Community Relationships"},
            {"unit": 7, "title": "The Effective Teacher in the Community"},
            {"unit": 8, "title": "Technological Change and Society"},
            {"unit": 9, "title": "Collaboration Between School and Community"}
        ]
    }
]

HOST = os.getenv("BED_HOST", "0.0.0.0")
PORT = int(os.getenv("BED_PORT", 8000))
GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
