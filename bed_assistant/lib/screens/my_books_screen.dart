import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import 'pdf_viewer_screen.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    final books = provider.books;

    final iconsAndColors = [
      {'color': AppColors.primaryMintGreen, 'icon': Icons.menu_book},
      {'color': AppColors.accentBlue, 'icon': Icons.psychology},
      {'color': const Color(0xFF0D9488), 'icon': Icons.architecture},
      {'color': AppColors.accentOrange, 'icon': Icons.assignment},
      {'color': AppColors.accentPurple, 'icon': Icons.manage_accounts},
      {'color': AppColors.accentAmber, 'icon': Icons.groups},
    ];

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('My Books'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: books.length,
              itemBuilder: (ctx, i) {
                final b = books[i];
                final style = iconsAndColors[i % iconsAndColors.length];
                final clr = style['color'] as Color;
                final icn = style['icon'] as IconData;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: clr.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icn, color: clr, size: 24),
                    ),
                    title: Text(
                      'Book ${b.bookNumber}',
                      style: const TextStyle(
                        color: AppColors.primaryDarkNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          b.title,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '(${b.totalPages} Pages)',
                          style: TextStyle(
                            color: clr,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PdfViewerScreen(
                            bookNumber: b.bookNumber,
                            bookTitle: b.title,
                            initialPage: 1,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
