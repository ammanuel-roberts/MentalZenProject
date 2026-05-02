import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class InsightsScreen extends StatelessWidget {
  final List<JournalEntry> entries;

  const InsightsScreen({
    super.key,
    required this.entries,
  });

  String _getMostCommonMood() {
    if (entries.isEmpty) {
      return 'No mood data yet';
    }

    final Map<String, int> moodCounts = {};

    for (final entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    String mostCommonMood = moodCounts.keys.first;
    int highestCount = moodCounts[mostCommonMood] ?? 0;

    moodCounts.forEach((mood, count) {
      if (count > highestCount) {
        mostCommonMood = mood;
        highestCount = count;
      }
    });

    return mostCommonMood;
  }

  int _countMood(String mood) {
    int count = 0;

    for (final entry in entries) {
      if (entry.mood == mood) {
        count++;
      }
    }

    return count;
  }

  String _getSuggestion() {
    if (entries.isEmpty) {
      return 'Try writing your first journal entry today.';
    }

    final int stressedCount = _countMood('Stressed');
    final int sadCount = _countMood('Sad');

    if (stressedCount >= 3) {
      return 'You have logged stress several times. Consider taking a short break or doing a breathing exercise.';
    }

    if (sadCount >= 2) {
      return 'You have logged feeling sad more than once. Try writing about one positive moment from your day.';
    }

    return 'Your recent mood pattern looks stable. Keep checking in with yourself.';
  }

  int _entriesThisWeek() {
    final DateTime now = DateTime.now();
    final DateTime weekAgo = now.subtract(const Duration(days: 7));

    int count = 0;

    for (final entry in entries) {
      if (entry.createdAt.isAfter(weekAgo)) {
        count++;
      }
    }

    return count;
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String mostCommonMood = _getMostCommonMood();
    final String suggestion = _getSuggestion();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mood Insights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _buildInfoCard('Total Entries', entries.length.toString()),

          _buildInfoCard('Entries This Week', _entriesThisWeek().toString()),

          _buildInfoCard('Most Common Mood', mostCommonMood),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wellness Suggestion',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    suggestion,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}