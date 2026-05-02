import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<String> uploadProfileImage(String uid, File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_uploads')
          .child(uid)
          .child('profile.jpg');


      // 🔥 Upload with snapshot
      UploadTask uploadTask = ref.putFile(file);


      TaskSnapshot snapshot = await uploadTask;


      // ✅ Ensure upload completed
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception("Upload failed");
      }


    } catch (e) {
      print("❌ Storage Error: $e");
      throw e;
    }
  }
}

