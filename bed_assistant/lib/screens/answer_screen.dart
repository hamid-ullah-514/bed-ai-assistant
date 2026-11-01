import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/answer.dart';
import '../widgets/heading_card.dart';
import '../widgets/islamic_evidence_widget.dart';

class AnswerScreen extends StatelessWidget {
  final String question;
  final AnswerResponse answer;

  const AnswerScreen({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  String _formatAnswerForExport() {
    final buffer = StringBuffer();
    buffer.writeln('====================================================');
    buffer.writeln('B.Ed AI Book Assistant - Academic Research Answer');
    buffer.writeln('====================================================\n');
    buffer.writeln('QUESTION:');
    buffer.writeln('$question\n');
    buffer.writeln('----------------------------------------------------');
    buffer.writeln('1. INTRODUCTION');
    buffer.writeln('----------------------------------------------------');
    buffer.writeln('${answer.introduction}\n');

    buffer.writeln('----------------------------------------------------');
    buffer.writeln('2. MAIN EXAMINATION ANSWER (DETAILED HEADINGS)');
    buffer.writeln('----------------------------------------------------\n');

    for (var h in answer.headings) {
      buffer.writeln('${h.headingNumber}. ${h.headingTitle} [Word Count: ${h.wordCount}]');
      buffer.writeln('${h.explanation}\n');
      if (h.sourceReference != null) {
        final ref = h.sourceReference!;
        buffer.writeln('Source Reference:');
        buffer.writeln('- Book Number: ${ref.bookNumber}');
        buffer.writeln('- Book Title: ${ref.bookTitle}');
        buffer.writeln('- Course Code: ${ref.courseCode}');
        buffer.writeln('- Chapter/Unit: ${ref.chapter}');
        buffer.writeln('- PDF Page: ${ref.pdfPage}');
        if (ref.printedPage.isNotEmpty) {
          buffer.writeln('- Printed Page: ${ref.printedPage}');
        }
        buffer.writeln('');
      }
    }

    if (answer.islamicEvidence != null) {
      final ie = answer.islamicEvidence!;
      buffer.writeln('----------------------------------------------------');
      buffer.writeln('3. QURAN AND AUTHENTIC HADITH EVIDENCE');
      buffer.writeln('(Provided for moral/ethical guidance; distinct from the 6 textbooks)');
      buffer.writeln('----------------------------------------------------\n');
      buffer.writeln('Topic: ${ie.topic}\n');

      for (var q in ie.quran) {
        buffer.writeln('Holy Quran:');
        buffer.writeln('Arabic: ${q.arabic}');
        buffer.writeln('Reference: ${q.surahName} (Surah #${q.surahNumber}, Ayah #${q.ayahNumbers})');
        buffer.writeln('Urdu Translation: ${q.urduTranslation}');
        buffer.writeln('Pedagogical Relevance: ${q.relevance}\n');
      }

      for (var hd in ie.hadith) {
        buffer.writeln('Authentic Hadith:');
        buffer.writeln('Arabic: ${hd.arabic}');
        buffer.writeln('Collection: ${hd.collection} - ${hd.hadithNumber}');
        buffer.writeln('Urdu Translation: ${hd.urduTranslation}');
        buffer.writeln('Pedagogical Relevance: ${hd.relevance}\n');
      }
    }

    buffer.writeln('----------------------------------------------------');
    buffer.writeln('4. CONCLUSION');
    buffer.writeln('----------------------------------------------------');
    buffer.writeln('${answer.conclusion}\n');
    buffer.writeln('====================================================');
    buffer.writeln('Answer strictly retrieved from official Allama Iqbal Open University (AIOU) B.Ed 1.5 Year Textbooks.');
    return buffer.toString();
  }

  void _copyToClipboard(BuildContext context) {
    final text = _formatAnswerForExport();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Complete answer copied (Formatted for MS Word)'),
          ],
        ),
        backgroundColor: Color(0xFF059669),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _shareAnswer(BuildContext context) {
    final text = _formatAnswerForExport();
    Share.share(
      text,
      subject: 'B.Ed AI Answer: ${question.length > 40 ? '${question.substring(0, 40)}...' : question}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Academic Answer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Answer for Word',
            onPressed: () => _copyToClipboard(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Answer',
            onPressed: () => _shareAnswer(context),
          ),
        ],
      ),
      body: answer.found == false
          ? _buildNotFoundView(context, isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Question Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.help_outline, color: theme.colorScheme.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Submitted Question / امتحانی سوال',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          question,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Introduction Section
                  _buildSectionCard(
                    context: context,
                    title: '1. Introduction / تعارف',
                    icon: Icons.article_outlined,
                    child: Text(
                      answer.introduction,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.65,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Main Answer Title
                  Row(
                    children: [
                      Icon(Icons.format_list_numbered, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        '2. Main Answer (${answer.headings.length} Headings)',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Target ~300 words per heading strictly sourced from the six B.Ed textbooks.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 20 Headings
                  ...answer.headings.map((h) => HeadingCardWidget(heading: h)),

                  // Quran and Hadith Evidence
                  if (answer.islamicEvidence != null)
                    IslamicEvidenceWidget(evidence: answer.islamicEvidence!),

                  const SizedBox(height: 16),

                  // Conclusion Section
                  _buildSectionCard(
                    context: context,
                    title: '3. Conclusion / حاصل کلام و اختتامیہ',
                    icon: Icons.check_circle_outline,
                    child: Text(
                      answer.conclusion,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.65,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059669),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy for MS Word', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => _copyToClipboard(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.share),
                          label: const Text('Share Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () => _shareAnswer(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildNotFoundView(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, size: 64, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            const Text(
              'Not Found in the 6 B.Ed Books',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              answer.introduction,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Return to Question Screen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
