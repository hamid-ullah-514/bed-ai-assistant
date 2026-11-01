import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            // Centered Logo and App Name
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 110),
                  const SizedBox(height: 24),
                  const Text(
                    'B.Ed AI',
                    style: TextStyle(
                      color: AppColors.primaryDarkNavy,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'Book Assistant',
                    style: TextStyle(
                      color: AppColors.primaryDarkNavy,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your Study Partner',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Powered by 6 PDF Books',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            // Bottom Decorative Waves and Tagline
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 24, top: 20),
              decoration: const BoxDecoration(
                color: AppColors.lightMintBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: const Text(
                'Learn  •  Research  •  Succeed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryMintGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
