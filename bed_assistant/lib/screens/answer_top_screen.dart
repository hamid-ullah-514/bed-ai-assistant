import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';
import 'answer_middle_screen.dart';
import 'source_details_screen.dart';
import 'copy_answer_screen.dart';
import 'share_answer_screen.dart';
import 'quran_hadith_screen.dart';

class AnswerTopScreen extends StatelessWidget {
  final String question;
  final AnswerResponse answer;

  const AnswerTopScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final firstSource = answer.sources.isNotEmpty ? answer.sources.first : null;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Answer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            tooltip: 'Save',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Answer saved to favorites')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ShareAnswerScreen(question: question, answer: answer),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightMintBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMintGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Question:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: AppColors.primaryDarkNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Introduction Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Introduction',
                    style: TextStyle(
                      color: AppColors.primaryDarkNavy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    answer.introduction,
                    style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 13.5,
                      height: 1.65,
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: answer.introduction.contains(RegExp(r'[\u0600-\u06FF]'))
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Source References Card
            if (firstSource != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Source References',
                          style: TextStyle(
                            color: AppColors.primaryDarkNavy,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SourceDetailsScreen(source: firstSource),
                              ),
                            );
                          },
                          child: const Icon(Icons.info_outline, size: 18, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• ${firstSource.bookNumber} : ${firstSource.bookTitle}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '  Chapter: ${firstSource.chapter}',
                      style: const TextStyle(fontSize: 12.5, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '  PDF Page: ${firstSource.pdfPage} | Printed Page: ${firstSource.printedPage}',
                      style: const TextStyle(fontSize: 12, color: AppColors.primaryMintGreen, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            // Action Buttons Row (Open PDF, Copy, Share)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMintGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.menu_book, size: 18),
                    label: const Text('Open PDF', style: TextStyle(fontSize: 13)),
                    onPressed: () {
                      if (firstSource != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SourceDetailsScreen(source: firstSource),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy', style: TextStyle(fontSize: 13)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CopyAnswerScreen(question: question, answer: answer),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.share, size: 16),
                    label: const Text('Share', style: TextStyle(fontSize: 13)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ShareAnswerScreen(question: question, answer: answer),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Button to Proceed to Middle Section (Headings 1..20)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.format_list_numbered),
              label: Text(
                'View Main Answer (${answer.headings.length} Headings) →',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AnswerMiddleScreen(question: question, answer: answer),
                  ),
                );
              },
            ),

            if (answer.islamicEvidence != null) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryMintGreen,
                  side: const BorderSide(color: AppColors.primaryMintGreen),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.auto_stories),
                label: const Text(
                  'View Quran & Hadith References →',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuranHadithScreen(
                        evidence: answer.islamicEvidence!,
                        sourceInfo: firstSource != null ? '${firstSource.bookNumber} | Page ${firstSource.pdfPage}' : 'Book 3 | Page 45',
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
