"""
Verified Quran and Hadith Evidence Repository for B.Ed Educational Contexts.
All verses and hadiths are rigorously verified with exact Surah/Ayah numbers
and authentic Hadith collection numbers. Never invent or falsify citations.
"""

from typing import List, Dict, Any, Optional

ISLAMIC_TOPIC_EVIDENCE = [
    {
        "keywords": ["knowledge", "learning", "education", "seek", "reading", "read", "pen", "ilm", "taaleem", "iqra", "تعلیم", "علم", "پڑھنا", "حصول علم", "تدریس"],
        "topic": "Importance of Seeking Knowledge and Teaching",
        "quran": [
            {
                "arabic": "اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ ۝ خَلَقَ الْإِنسَانَ مِنْ عَلَقٍ ۝ اقْرَأْ وَرَبُّكَ الْأَكْرَمُ ۝ الَّذِي عَلَّمَ بِالْقَلَمِ ۝ عَلَّمَ الْإِنسَانَ مَا لَمْ يَعْلَمْ",
                "surah_name": "Surah Al-Alaq (سورۃ العلق)",
                "surah_number": 96,
                "ayah_numbers": "1-5",
                "urdu_translation": "پڑھیے اپنے رب کے نام کے ساتھ جس نے پیدا فرمایا۔ جس نے انسان کو خون کے لوتھڑے سے پیدا کیا۔ پڑھیے اور آپ کا رب بڑا ہی کریم ہے۔ جس نے قلم کے ذریعے (لکھنے کا) علم سکھایا۔ جس نے انسان کو وہ کچھ سکھا دیا جو وہ نہ جانتا تھا۔",
                "relevance": "These opening verses of the Holy Quran establish learning, reading, literacy, and divine epistemological foundation as the supreme purpose of human development and education."
            },
            {
                "arabic": "قُلْ هَلْ يَسْتَوِي الَّذِينَ يَعْلَمُونَ وَالَّذِينَ لَا يَعْلَمُونَ ۗ إِنَّمَا يَتَذَكَّرُ أُولُو الْأَلْبَابِ",
                "surah_name": "Surah Az-Zumar (سورۃ الزمر)",
                "surah_number": 39,
                "ayah_numbers": "9",
                "urdu_translation": "فرما دیجیے: کیا وہ لوگ جو علم رکھتے ہیں اور وہ جو علم نہیں رکھتے برابر ہو سکتے ہیں؟ بے شک نصیحت تو وہی قبول کرتے ہیں جو عقل و شعور والے ہیں۔",
                "relevance": "Affirms the distinguished status and ethical responsibility of educated individuals, scholars, and teachers in society."
            }
        ],
        "hadith": [
            {
                "arabic": "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ",
                "collection": "Sunan Ibn Majah (سنن ابن ماجہ)",
                "hadith_number": "Book 1, Hadith 224 (Verified Sahih)",
                "urdu_translation": "علم حاصل کرنا ہر مسلمان (مرد و عورت) پر فرض ہے۔",
                "relevance": "Establishes universal access and obligatory pursuit of knowledge in Islamic educational philosophy, directly supporting universal primary and elementary education."
            },
            {
                "arabic": "إِنَّمَا بُعِثْتُ مُعَلِّمًا",
                "collection": "Sunan Ibn Majah (سنن ابن ماجہ)",
                "hadith_number": "Hadith 229",
                "urdu_translation": "بے شک مجھے ایک معلم (استاد) بنا کر بھیجا گیا ہے۔",
                "relevance": "Affirms the sacred status and pedagogical role of the teacher as an inheritor of the prophetic mission in moral, intellectual, and social grooming."
            }
        ]
    },
    {
        "keywords": ["method", "pedagogy", "teaching strategy", "gentle", "wisdom", "counseling", "hikmat", "patience", "طریقہ تدریس", "حکمت", "نرمی", "استاد", "رہنمائی", "موعظہ"],
        "topic": "Effective Teaching Methods, Wisdom and Pedagogy",
        "quran": [
            {
                "arabic": "ادْعُ إِلَىٰ سَبِيلِ رَبِّكَ بِالْحِكْمَةِ وَالْمَوْعِظَةِ الْحَسَنَةِ ۖ وَجَادِلْهُم بِالَّتِي هِيَ أَحْسَنُ",
                "surah_name": "Surah An-Nahl (سورۃ النحل)",
                "surah_number": 16,
                "ayah_numbers": "125",
                "urdu_translation": "(اے رسول!) آپ اپنے رب کے راستے کی طرف حکمت اور بہترین نصیحت کے ساتھ بلائیے اور ان سے ایسے طریقے سے بحث کیجیے جو سب سے زیادہ شائستہ ہو۔",
                "relevance": "Provides the fundamental pedagogical framework for instructional strategies: differentiated instruction (Hikmah), motivational counseling (Maw'izah Hasanah), and respectful constructive dialogue."
            },
            {
                "arabic": "فَبِمَا رَحْمَةٍ مِّنَ اللَّهِ لِنتَ لَهُمْ ۖ وَلَوْ كُنتَ فَظًّا غَلِيظَ الْقَلْبِ لَانفَضُّوا مِنْ حَوْلِكَ",
                "surah_name": "Surah Ali 'Imran (سورۃ آل عمران)",
                "surah_number": 3,
                "ayah_numbers": "159",
                "urdu_translation": "(اے حبیب!) پس اللہ کی کیسی رحمت ہے کہ آپ ان کے لیے نرم مزاج واقع ہوئے ہیں، اور اگر آپ تندخو اور سخت دل ہوتے تو وہ آپ کے گرد سے چھٹ جاتے۔",
                "relevance": "Emphasizes compassionate classroom climate, empathy, student rapport, and supportive learning environments essential for effective teaching."
            }
        ],
        "hadith": [
            {
                "arabic": "يَسِّرُوا وَلاَ تُعَسِّرُوا، وَبَشِّرُوا وَلاَ تُنَفِّرُوا",
                "collection": "Sahih al-Bukhari (صحیح البخاری)",
                "hadith_number": "Book 3, Hadith 69 (Sahih)",
                "urdu_translation": "آسانی پیدا کرو اور تنگی نہ لاؤ، اور خوشخبری دو اور نفرت نہ دلاؤ۔",
                "relevance": "A core principle for curriculum design, lesson planning, and student motivation: making educational tasks accessible and encouraging rather than punitive."
            }
        ]
    },
    {
        "keywords": ["assessment", "evaluation", "test", "grading", "justice", "fairness", "adl", "trust", "امانت", "عدل", "جائزہ", "امتحان", "انصاف", "شفافیت"],
        "topic": "Justice, Integrity and Fairness in Assessment and Evaluation",
        "quran": [
            {
                "arabic": "إِنَّ اللَّهَ يَأْمُرُكُمْ أَن تُؤَدُّوا الْأَمَانَاتِ إِلَىٰ أَهْلِهَا وَإِذَا حَكَمْتُم بَيْنَ النَّاسِ أَن تَحْكُمُوا بِالْعَدْلِ",
                "surah_name": "Surah An-Nisa (سورۃ النساء)",
                "surah_number": 4,
                "ayah_numbers": "58",
                "urdu_translation": "بے شک اللہ تمہیں حکم دیتا ہے کہ امانتیں ان کے اہل لوگوں کے سپرد کرو، اور جب لوگوں کے درمیان فیصلہ کرو تو انصاف کے ساتھ فیصلہ کرو۔",
                "relevance": "Directly governs educational assessment: grading, reporting, test evaluation, and examination decisions must be conducted with absolute objectivity and justice."
            },
            {
                "arabic": "يَا أَيُّهَا الَّذِينَ آمَنُوا كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ وَلَوْ عَلَىٰ أَنفُسِكُمْ",
                "surah_name": "Surah An-Nisa (سورۃ النساء)",
                "surah_number": 4,
                "ayah_numbers": "135",
                "urdu_translation": "اے ایمان والو! انصاف پر مضبوطی سے قائم رہنے والے اور اللہ کے واسطے سچی گواہی دینے والے بن جاؤ، خواہ یہ تمہاری اپنی ذات کے خلاف ہی کیوں نہ ہو۔",
                "relevance": "Demands test reliability, rubric objectivity, and elimination of subjective teacher bias during educational measurement."
            }
        ],
        "hadith": [
            {
                "arabic": "كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْئُولٌ عَنْ رَعِيَّتِهِ",
                "collection": "Sahih al-Bukhari (صحیح البخاری)",
                "hadith_number": "Book 11, Hadith 893",
                "urdu_translation": "تم میں سے ہر شخص نگہبان ہے اور تم میں سے ہر ایک سے اس کی رعیت (ذمہ داری) کے بارے میں بازپرس ہوگی۔",
                "relevance": "Reminds teachers and educational administrators of their professional accountability regarding the intellectual, moral, and academic development of students."
            }
        ]
    },
    {
        "keywords": ["research", "inquiry", "verification", "hypothesis", "critical thinking", "evidence", "proof", "تحقیق", "سائنسی طریقہ", "غور و فکر", "تدبر", "تصدیق"],
        "topic": "Critical Inquiry, Verification, and Research Methodology",
        "quran": [
            {
                "arabic": "يَا أَيُّهَا الَّذِينَ آمَنُوا إِن جَاءَكُمْ فَاسِقٌ بِنَبَإٍ فَتَبَيَّنُوا أَن تُصِيبُوا قَوْمًا بِجَهَالَةٍ فَتُصْبِحُوا عَلَىٰ مَا فَعَلْتُمْ نَادِمِينَ",
                "surah_name": "Surah Al-Hujurat (سورۃ الحجرات)",
                "surah_number": 49,
                "ayah_numbers": "6",
                "urdu_translation": "اے ایمان والو! اگر کوئی فاسق تمہارے پاس کوئی خبر لے کر آئے تو خوب تحقیق و تصدیق کر لیا کرو، ایسا نہ ہو کہ تم نادانی میں کسی قوم کو نقصان پہنچا بیٹھو پھر اپنے کیے پر پشیمان ہو۔",
                "relevance": "The foundational principle of scientific inquiry, data verification, literature review, and source criticism in educational research."
            },
            {
                "arabic": "وَلَا تَقْفُ مَا لَيْسَ لَكَ بِهِ عِلْمٌ ۚ إِنَّ السَّمْعَ وَالْبَصَرَ وَالْفُؤَادَ كُلُّ أُولَٰئِكَ كَانَ عَنْهُ مَسْئُولًا",
                "surah_name": "Surah Al-Isra (سورۃ الإسراء)",
                "surah_number": 17,
                "ayah_numbers": "36",
                "urdu_translation": "اور اس بات کے پیچھے نہ پڑو جس کا تمہیں علم نہیں، بے شک کان اور آنکھ اور دل، ان سب کے بارے میں بازپرس کی جائے گی۔",
                "relevance": "Demands empirical observation, intellectual integrity, and avoidance of speculation or unsubstantiated claims in research."
            }
        ],
        "hadith": [
            {
                "arabic": "الْكَلِمَةُ الْحِكْمَةُ ضَالَّةُ الْمُؤْمِنِ فَحَيْثُ وَجَدَهَا فَهُوَ أَحَقُّ بِهَا",
                "collection": "Jami` at-Tirmidhi (جامع الترمذی)",
                "hadith_number": "Hadith 2687",
                "urdu_translation": "حکمت اور دانائی کی بات مومن کی گمشدہ متاع ہے، پس وہ جہاں بھی اسے پائے وہی اس کا زیادہ حق دار ہے۔",
                "relevance": "Encourages broad scientific pursuit, intellectual openness, and cross-cultural adoption of beneficial educational innovations."
            }
        ]
    },
    {
        "keywords": ["leadership", "management", "supervision", "discipline", "consultation", "shura", "قیادت", "انتظام", "نگرانی", "مشاورت", "نظم و ضبط"],
        "topic": "Educational Leadership, Democratic Consultation and Management",
        "quran": [
            {
                "arabic": "وَأَمْرُهُمْ شُورَىٰ بَيْنَهُمْ",
                "surah_name": "Surah Ash-Shura (سورۃ الشوریٰ)",
                "surah_number": 42,
                "ayah_numbers": "38",
                "urdu_translation": "اور ان کا نظامِ باہمی مشاورت سے چلتا ہے۔",
                "relevance": "Establishes democratic participatory management, staff consultation, and collaborative decision-making in school administration."
            }
        ],
        "hadith": [
            {
                "arabic": "إِذَا خَرَجَ ثَلاَثَةٌ فِي سَفَرٍ فَلْيُؤَمِّرُوا أَحَدَهُمْ",
                "collection": "Sunan Abi Dawud (سنن ابی داؤد)",
                "hadith_number": "Book 15, Hadith 2608",
                "urdu_translation": "جب تین آدمی سفر پر نکلیں تو وہ اپنے میں سے ایک کو اپنا امیر (قائد) بنا لیں۔",
                "relevance": "Highlights the necessity of organized organizational structure, defined educational leadership, and institutional delegation."
            }
        ]
    },
    {
        "keywords": ["society", "community", "socialization", "culture", "citizenship", "cooperation", "معاشرہ", "شہریت", "معاشرتی تعلقات", "تعاون", "ثقافت"],
        "topic": "Citizenship, Social Responsibility and Community Engagement",
        "quran": [
            {
                "arabic": "وَتَعَاوَنُوا عَلَى الْبِرِّ وَالتَّقْوَىٰ ۖ وَلَا تَعَاوَنُوا عَلَى الْإِثْمِ وَالْعُدْوَانِ",
                "surah_name": "Surah Al-Ma'idah (سورۃ المائدہ)",
                "surah_number": 5,
                "ayah_numbers": "2",
                "urdu_translation": "اور نیکی اور پرہیزگاری کے کاموں میں ایک دوسرے کا تعاون کرو اور گناہ اور زیادتی کے کاموں میں تعاون نہ کرو۔",
                "relevance": "Foundational mandate for civic responsibility, community partnership, parent-teacher collaboration, and positive socialization in schools."
            }
        ],
        "hadith": [
            {
                "arabic": "خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ",
                "collection": "Al-Mu'jam al-Awsat (المعجم الأوسط للطبرانی)",
                "hadith_number": "Hadith 5787 (Sahih)",
                "urdu_translation": "لوگوں میں سب سے بہترین انسان وہ ہے جو دوسرے انسانوں کے لیے سب سے زیادہ نفع بخش ہو۔",
                "relevance": "Defines active citizenship and the ultimate goal of community engagement: educating individuals who serve society selflessly."
            }
        ]
    }
]

def get_islamic_evidence_for_query(query: str) -> Optional[Dict[str, Any]]:
    query_lower = query.lower()
    best_match = None
    max_hits = 0

    for topic_data in ISLAMIC_TOPIC_EVIDENCE:
        hits = 0
        for kw in topic_data["keywords"]:
            if kw in query_lower:
                hits += 1
        if hits > max_hits:
            max_hits = hits
            best_match = topic_data

    # Return only if genuine relevance detected
    if max_hits >= 1 and best_match:
        return best_match
    return None
