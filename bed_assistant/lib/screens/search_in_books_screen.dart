import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import 'pdf_viewer_screen.dart';

class SearchInBooksScreen extends StatefulWidget {
  const SearchInBooksScreen({super.key});

  @override
  State<SearchInBooksScreen> createState() => _SearchInBooksScreenState();
}

class _SearchInBooksScreenState extends State<SearchInBooksScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _defaultSuggestions = [
    {'title': 'تعلیم کے مقاصد اور تدریس', 'book': 1, 'bookTitle': 'General Methods of Teaching', 'page': 24, 'color': AppColors.primaryMintGreen},
    {'title': 'بچوں کی نفسیات اور تعلیمی جائزہ', 'book': 2, 'bookTitle': 'Educational Assessment', 'page': 47, 'color': AppColors.accentAmber},
    {'title': 'تدریسی طریقے اور نصاب سازی', 'book': 3, 'bookTitle': 'Curriculum Development', 'page': 76, 'color': const Color(0xFF0D9488)},
    {'title': 'تعلیمی تحقیق اور سائنسی طریقہ', 'book': 4, 'bookTitle': 'Research Methods in Education', 'page': 112, 'color': AppColors.accentOrange},
    {'title': 'کلاس روم مینجمنٹ اور قیادت', 'book': 5, 'bookTitle': 'Educational Leadership', 'page': 58, 'color': AppColors.accentPurple},
    {'title': 'تحقیقی مقالہ اور معاشرتی کردار', 'book': 6, 'bookTitle': 'Citizenship Education', 'page': 89, 'color': AppColors.accentBlue},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<AssistantProvider>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    final liveResults = provider.searchResults;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Search in Books'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search in all books...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.secondaryText),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearch,
                onChanged: (val) {
                  if (val.length > 2) _onSearch(val);
                },
              ),
            ),
          ),

          // Results List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : liveResults.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: liveResults.length,
                        itemBuilder: (ctx, i) {
                          final item = liveResults[i];
                          final bNum = item['book_number'] ?? 1;
                          final bTitle = item['book_title'] ?? 'Book $bNum';
                          final pNum = item['pdf_page'] ?? 1;
                          final secHeading = item['section_heading'] ?? item['unit_title'] ?? 'Topic';

                          return _buildResultCard(
                            title: secHeading.toString().isNotEmpty ? secHeading.toString() : 'Topic in $bTitle',
                            bookNum: bNum,
                            bookTitle: bTitle,
                            page: pNum,
                            color: AppColors.primaryMintGreen,
                          );
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: _defaultSuggestions.length,
                        itemBuilder: (ctx, i) {
                          final s = _defaultSuggestions[i];
                          return _buildResultCard(
                            title: s['title'],
                            bookNum: s['book'],
                            bookTitle: s['bookTitle'],
                            page: s['page'],
                            color: s['color'],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required int bookNum,
    required String bookTitle,
    required int page,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.menu_book, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDarkNavy,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'Book $bookNum | Page $page',
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText, size: 20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(
                bookNumber: bookNum,
                bookTitle: bookTitle,
                initialPage: page,
              ),
            ),
          );
        },
      ),
    );
  }
}
