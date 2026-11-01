import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assistant_provider.dart';
import '../models/history_item.dart';
import 'answer_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssistantProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredList = provider.history.where((h) {
      if (_filter.isEmpty) return true;
      return h.question.toLowerCase().contains(_filter.toLowerCase()) ||
          h.summary.toLowerCase().contains(_filter.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question & Answer History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter previous questions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _filter = ''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onChanged: (val) => setState(() => _filter = val),
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 64, color: isDark ? Colors.white24 : Colors.black26),
                        const SizedBox(height: 12),
                        const Text('No previous questions found'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    itemCount: filteredList.length,
                    itemBuilder: (ctx, i) {
                      final item = filteredList[i];
                      return _buildHistoryCard(context, item, provider, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(
      BuildContext context, HistoryItem item, AssistantProvider provider, bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: item.language == 'Urdu' ? Colors.teal : Colors.blueGrey,
          child: Text(
            item.language == 'Urdu' ? 'اردو' : 'EN',
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          item.question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.timestamp.isNotEmpty ? item.timestamp.split('T').first : '',
            style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              tooltip: 'Delete',
              onPressed: () => provider.deleteHistory(item.id),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () async {
          if (item.answer != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AnswerScreen(
                  question: item.question,
                  answer: item.answer!,
                ),
              ),
            );
          } else {
            final navigator = Navigator.of(context);
            final success = await provider.ask(item.question);
            if (success && provider.currentAnswer != null && mounted) {
              navigator.push(
                MaterialPageRoute(
                  builder: (_) => AnswerScreen(
                    question: item.question,
                    answer: provider.currentAnswer!,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
