# 📚 B.Ed AI Book Assistant & Master Index
### علامہ اقبال اوپن یونیورسٹی (AIOU) بی ایڈ 1.5 سالہ پروگرام — امتحانی معاون و جامع اشاریہ کتب

[![Live on Vercel](https://img.shields.io/badge/Live-Vercel%20Deployment-success?style=for-the-badge&logo=vercel)](https://bed-ai-assistant.vercel.app)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge&logo=github)](https://github.com/hamid-ullah-514/bed-ai-assistant)
[![Textbooks](https://img.shields.io/badge/AIOU%20Textbooks-6%20Books%20(1%2C534%20Pages)-12365A?style=for-the-badge&logo=book)]()
[![Index](https://img.shields.io/badge/Master%20Index-558%20Topics%20%26%20Headings-19866D?style=for-the-badge)]()

---

## 🌐 لائیو ویب سائٹ (Live Deployment)
👉 **ویب سائٹ لنک:** [https://bed-ai-assistant.vercel.app](https://bed-ai-assistant.vercel.app)

موبائل، ٹیبلٹ یا کمپیوٹر پر کسی بھی براؤزر میں کھولیں اور تمام 6 کتب کا جامع اشاریہ اور سوال و جواب بلا معاوضہ استعمال کریں۔

---

## 📑 6 درسی کتب اور اشاریہ (Curriculum & Master Index)

یہ تعلیمی پلیٹ فارم علامہ اقبال اوپن یونیورسٹی کی درج ذیل چھ باضابطہ بی ایڈ درسی کتب کے **1,534 صفحات** اور **558 اہم عناوین و ابواب** پر مشتمل ہے:

| # | کورس کوڈ | کتاب کا نام (English) | عنوان (اردو) | کل صفحات | اشاریہ کے نکات |
|---|---|---|---|---|---|
| 1 | **8601** | General Methods of Teaching | تدریسی طریقے و سبق کی منصوبہ بندی | 249 | 150 |
| 2 | **8602** | Educational Assessment and Evaluation | جائزہ و پیمائش اور امتحانی پرچہ سازی | 240 | 105 |
| 3 | **8603** | Curriculum Development | نصاب سازی کے بنیادی عناصر و مراحل | 258 | 58 |
| 4 | **8604** | Research Methods in Education | تعلیمی تحقیق اور سیمپلنگ کے طریقے | 341 | 103 |
| 5 | **8605** | Educational Leadership and Management | اسکول مینجمنٹ، انتظام اور نظم و ضبط | 231 | 75 |
| 6 | **8606** | Citizenship Education & Community Engagement | شہریت، اسکول اور کمیونٹی کا اشتراک | 215 | 67 |
| **کل** | — | **6 مستند بی ایڈ کتب** | **مکمل بی ایڈ کورس** | **1,534** | **558** |

---

## ✨ نمایاں خصوصیات (Key Features)

1. **📑 جامع اشاریہ کتب (Master Headings & Topics Index):**
   * تمام 558 عناوین، ابواب، پی ڈی ایف صفحات اور پرنٹڈ صفحات کی تفصیلی لسٹ۔
   * کتاب اور کورس کوڈ کی بنیاد پر فلٹرنگ۔
   * فوری لفظی تلاش (Live Instant Search)।
   * [👁️ اصل صفحہ دیکھیں] پر کلک کر کے کتاب کا وہ خاص صفحہ مکمل ریزولوشن میں پڑھنے کی سہولت۔

2. **💬 سوال و جواب مع 20 نکات و انڈیکس ٹیبل (Structured 20-Heading Answers):**
   * ہر امتحانی سوال کے جواب کے آغاز میں **فہرستِ عنوانات و کتب و صفحات (Answer Index Table)**۔
   * 20 مستند نکات جن میں سے ہر ایک کے ساتھ اصل کتاب کا نام اور صفحہ نمبر درج ہے۔
   * ہر نکتہ کے نیچے آسان و جامع تشریح۔

3. **🔍 تمام کتب میں لفظی تلاش (Full-Text Search Across 1,534 Pages):**
   * کتب کے کسی بھی باب یا پیراگراف میں سے مطلوبہ الفاظ تلاش کرنے کی سہولت۔

4. **📱 اینڈرائیڈ موبائل ایپ (Flutter Mobile App):**
   * موبائل کے لیے مکمل ایپ سورس کوڈ بھی اسی ریپوزٹری میں `bed_assistant/` کے اندر شامل ہے۔

---

## 🛠️ مقامی کمپیوٹر پر چلانے کا طریقہ (Local Setup)

### 1. ریپوزٹری کلون کریں:
```bash
git clone https://github.com/hamid-ullah-514/bed-ai-assistant.git
cd bed-ai-assistant
```

### 2. پائتھن بیک اینڈ سرور چلائیں:
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```
یا براہِ راست `run_backend.bat` پر ڈبل کلک کریں۔

### 3. ویب سائٹ کھولیں:
براؤزر میں جائیں: `http://localhost:8000`

---

## 📁 ڈائریکٹری کا ڈھانچہ (Project Structure)

```text
bed-ai-assistant/
├── web/                       # ویب فرنٹ اینڈ (HTML, CSS, JS, Vercel Ready)
│   ├── index.html             # مین سنگل پیج ایپلیکیشن
│   ├── css/style.css          # جدید اردو و انگلش ریسپانسیو ڈیزائن
│   ├── js/app.js              # فرنٹ اینڈ لاجک، سرچ اور اشاریہ نیویگیشن
│   └── data/
│       ├── books_index.json   # تمام 558 عناوین و صفحات کا مکمل اشاریہ
│       └── books_metadata.json# تمام 6 کتب کی معلومات
├── backend/                   # فاسٹ اے پی آئی بیک اینڈ سرور
│   ├── main.py                # اے پی آئی اینڈ پوائنٹس
│   ├── bed_knowledge.db       # مکمل انڈیکس شدہ ڈیٹابیس (1,534 صفحات)
│   ├── database.py            # SQLite FTS5 فل ٹیکسٹ سرچ
│   ├── extractor.py           # پی ڈی ایف ایکسٹریشن اور تجزیہ
│   └── ai_generator.py        # 20 نکات و انڈیکس جنریٹر
├── bed_assistant/             # فلٹر اینڈرائیڈ موبائل ایپ
└── README.md                  # مکمل معلوماتی دستاویز
```

---

## ⚖️ اخلاقی و امتحانی دیانت داری (Academic Integrity)
یہ ایپلیکیشن مکمل طور پر علامہ اقبال اوپن یونیورسٹی کی فراہم کردہ 6 کتب کی بنیاد پر کام کرتی ہے۔ اس میں کسی قسم کا غیر مصدقہ یا فرضی مواد شامل نہیں کیا جاتا۔ تمام صفحات اور حوالہ جات طلبہ کی آسانی کے لیے اصل کتب سے تصدیق شدہ ہیں۔
