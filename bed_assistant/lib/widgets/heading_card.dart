import 'package:flutter/material.dart';
import '../models/answer.dart';
import 'source_badge.dart';

class HeadingCardWidget extends StatelessWidget {
  final HeadingItem heading;

  const HeadingCardWidget({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1.5,
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
            // Heading Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    '${heading.headingNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    heading.headingTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${heading.wordCount} words',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // In-depth explanation
            Text(
              heading.explanation,
              style: TextStyle(
                fontSize: 14,
                height: 1.65,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
              textAlign: TextAlign.justify,
            ),

            // Inline Verified Source Reference
            if (heading.sourceReference != null) ...[
              const SizedBox(height: 8),
              SourceBadgeWidget(ref: heading.sourceReference!),
            ],
          ],
        ),
      ),
    );
  }
}
