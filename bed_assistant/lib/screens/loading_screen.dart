import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/assistant_provider.dart';
import 'answer_top_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String question;

  const LoadingScreen({super.key, required this.question});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _floatingAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _floatingAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _executeSearch();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _executeSearch() async {
    final provider = context.read<AssistantProvider>();
    final success = await provider.ask(widget.question);

    if (mounted) {
      if (success && provider.currentAnswer != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AnswerTopScreen(
              question: widget.question,
              answer: provider.currentAnswer!,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.currentError ?? 'Failed to retrieve answer'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Floating AI Robot Character
              AnimatedBuilder(
                animation: _floatingAnim,
                builder: (ctx, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnim.value),
                    child: child,
                  );
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.lightMintBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryMintGreen.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.smart_toy_rounded,
                          size: 52,
                          color: AppColors.primaryMintGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              const Text(
                'Searching in 6 Books...',
                style: TextStyle(
                  color: AppColors.primaryDarkNavy,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Please wait while we find the\nbest answer for you...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryMintGreen),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'This may take a few seconds.',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
