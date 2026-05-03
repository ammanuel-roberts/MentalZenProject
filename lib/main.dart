import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'models/journal_entry.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/new_entry_screen.dart';
import 'screens/history_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MentalZenApp());
}

class MentalZenApp extends StatelessWidget {
  const MentalZenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Zen',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigation();
        }

        return const LoginScreen();
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;
  bool isLoadingEntries = false;

  final List<JournalEntry> entries = [];
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoadingEntries = true;
    });

    try {
      final loadedEntries = await firestoreService.getEntries(user.uid);

      setState(() {
        entries.clear();
        entries.addAll(loadedEntries);
      });
    } catch (e) {
      debugPrint('Error loading entries: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingEntries = false;
        });
      }
    }
  }

  void addEntry(JournalEntry entry) {
    setState(() {
      entries.insert(0, entry);
      selectedIndex = 2;
    });
  }

  
  void deleteEntry(int index) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final entry = entries[index];

    try {
      await firestoreService.deleteEntry(user.uid, entry.entryId);

      setState(() {
        entries.removeAt(index);
      });
    } catch (e) {
      debugPrint('Error deleting entry: $e');
    }
  }

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 2 || index == 3) {
      loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      NewEntryScreen(onEntrySaved: addEntry),

      isLoadingEntries
          ? Scaffold(
              appBar: AppBar(title: const Text('History')),
              body: const Center(child: CircularProgressIndicator()),
            )
          : HistoryScreen(
              entries: entries,
              onDelete: deleteEntry,
            ),

      InsightsScreen(entries: entries),
      const ResourcesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'New'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}