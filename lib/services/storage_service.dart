import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getDownloadUrl(String filePath) async {
    final ref = storage.ref().child(filePath);
    return await ref.getDownloadURL();
  }
}