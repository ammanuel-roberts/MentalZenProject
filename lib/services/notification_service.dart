import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> setupNotifications(String userId) async {
    await messaging.requestPermission();

    final token = await messaging.getToken();

    if (token != null) {
      await firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'notificationsEnabled': true,
      }, SetOptions(merge: true));
    }

    return token;
  }
}