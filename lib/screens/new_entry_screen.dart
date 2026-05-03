import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';
import '../services/firestore_service.dart';

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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController entryController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  String selectedMood = 'Neutral';
  bool isSaving = false;

  final List<String> moods = [
    'Happy',
    'Calm',
    'Neutral',
    'Stressed',
    'Sad',
  ];

  Future<void> saveEntry() async {
    if (titleController.text.trim().isEmpty ||
        entryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title and journal entry')),
      );
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save entries')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final String entryId = DateTime.now().millisecondsSinceEpoch.toString();

    final entry = JournalEntry(
      entryId: entryId,
      userId: user.uid,
      title: titleController.text.trim(),
      text: entryController.text.trim(),
      mood: selectedMood,
      createdAt: DateTime.now(),
    );

    try {
      await firestoreService.addEntry(entry);

      widget.onEntrySaved(entry);

      titleController.clear();
      entryController.clear();

      setState(() {
        selectedMood = 'Neutral';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved to Firestore')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving entry')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    entryController.dispose();
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
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Entry Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: entryController,
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
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: selectedMood == mood,
                  onSelected: (selected) {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveEntry,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}