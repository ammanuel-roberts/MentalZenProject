import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String entryId;
  final String userId;
  final String title;
  final String text;
  final String mood;
  final DateTime createdAt;

  JournalEntry({
    required this.entryId,
    required this.userId,
    required this.title,
    required this.text,
    required this.mood,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'entryId': entryId,
      'userId': userId,
      'title': title,
      'text': text,
      'mood': mood,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory JournalEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['createdAt'];

    DateTime createdAt = DateTime.now();

    if (timestamp is Timestamp) {
      createdAt = timestamp.toDate();
    }

    return JournalEntry(
      entryId: data['entryId'] ?? doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      text: data['text'] ?? '',
      mood: data['mood'] ?? 'Neutral',
      createdAt: createdAt,
    );
  }
}