class SourceReference {
  final String bookNumber;
  final String bookTitle;
  final String courseCode;
  final String chapter;
  final int pdfPage;
  final String printedPage;

  SourceReference({
    required this.bookNumber,
    required this.bookTitle,
    required this.courseCode,
    required this.chapter,
    required this.pdfPage,
    required this.printedPage,
  });

  factory SourceReference.fromJson(Map<String, dynamic> json) {
    return SourceReference(
      bookNumber: json['book_number']?.toString() ?? 'Book 1',
      bookTitle: json['book_title']?.toString() ?? '',
      courseCode: json['course_code']?.toString() ?? '',
      chapter: json['chapter']?.toString() ?? '',
      pdfPage: json['pdf_page'] is int
          ? json['pdf_page']
          : int.tryParse(json['pdf_page']?.toString() ?? '1') ?? 1,
      printedPage: json['printed_page']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'book_number': bookNumber,
        'book_title': bookTitle,
        'course_code': courseCode,
        'chapter': chapter,
        'pdf_page': pdfPage,
        'printed_page': printedPage,
      };
}

class HeadingItem {
  final int headingNumber;
  final String headingTitle;
  final String explanation;
  final int wordCount;
  final SourceReference? sourceReference;

  HeadingItem({
    required this.headingNumber,
    required this.headingTitle,
    required this.explanation,
    required this.wordCount,
    this.sourceReference,
  });

  factory HeadingItem.fromJson(Map<String, dynamic> json) {
    return HeadingItem(
      headingNumber: json['heading_number'] is int
          ? json['heading_number']
          : int.tryParse(json['heading_number']?.toString() ?? '1') ?? 1,
      headingTitle: json['heading_title']?.toString() ?? '',
      explanation: json['explanation']?.toString() ?? '',
      wordCount: json['word_count'] is int
          ? json['word_count']
          : (json['explanation']?.toString().split(' ').length ?? 0),
      sourceReference: json['source_reference'] != null
          ? SourceReference.fromJson(
              Map<String, dynamic>.from(json['source_reference']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'heading_number': headingNumber,
        'heading_title': headingTitle,
        'explanation': explanation,
        'word_count': wordCount,
        'source_reference': sourceReference?.toJson(),
      };
}

class QuranItem {
  final String arabic;
  final String surahName;
  final int surahNumber;
  final String ayahNumbers;
  final String urduTranslation;
  final String relevance;

  QuranItem({
    required this.arabic,
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumbers,
    required this.urduTranslation,
    required this.relevance,
  });

  factory QuranItem.fromJson(Map<String, dynamic> json) {
    return QuranItem(
      arabic: json['arabic']?.toString() ?? '',
      surahName: json['surah_name']?.toString() ?? '',
      surahNumber: json['surah_number'] is int
          ? json['surah_number']
          : int.tryParse(json['surah_number']?.toString() ?? '1') ?? 1,
      ayahNumbers: json['ayah_numbers']?.toString() ?? '',
      urduTranslation: json['urdu_translation']?.toString() ?? '',
      relevance: json['relevance']?.toString() ?? '',
    );
  }
}

class HadithItem {
  final String arabic;
  final String collection;
  final String hadithNumber;
  final String urduTranslation;
  final String relevance;

  HadithItem({
    required this.arabic,
    required this.collection,
    required this.hadithNumber,
    required this.urduTranslation,
    required this.relevance,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      arabic: json['arabic']?.toString() ?? '',
      collection: json['collection']?.toString() ?? '',
      hadithNumber: json['hadith_number']?.toString() ?? '',
      urduTranslation: json['urdu_translation']?.toString() ?? '',
      relevance: json['relevance']?.toString() ?? '',
    );
  }
}

class IslamicEvidence {
  final String topic;
  final List<QuranItem> quran;
  final List<HadithItem> hadith;

  IslamicEvidence({
    required this.topic,
    required this.quran,
    required this.hadith,
  });

  factory IslamicEvidence.fromJson(Map<String, dynamic> json) {
    var rawQ = json['quran'] as List? ?? [];
    var rawH = json['hadith'] as List? ?? [];
    return IslamicEvidence(
      topic: json['topic']?.toString() ?? '',
      quran: rawQ
          .map((q) => QuranItem.fromJson(Map<String, dynamic>.from(q)))
          .toList(),
      hadith: rawH
          .map((h) => HadithItem.fromJson(Map<String, dynamic>.from(h)))
          .toList(),
    );
  }
}

class AnswerResponse {
  final bool found;
  final String message;
  final String introduction;
  final List<HeadingItem> headings;
  final IslamicEvidence? islamicEvidence;
  final String conclusion;
  final List<SourceReference> sources;
  final int? historyId;

  AnswerResponse({
    required this.found,
    required this.message,
    required this.introduction,
    required this.headings,
    this.islamicEvidence,
    required this.conclusion,
    required this.sources,
    this.historyId,
  });

  String toFormattedPlainText({String question = ''}) {
    final sb = StringBuffer();
    if (question.isNotEmpty) {
      sb.writeln('سوال (Question): $question\n');
      sb.writeln('========================================\n');
    }
    if (introduction.isNotEmpty) {
      sb.writeln('تعارف (Introduction):');
      sb.writeln(introduction);
      sb.writeln('\n----------------------------------------\n');
    }
    if (headings.isNotEmpty) {
      sb.writeln('تفصیلی عنوانات و جواب (Main Academic Headings):\n');
      for (var h in headings) {
        sb.writeln('${h.headingNumber}. ${h.headingTitle}');
        sb.writeln(h.explanation);
        if (h.sourceReference != null) {
          final s = h.sourceReference!;
          sb.writeln('[ماخذ: ${s.bookNumber} - ${s.bookTitle} | باب: ${s.chapter} | PDF صفحہ: ${s.pdfPage} (پرنٹڈ صفحہ: ${s.printedPage})]');
        }
        sb.writeln('');
      }
      sb.writeln('----------------------------------------\n');
    }
    if (islamicEvidence != null &&
        (islamicEvidence!.quran.isNotEmpty || islamicEvidence!.hadith.isNotEmpty)) {
      sb.writeln('قرآنی و حدیث شواہد (Islamic Evidence):\n');
      for (var q in islamicEvidence!.quran) {
        sb.writeln('قرآن مجید: ${q.arabic}');
        sb.writeln('ترجمہ: ${q.urduTranslation}');
        sb.writeln('سورۃ: ${q.surahName} (آیت: ${q.ayahNumbers})\n');
      }
      for (var hd in islamicEvidence!.hadith) {
        sb.writeln('حدیث نبوی ﷺ: ${hd.arabic}');
        sb.writeln('ترجمہ: ${hd.urduTranslation}');
        sb.writeln('حوالہ: ${hd.collection} (حدیث نمبر: ${hd.hadithNumber})\n');
      }
      sb.writeln('----------------------------------------\n');
    }
    if (conclusion.isNotEmpty) {
      sb.writeln('حاصل کلام (Conclusion):');
      sb.writeln(conclusion);
    }
    return sb.toString();
  }

  factory AnswerResponse.fromJson(Map<String, dynamic> json) {
    var rawHeadings = json['headings'] as List? ?? [];
    List<HeadingItem> hList = rawHeadings
        .map((h) => HeadingItem.fromJson(Map<String, dynamic>.from(h)))
        .toList();

    var rawSources = json['sources'] as List? ?? [];
    List<SourceReference> sList = rawSources
        .map((s) => SourceReference.fromJson(Map<String, dynamic>.from(s)))
        .toList();

    IslamicEvidence? islamic;
    if (json['islamic_evidence'] != null) {
      islamic = IslamicEvidence.fromJson(
          Map<String, dynamic>.from(json['islamic_evidence']));
    }

    return AnswerResponse(
      found: json['found'] ?? true,
      message: json['message']?.toString() ?? '',
      introduction: json['introduction']?.toString() ?? '',
      headings: hList,
      islamicEvidence: islamic,
      conclusion: json['conclusion']?.toString() ?? '',
      sources: sList,
      historyId: json['history_id'],
    );
  }
}
