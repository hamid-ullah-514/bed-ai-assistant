class UnitModel {
  final int unit;
  final String title;

  UnitModel({required this.unit, required this.title});

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      unit: json['unit'] ?? 1,
      title: json['title'] ?? '',
    );
  }
}

class BookModel {
  final int bookNumber;
  final String courseCode;
  final String title;
  final String authorDept;
  final String university;
  final String pdfPath;
  final bool isScanned;
  final int totalPages;
  final int indexedPages;
  final List<UnitModel> units;

  BookModel({
    required this.bookNumber,
    required this.courseCode,
    required this.title,
    required this.authorDept,
    required this.university,
    required this.pdfPath,
    required this.isScanned,
    this.totalPages = 0,
    this.indexedPages = 0,
    required this.units,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    var rawUnits = json['units'] as List? ?? [];
    List<UnitModel> unitsList =
        rawUnits.map((u) => UnitModel.fromJson(u)).toList();

    return BookModel(
      bookNumber: json['book_number'] ?? 1,
      courseCode: json['course_code'] ?? '',
      title: json['title'] ?? '',
      authorDept: json['author_dept'] ?? '',
      university: json['university'] ?? '',
      pdfPath: json['pdf_path'] ?? '',
      isScanned: json['is_scanned'] ?? false,
      totalPages: json['total_pages'] ?? 0,
      indexedPages: json['indexed_pages'] ?? 0,
      units: unitsList,
    );
  }
}
