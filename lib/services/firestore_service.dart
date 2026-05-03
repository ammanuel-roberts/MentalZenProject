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
}