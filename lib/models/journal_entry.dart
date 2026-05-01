class JournalEntry {
  final String title;
  final String text;
  final String mood;
  final DateTime createdAt;

  JournalEntry({
    required this.title,
    required this.text,
    required this.mood,
    required this.createdAt,
  });
}