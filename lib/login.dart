import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'main.dart';
import 'profile.dart';
import 'register.dart';
import 'user_model.dart';
import 'onboarding.dart';

/// 🔥 NEW IMPORTS
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = "", password = "";

  /// 🔥 SAVE DEVICE TOKEN TO FIRESTORE
  Future<void> saveFCMToken() async {

    try {

      String uid = FirebaseAuth.instance.currentUser!.uid;

      String? token = await FirebaseMessaging.instance.getToken();

      print("FCM TOKEN: $token");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "fcmToken": token
      }, SetOptions(merge: true));

    } catch (e) {
      print("FCM Token Error: $e");
    }
  }

  void login() async {
    try {

      var user = await FirebaseService().login(email, password);

      if (user != null) {

        /// 🔥 SAVE TOKEN AFTER LOGIN
        await saveFCMToken();

        var data = await FirebaseService().getUserData();

        if (data != null) {

          String username = data["name"] ?? "User";

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(username: username),
            ),
          );

        } else {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen()),
          );

        }
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed. Check email/password")),
      );

    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  TextField(
                    decoration: InputDecoration(labelText: "Email"),
                    onChanged: (val) => email = val,
                  ),

                  TextField(
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                    onChanged: (val) => password = val,
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Login"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: Text("New user? Register"),
                  ),

                  SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}