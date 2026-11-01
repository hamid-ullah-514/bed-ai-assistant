import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.lightMintBackground,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryMintGreen.withValues(alpha: 0.3), width: 2),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Graduation Cap & Open Book Icon
            Icon(
              Icons.school_rounded,
              size: size * 0.48,
              color: AppColors.primaryDarkNavy,
            ),
            Positioned(
              bottom: size * 0.14,
              child: Icon(
                Icons.menu_book_rounded,
                size: size * 0.42,
                color: AppColors.primaryMintGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
