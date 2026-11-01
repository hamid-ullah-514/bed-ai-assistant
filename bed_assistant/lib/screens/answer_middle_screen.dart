import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';
import 'answer_bottom_screen.dart';
import 'pdf_viewer_screen.dart';

class AnswerMiddleScreen extends StatefulWidget {
  final String question;
  final AnswerResponse answer;

  const AnswerMiddleScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<AnswerMiddleScreen> createState() => _AnswerMiddleScreenState();
}

class _AnswerMiddleScreenState extends State<AnswerMiddleScreen> {
  int _currentIndex = 0; // Page / heading pointer

  int _parseBookNum(String raw) {
    final m = RegExp(r'[0-9]+').firstMatch(raw);
    return m != null ? int.tryParse(m.group(0)!) ?? 1 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final headings = widget.answer.headings;
    final total = headings.length;

    // Display 2 headings per view to match Screen 7 closely
    final firstIdx = _currentIndex;
    final secondIdx = (_currentIndex + 1 < total) ? _currentIndex + 1 : null;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Main Answer'),
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
                  if (firstIdx < total) _buildHeadingCard(headings[firstIdx]),
                  if (secondIdx != null) ...[
                    const SizedBox(height: 12),
                    _buildHeadingCard(headings[secondIdx]),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Pagination Bar: < 1/20 >
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
                  color: _currentIndex > 0 ? AppColors.primaryMintGreen : Colors.grey.shade400,
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex = (_currentIndex - 2).clamp(0, total - 1))
                      : null,
                ),
                GestureDetector(
                  onTap: () {
                    // Quick jump to bottom section
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AnswerBottomScreen(
                          question: widget.question,
                          answer: widget.answer,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lightMintBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${firstIdx + 1}/$total',
                      style: const TextStyle(
                        color: AppColors.primaryMintGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  color: AppColors.primaryMintGreen,
                  onPressed: () {
                    if (_currentIndex + 2 < total) {
                      setState(() => _currentIndex += 2);
                    } else {
                      // Navigate to Bottom section
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AnswerBottomScreen(
                            question: widget.question,
                            answer: widget.answer,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingCard(HeadingItem heading) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Source: ${ref.bookNumber} | Page ${ref.pdfPage}',
                  style: const TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    final bNum = _parseBookNum(ref.bookNumber);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(
                          bookNumber: bNum,
                          bookTitle: ref.bookTitle,
                          initialPage: ref.pdfPage,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new, size: 14, color: AppColors.primaryMintGreen),
                      SizedBox(width: 4),
                      Text(
                        'View PDF',
                        style: TextStyle(
                          color: AppColors.primaryMintGreen,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
