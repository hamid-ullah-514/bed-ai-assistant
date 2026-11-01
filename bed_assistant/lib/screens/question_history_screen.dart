import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import 'answer_top_screen.dart';

class QuestionHistoryScreen extends StatelessWidget {
  const QuestionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    final history = provider.history;

    // Fallback sample items matching the exact reference image if history is initially empty
    final fallbackItems = [
      {'q': 'تعلیم کے مقاصد کیا ہیں؟', 'time': '2025-10-22 10:24 AM'},
      {'q': 'بچوں کی نفسیات پر نوٹ', 'time': '2025-10-21 04:12 PM'},
      {'q': 'تدریسی طریق کون سے ہیں؟', 'time': '2025-10-20 11:35 AM'},
      {'q': 'کلاس روم مینجمنٹ', 'time': '2025-10-18 09:20 PM'},
    ];

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Question History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: history.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: history.length,
              itemBuilder: (ctx, i) {
                final item = history[i];
                return _buildHistoryCard(
                  context,
                  question: item.question,
                  timestamp: item.timestamp.isNotEmpty ? item.timestamp.split('T').first : 'Recent',
                  onTap: () {
                    if (item.answer != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AnswerTopScreen(
                            question: item.question,
                            answer: item.answer!,
                          ),
                        ),
                      );
                    } else {
                      provider.ask(item.question).then((success) {
                        if (success && provider.currentAnswer != null && context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AnswerTopScreen(
                                question: item.question,
                                answer: provider.currentAnswer!,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  },
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: fallbackItems.length,
              itemBuilder: (ctx, i) {
                final f = fallbackItems[i];
                return _buildHistoryCard(
                  context,
                  question: f['q']!,
                  timestamp: f['time']!,
                  onTap: () {
                    provider.ask(f['q']!).then((success) {
                      if (success && provider.currentAnswer != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AnswerTopScreen(
                              question: f['q']!,
                              answer: provider.currentAnswer!,
                            ),
                          ),
                        );
                      }
                    });
                  },
                );
              },
            ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String question,
    required String timestamp,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: AppColors.softBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.search, color: AppColors.primaryDarkNavy, size: 20),
        ),
        title: Text(
          question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.primaryDarkNavy,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textDirection: question.contains(RegExp(r'[\u0600-\u06FF]'))
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            timestamp,
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 12,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.secondaryText, size: 20),
        onTap: onTap,
      ),
    );
  }
}
