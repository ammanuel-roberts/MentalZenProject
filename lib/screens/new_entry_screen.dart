import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class NewEntryScreen extends StatefulWidget {
  final Function(JournalEntry) onEntrySaved;

  const NewEntryScreen({
    super.key,
    required this.onEntrySaved,
  });

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _entryController = TextEditingController();

  String _selectedMood = 'Neutral';

  final List<String> _moods = [
    'Happy',
    'Calm',
    'Neutral',
    'Stressed',
    'Sad',
  ];

  void _saveEntry() {
    if (_titleController.text.trim().isEmpty ||
        _entryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and journal entry')),
      );
      return;
    }

    final entry = JournalEntry(
      title: _titleController.text.trim(),
      text: _entryController.text.trim(),
      mood: _selectedMood,
      createdAt: DateTime.now(),
    );

    widget.onEntrySaved(entry);

    _titleController.clear();
    _entryController.clear();

    setState(() {
      _selectedMood = 'Neutral';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved')),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Entry Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _entryController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Write your thoughts...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mood',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: _selectedMood == mood,
                  onSelected: (selected) {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}