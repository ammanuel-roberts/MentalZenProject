import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_entry.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference getEntriesCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('entries');
  }

  Future<void> addEntry(JournalEntry entry) async {
    await getEntriesCollection(entry.userId)
        .doc(entry.entryId)
        .set(entry.toMap());
  }

  Future<List<JournalEntry>> getEntries(String userId) async {
    final snapshot = await getEntriesCollection(userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return JournalEntry.fromDocument(doc);
    }).toList();
  }
}