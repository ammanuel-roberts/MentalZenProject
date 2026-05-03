import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final StorageService storageService = StorageService();

  bool isLoading = false;

  final List<Map<String, String>> resources = [
    {
      'title': 'Breathing Exercise',
      'description': 'A short breathing exercise for stress relief.',
      'path': 'mindfulness/breathing_exercise.txt',
    },
    {
      'title': 'Grounding Exercise',
      'description': 'A quick grounding activity for calming down.',
      'path': 'mindfulness/grounding_exercise.txt',
    },
  ];

  Future<void> openResource(String filePath) async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = await storageService.getDownloadUrl(filePath);
      final uri = Uri.parse(url);

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open resource')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mindfulness Resources',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'These resources are stored in Firebase Storage.',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 16),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            ),

          for (final resource in resources)
            Card(
              child: ListTile(
                leading: const Icon(Icons.self_improvement),
                title: Text(resource['title'] ?? ''),
                subtitle: Text(resource['description'] ?? ''),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  openResource(resource['path'] ?? '');
                },
              ),
            ),
        ],
      ),
    );
  }
}