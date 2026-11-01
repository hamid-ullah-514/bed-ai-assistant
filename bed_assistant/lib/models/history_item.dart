import 'answer.dart';

class HistoryItem {
  final int id;
  final String timestamp;
  final String question;
  final String language;
  final List<int> bookNumbers;
  final AnswerResponse? answer;
  final String summary;

  HistoryItem({
    required this.id,
    required this.timestamp,
    required this.question,
    required this.language,
    required this.bookNumbers,
    this.answer,
    required this.summary,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    List<int> books = [];
    if (json['book_numbers'] is List) {
      books = (json['book_numbers'] as List).map((e) => e as int).toList();
    }

    AnswerResponse? ans;
    if (json['answer_json'] != null && json['answer_json'] is Map) {
      try {
        ans = AnswerResponse.fromJson(Map<String, dynamic>.from(json['answer_json']));
      } catch (_) {}
    }

    return HistoryItem(
      id: json['id'] ?? 0,
      timestamp: json['timestamp']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      language: json['language']?.toString() ?? 'English',
      bookNumbers: books,
      answer: ans,
      summary: json['summary']?.toString() ?? '',
    );
  }
}
