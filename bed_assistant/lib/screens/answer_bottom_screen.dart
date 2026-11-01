import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';
import 'quran_hadith_screen.dart';

class AnswerBottomScreen extends StatelessWidget {
  final String question;
  final AnswerResponse answer;

  const AnswerBottomScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final headings = answer.headings;
    final total = headings.length;

    // Display the final headings (e.g. 18, 19, 20)
    final finalHeadings = total > 3 ? headings.sublist(total - 3) : headings;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Conclusion & Final Headings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Final Headings (Cards 18, 19, 20)
                  ...finalHeadings.map((h) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildFinalHeadingCard(h),
                      )),

                  // Conclusion Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Conclusion',
                          style: TextStyle(
                            color: AppColors.primaryDarkNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          answer.conclusion,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 13.5,
                            height: 1.65,
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: answer.conclusion.contains(RegExp(r'[\u0600-\u06FF]'))
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Button to Quran & Hadith Screen
                  if (answer.islamicEvidence != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMintGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.menu_book),
                      label: const Text(
                        'Quran & Hadith References Screen →',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuranHadithScreen(
                              evidence: answer.islamicEvidence!,
                              sourceInfo: answer.sources.isNotEmpty
                                  ? '${answer.sources.first.bookNumber} | Page ${answer.sources.first.pdfPage}'
                                  : 'Book 3 | Page 45',
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Pagination Bar: < 20/20 >
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.lightBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  color: AppColors.primaryMintGreen,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightMintBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$total/$total',
                    style: const TextStyle(
                      color: AppColors.primaryMintGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  color: AppColors.primaryMintGreen,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Completed all 20 headings of the answer.')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalHeadingCard(HeadingItem heading) {
    final ref = heading.sourceReference;
    final isUrdu = heading.headingTitle.contains(RegExp(r'[\u0600-\u06FF]'));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading.headingTitle,
            style: const TextStyle(
              color: AppColors.primaryDarkNavy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 10),
          Text(
            heading.explanation,
            style: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 13.5,
              height: 1.65,
            ),
            textAlign: TextAlign.justify,
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          if (ref != null)
            Text(
              'Source: ${ref.bookNumber} | Page ${ref.pdfPage}',
              style: const TextStyle(
                color: AppColors.accentBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
