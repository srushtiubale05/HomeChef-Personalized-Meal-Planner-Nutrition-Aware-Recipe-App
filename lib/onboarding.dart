import 'package:flutter/material.dart';
import 'calculator.dart';
import 'firebase_service.dart';
import 'user_model.dart';
import 'profile.dart';
import 'dart:io';
import 'storage_service.dart';




class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;


  int age = 20;
  double weight = 60;
  double height = 170;
  String gender = "Male";
  String activity = "Sedentary";
  String diet = "Vegetarian";
  File? imageFile;
  String? imageUrl;




  void nextStep() {
    if (step < 2) {
      setState(() => step++);
    } else {
      submit();
    }
  }


  void submit() async {
    double calories = Calculator.calculateCalories(
        age, weight, height, gender, activity);


    var macros = Calculator.calculateMacros(calories);
    double water = Calculator.calculateWater(weight);


    UserModel user = UserModel(
      age: age,
      weight: weight,
      height: height,
      gender: gender,
      activity: activity,
      diet: diet,
      calories: calories,
      protein: macros["protein"]!,
      carbs: macros["carbs"]!,
      fat: macros["fat"]!,
      water: water,
    );


    if (imageFile != null) {
      String uid = FirebaseService().getUid();
      imageUrl = await StorageService().uploadProfileImage(uid, imageFile!);
    }


    await FirebaseService().saveUser(user);


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: user),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Onboarding")),
      body: Stepper(
        currentStep: step,
        onStepContinue: nextStep,
        onStepCancel: () {
          if (step > 0) setState(() => step--);
        },
        steps: [
          Step(
            title: Text("Basic Info"),
            content: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => age = int.parse(val),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Weight"),
                  onChanged: (val) => weight = double.parse(val),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Height"),
                  onChanged: (val) => height = double.parse(val),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Lifestyle"),
            content: Column(
              children: [
                DropdownButtonFormField(
                  value: gender,
                  items: ["Male", "Female"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => gender = val.toString(),
                ),
                DropdownButtonFormField(
                  value: activity,
                  items: ["Sedentary", "Moderate", "Active"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => activity = val.toString(),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Diet Preference"),
            content: DropdownButtonFormField(
              value: diet,
              items: [
                "Vegetarian",
                "Vegan",
                "Keto",
                "Diabetic",
                "Gluten-Free"
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => diet = val.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

