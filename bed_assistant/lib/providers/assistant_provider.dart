import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/answer.dart';
import '../models/history_item.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AssistantProvider with ChangeNotifier {
  List<BookModel> _books = [];
  final Set<int> _selectedBookNumbers = {};
  bool _isLoading = false;
  String? _currentError;
  AnswerResponse? _currentAnswer;
  String _currentQuestion = '';
  List<HistoryItem> _history = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isServerOnline = false;
  String _serverStatusMessage = 'Checking connection...';
  bool _isDarkMode = false;

  List<BookModel> get books => _books;
  Set<int> get selectedBookNumbers => _selectedBookNumbers;
  bool get isLoading => _isLoading;
  String? get currentError => _currentError;
  AnswerResponse? get currentAnswer => _currentAnswer;
  String get currentQuestion => _currentQuestion;
  List<HistoryItem> get history => _history;
  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isServerOnline => _isServerOnline;
  String get serverStatusMessage => _serverStatusMessage;
  bool get isDarkMode => _isDarkMode;

  Future<void> init() async {
    _isDarkMode = await StorageService.isDarkMode();
    notifyListeners();
    await checkConnection();
    await loadBooks();
    await loadHistory();
  }

  Future<void> checkConnection() async {
    final status = await ApiService.checkStatus();
    if (status['status'] == 'online') {
      _isServerOnline = true;
      final db = status['database'] ?? {};
      _serverStatusMessage = 'Online (${db['total_indexed_pages'] ?? 0} pages indexed)';
    } else {
      _isServerOnline = false;
      _serverStatusMessage = 'Backend Offline';
    }
    notifyListeners();
  }

  Future<void> loadBooks() async {
    _books = await ApiService.getBooks();
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = await ApiService.getHistory();
    notifyListeners();
  }

  void toggleBookSelection(int bookNumber) {
    if (_selectedBookNumbers.contains(bookNumber)) {
      _selectedBookNumbers.remove(bookNumber);
    } else {
      _selectedBookNumbers.add(bookNumber);
    }
    notifyListeners();
  }

  void selectAllBooks() {
    _selectedBookNumbers.clear();
    notifyListeners();
  }

  Future<bool> ask(String question, {String? language}) async {
    if (question.trim().isEmpty) return false;

    _isLoading = true;
    _currentError = null;
    _currentQuestion = question.trim();
    notifyListeners();

    try {
      final selectedList = _selectedBookNumbers.isEmpty ? null : _selectedBookNumbers.toList();
      _currentAnswer = await ApiService.askQuestion(
        question: _currentQuestion,
        bookNumbers: selectedList,
        language: language,
      );
      await loadHistory();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _currentError = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    _isLoading = true;
    notifyListeners();
    final selectedList = _selectedBookNumbers.isEmpty ? null : _selectedBookNumbers.toList();
    _searchResults = await ApiService.searchPassages(
      query: query.trim(),
      bookNumbers: selectedList,
    );
    _isLoading = false;
    notifyListeners();
  }

  void setAnswerDirectly(String question, AnswerResponse answer) {
    _currentQuestion = question;
    _currentAnswer = answer;
    notifyListeners();
  }

  Future<void> deleteHistory(int id) async {
    final success = await ApiService.deleteHistory(id);
    if (success) {
      _history.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
