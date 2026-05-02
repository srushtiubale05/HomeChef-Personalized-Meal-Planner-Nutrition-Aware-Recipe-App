import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'onboarding.dart';
import 'login.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {
  String email = "", password = "";


  void register() async {
    try {
      var user = await FirebaseService().register(email, password);


      if (user != null) {
        // ✅ Go to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
        );
      }
    } catch (e) {
      print("Register Error: $e");


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );


    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // ✅ Go back to Login
            },
          ),
        ),
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
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),


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
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Register"),
                    ),


                  ],
                ),
              ),
            ),
          ),
        )




    );
  }
}

