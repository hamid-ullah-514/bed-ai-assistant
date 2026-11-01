import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../models/answer.dart';

class ShareAnswerScreen extends StatelessWidget {
  final String question;
  final AnswerResponse answer;

  const ShareAnswerScreen({
    super.key,
    required this.question,
    required this.answer,
  });

  String _formatText() {
    final b = StringBuffer();
    b.writeln('B.Ed AI Book Assistant - Academic Research Answer\n');
    b.writeln('Question: $question\n');
    b.writeln('--- Introduction ---');
    b.writeln('${answer.introduction}\n');
    b.writeln('--- Main Answer ---');
    for (var h in answer.headings) {
      b.writeln('${h.headingNumber}. ${h.headingTitle}');
      b.writeln(h.explanation);
      if (h.sourceReference != null) {
        b.writeln('Source: ${h.sourceReference!.bookNumber} | Page ${h.sourceReference!.pdfPage}');
      }
      b.writeln('');
    }
    b.writeln('--- Conclusion ---');
    b.writeln(answer.conclusion);
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              AppLogo(size: 36),
              SizedBox(width: 10),
              Text(
                'B.Ed AI Book Assistant',
                style: TextStyle(
                  color: AppColors.primaryDarkNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Question Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.lightMintBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Question: $question',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryDarkNavy,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: question.contains(RegExp(r'[\u0600-\u06FF]'))
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
                const SizedBox(height: 4),
                const Text(
                  '(Answer from 6 Books)',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Green Button: Share via WhatsApp
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.chat_bubble_outline, size: 20),
            label: const Text('Share via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
              Share.share(_formatText());
            },
          ),

          const SizedBox(height: 10),

          // Blue Button: Share via Other Apps
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.share_outlined, size: 20),
            label: const Text('Share via Other Apps', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
              Share.share(_formatText());
            },
          ),

          const SizedBox(height: 10),

          // Outlined Button: Copy to Clipboard
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDarkNavy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy to Clipboard', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _formatText()));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✔ Copied to Clipboard!'),
                  backgroundColor: AppColors.primaryMintGreen,
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // Cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText)),
          ),
        ],
      ),
    );
  }
}
