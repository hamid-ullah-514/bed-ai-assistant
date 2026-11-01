import 'package:flutter/material.dart';
import '../models/answer.dart';

class IslamicEvidenceWidget extends StatelessWidget {
  final IslamicEvidence evidence;

  const IslamicEvidenceWidget({Key? key, required this.evidence}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F291E) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF059669),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF059669),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quran & Hadith Evidence / قرآنی و نبوی شواہد',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Topic: ${evidence.topic}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Notice: The following authentic Islamic evidence is provided for ethical and pedagogical enrichment, kept strictly distinct from the primary B.Ed textbook contents.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 11.5,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),

          // Quran Section
          if (evidence.quran.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Holy Quran / آیاتِ بینات',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...evidence.quran.map((q) => _buildQuranCard(context, q, isDark)),
          ],

          // Hadith Section
          if (evidence.hadith.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Authentic Hadith / احادیثِ مبارکہ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...evidence.hadith.map((h) => _buildHadithCard(context, h, isDark)),
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildQuranCard(BuildContext context, QuranItem q, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF133627) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              q.arabic,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                height: 1.8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF065F46),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 8),
          // Citation
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${q.surahName} (Surah #${q.surahNumber}, Ayah #${q.ayahNumbers})',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Urdu Translation
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'ترجمہ: ${q.urduTranslation}',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 6),
          // Educational Relevance
          Text(
            'Pedagogical Relevance: ${q.relevance}',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithCard(BuildContext context, HadithItem h, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF133627) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic Text
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              h.arabic,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 17,
                height: 1.8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF065F46),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 8),
          // Citation
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${h.collection} - ${h.hadithNumber}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Urdu Translation
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'ترجمہ: ${h.urduTranslation}',
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 6),
          // Relevance
          Text(
            'Pedagogical Relevance: ${h.relevance}',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
