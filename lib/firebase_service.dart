

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';


class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<User?> register(String email, String password) async {
    final res = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return res.user;
  }


  Future<User?> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return res.user;
  }


  Future<void> saveUser(UserModel user) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;


    await _db.collection("users").doc(uid).set(user.toMap());
  }


  Future<Map<String, dynamic>?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;


    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }


  String getUid() {
    return _auth.currentUser!.uid;
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}



