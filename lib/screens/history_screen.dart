import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'entry_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<JournalEntry> entries;

  // Function passed from main.dart to delete an entry
  final Function(int) onDelete;

  const HistoryScreen({
    super.key,
    required this.entries,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No journal entries yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];

                return Card(
                  child: ListTile(
                    title: Text(entry.title),
                    subtitle: Text(
                      '${entry.mood} • ${_formatDate(entry.createdAt)}\n${entry.text}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,

                    // Opens full entry detail page
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntryDetailScreen(entry: entry),
                        ),
                      );
                    },

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onDelete(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}