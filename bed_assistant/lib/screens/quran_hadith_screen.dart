import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/answer.dart';

class QuranHadithScreen extends StatelessWidget {
  final IslamicEvidence evidence;
  final String sourceInfo;

  const QuranHadithScreen({
    super.key,
    required this.evidence,
    this.sourceInfo = 'Book 3 | Page 45',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Quran & Hadith References'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quran Cards
            ...evidence.quran.map((q) => _buildQuranCard(q)),

            const SizedBox(height: 12),

            // Hadith Cards
            ...evidence.hadith.map((h) => _buildHadithCard(h)),

            const SizedBox(height: 16),

            // Source Footer Tag (matching reference image)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Source: $sourceInfo',
                  style: const TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranCard(QuranItem q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.lightMintBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book, color: AppColors.primaryMintGreen, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'قرآن مجید سے دلیل',
                style: TextStyle(
                  color: AppColors.primaryDarkNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Arabic verse
          Text(
            q.arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMintGreen,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 6),
          Text(
            '(${q.surahName} : ${q.ayahNumbers})',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 20),
          // Urdu translation
          Text(
            q.urduTranslation,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.primaryText,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
          if (q.relevance.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              q.relevance,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.secondaryText,
                fontStyle: FontStyle.italic,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHadithCard(HadithItem h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bookmark_added, color: AppColors.accentPurple, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'حدیث سے دلیل',
                style: TextStyle(
                  color: AppColors.primaryDarkNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Arabic
          Text(
            h.arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: AppColors.accentPurple,
              height: 1.8,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 10),
          // Urdu translation
          Text(
            h.urduTranslation,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.primaryText,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            '(${h.collection} : ${h.hadithNumber})',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
