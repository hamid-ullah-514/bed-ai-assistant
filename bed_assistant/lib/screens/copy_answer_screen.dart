import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';

class CopyAnswerScreen extends StatefulWidget {
  final String question;
  final AnswerResponse answer;

  const CopyAnswerScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<CopyAnswerScreen> createState() => _CopyAnswerScreenState();
}

class _CopyAnswerScreenState extends State<CopyAnswerScreen> {
  bool _copied = false;

  String _formatForWord() {
    final b = StringBuffer();
    b.writeln('====================================================');
    b.writeln('B.Ed AI Book Assistant - Academic Research Answer');
    b.writeln('====================================================\n');
    b.writeln('Question: ${widget.question}\n');
    b.writeln('1. Introduction:');
    b.writeln('${widget.answer.introduction}\n');
    b.writeln('2. Main Answer (Headings):');
    for (var h in widget.answer.headings) {
      b.writeln('${h.headingNumber}. ${h.headingTitle}');
      b.writeln(h.explanation);
      if (h.sourceReference != null) {
        final ref = h.sourceReference!;
        b.writeln('Source: ${ref.bookNumber} : ${ref.bookTitle} | Chapter: ${ref.chapter} | PDF Page: ${ref.pdfPage} | Printed Page: ${ref.printedPage}');
      }
      b.writeln('');
    }
    b.writeln('3. Conclusion:');
    b.writeln(widget.answer.conclusion);
    return b.toString();
  }

  @override
  void initState() {
    super.initState();
    // Auto-copy on opening this screen
    Clipboard.setData(ClipboardData(text: _formatForWord()));
    _copied = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Copy Answer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preview Card
                Container(
                  padding: const EdgeInsets.all(18),
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
                        widget.answer.introduction,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 13.5,
                          height: 1.65,
                        ),
                        textAlign: TextAlign.justify,
                        textDirection: widget.answer.introduction.contains(RegExp(r'[\u0600-\u06FF]'))
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                      const Divider(height: 24),
                      if (widget.answer.headings.isNotEmpty) ...[
                        Text(
                          widget.answer.headings.first.headingTitle,
                          style: const TextStyle(
                            color: AppColors.primaryDarkNavy,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: widget.answer.headings.first.headingTitle.contains(RegExp(r'[\u0600-\u06FF]'))
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.answer.headings.first.explanation,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 13,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: widget.answer.headings.first.explanation.contains(RegExp(r'[\u0600-\u06FF]'))
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),

          // Bottom Confirmation Floating Pill (Matching Screen 17)
          if (_copied)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMintGreen,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryMintGreen.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Copied to Clipboard!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
