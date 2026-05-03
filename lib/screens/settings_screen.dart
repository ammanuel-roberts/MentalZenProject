import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService authService = AuthService();
  final NotificationService notificationService = NotificationService();

  String notificationStatus = 'Not set up yet';
  bool isLoading = false;

  Future<void> setupNotifications() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        notificationStatus = 'No user is logged in';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final token = await notificationService.setupNotifications(user.uid);

      setState(() {
        notificationStatus = token == null
            ? 'Could not get FCM token'
            : 'Notifications set up successfully';
      });
    } catch (e) {
      setState(() {
        notificationStatus = 'Notification setup failed: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signOut() async {
    await authService.logout();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Logged in user'),
            subtitle: Text(user?.email ?? 'No user'),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Daily Reminder Setup'),
            subtitle: Text(notificationStatus),
          ),

          ElevatedButton(
            onPressed: isLoading ? null : setupNotifications,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Set Up Notifications'),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}