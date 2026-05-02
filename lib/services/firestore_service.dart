import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to entries collection
  CollectionReference getEntriesCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('entries');
  }
}