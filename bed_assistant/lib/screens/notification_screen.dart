import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../providers/assistant_provider.dart';
import 'answer_top_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primaryDarkNavy),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Large Digital Clock (Matching Screen 18)
            const Text(
              '10:24',
              style: TextStyle(
                color: AppColors.primaryDarkNavy,
                fontSize: 64,
                fontWeight: FontWeight.w300,
                letterSpacing: -2,
              ),
            ),
            const Text(
              'Tue, Oct 22',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 36),

            // Notification Card (Matching Screen 18)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () {
                  // Direct navigation to Answer Screen
                  const sampleQ = 'تعلیم کے مقاصد کیا ہیں؟';
                  if (provider.currentAnswer != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AnswerTopScreen(
                          question: provider.currentQuestion.isNotEmpty ? provider.currentQuestion : sampleQ,
                          answer: provider.currentAnswer!,
                        ),
                      ),
                    );
                  } else {
                    provider.ask(sampleQ).then((success) {
                      if (success && provider.currentAnswer != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AnswerTopScreen(
                              question: sampleQ,
                              answer: provider.currentAnswer!,
                            ),
                          ),
                        );
                      }
                    });
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppLogo(size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'B.Ed AI Book Assistant',
                                  style: TextStyle(
                                    color: AppColors.primaryDarkNavy,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'now',
                                  style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Your Answer for "تعلیم کے مقاصد کیا ہیں؟" is ready. Tap to view.',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            const Text(
              'Tap notification to view examination answer',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
