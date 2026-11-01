import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';
import 'pdf_viewer_screen.dart';

class SourceDetailsScreen extends StatelessWidget {
  final SourceReference source;

  const SourceDetailsScreen({super.key, required this.source});

  int _parseBookNum(String raw) {
    final m = RegExp(r'[0-9]+').firstMatch(raw);
    return m != null ? int.tryParse(m.group(0)!) ?? 1 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final bookNum = _parseBookNum(source.bookNumber);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Source Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 1),

            // Book Cover Card
            Center(
              child: Container(
                width: 140,
                height: 190,
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkNavy,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDarkNavy.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: AppColors.accentAmber, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_stories, color: AppColors.accentAmber, size: 36),
                      const SizedBox(height: 12),
                      Text(
                        source.bookNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        source.bookTitle,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                source.bookNumber,
                style: const TextStyle(
                  color: AppColors.primaryDarkNavy,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                source.bookTitle,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Details Container
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  _buildRow('Chapter', source.chapter.isNotEmpty ? source.chapter : 'Unit 1'),
                  const Divider(height: 20),
                  _buildRow('PDF Page', '${source.pdfPage}'),
                  const Divider(height: 20),
                  _buildRow('Printed Page', source.printedPage.isNotEmpty ? source.printedPage : '${source.pdfPage}'),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Open PDF at Page Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryMintGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.menu_book),
              label: Text(
                'Open PDF at Page ${source.pdfPage}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PdfViewerScreen(
                      bookNumber: bookNum,
                      bookTitle: source.bookTitle,
                      initialPage: source.pdfPage,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryDarkNavy,
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
