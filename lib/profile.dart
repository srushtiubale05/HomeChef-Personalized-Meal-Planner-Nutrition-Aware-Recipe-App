

import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'user_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // add this at top
import 'package:image_cropper/image_cropper.dart';
import 'favourite_screen.dart';


class ProfileScreen extends StatefulWidget {
  final UserModel user;


  const ProfileScreen({super.key, required this.user});


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  File? imageFile;


  @override
  void initState() {
    super.initState();
    loadUser();
  }


  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );


      if (picked == null) return;


      // 🔥 CROP IMAGE
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
        ],
      );


      if (cropped == null) return;


      File file = File(cropped.path);


      setState(() {
        imageFile = file;
      });


      String uid = FirebaseService().getUid();


      // 🔥 Convert to Base64
      final bytes = await file.readAsBytes();
      String base64Image = base64Encode(bytes);


      // 🔥 Save in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"profileImageBase64": base64Image});


      print("✅ Cropped image stored in Firestore");
    } catch (e) {
      print("❌ ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed")),
      );
    }
  }


  // 👇 ADD THIS HERE
  void loadUser() async {
    var data = await FirebaseService().getUserData();


    if (data != null) {
      setState(() {
        widget.user.profileImageUrl = data["profileImageBase64"];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var user = widget.user;


    var imageFile;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Summary")),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          // ✅ smoother scroll + fixes edge issues
          //   keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔥 PROFILE IMAGE + BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],


                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : (user.profileImageUrl != null &&
                        user.profileImageUrl!.isNotEmpty)
                        ? MemoryImage(base64Decode(user.profileImageUrl!))
                        : null,


                    child: (imageFile == null &&
                        (user.profileImageUrl == null ||
                            user.profileImageUrl!.isEmpty))
                        ? Icon(Icons.person, size: 50)
                        : null,
                  ),


                  SizedBox(width: 20),


                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.upload),
                    label: Text("Upload"),
                  ),
                ],
              ),


              SizedBox(height: 20),


              // 👤 USER DETAILS
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text("User Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 10),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Age: ${user.age}"),
                          Text("Gender: ${user.gender}"),
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Height: ${user.height} cm"),
                          Text("Weight: ${user.weight} kg"),
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Activity: ${user.activity}"),
                          Text("Diet: ${user.diet}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 30),


              Text(
                "Nutrition Breakdown",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),


              SizedBox(height: 20),


              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: user.protein,
                        title: "Protein\n${user.protein.toStringAsFixed(0)}g",
                        color: Colors.blue,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: user.carbs,
                        title: "Carbs\n${user.carbs.toStringAsFixed(0)}g",
                        color: Colors.orange,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: user.fat,
                        title: "Fat\n${user.fat.toStringAsFixed(0)}g",
                        color: Colors.red,
                        radius: 60,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),


              SizedBox(height: 20),


              // 📊 SUMMARY CARD
              Card(
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Calories: ${user.calories.toStringAsFixed(0)}"),
                      Text("Protein: ${user.protein.toStringAsFixed(0)} g"),
                      Text("Carbs: ${user.carbs.toStringAsFixed(0)} g"),
                      Text("Fat: ${user.fat.toStringAsFixed(0)} g"),
                      Text("Water: ${user.water.toStringAsFixed(2)} L"),
                      Text("Diet: ${user.diet}"),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoritesScreen()),
                  );
                },
                icon: Icon(Icons.favorite),
                label: Text("Favourites"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.all(14),
                ),
              ),


              // 🚪 LOGOUT BUTTON
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseService().logout();


                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                        (route) => false,
                  );
                },
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(14),
                ),
              ),


              SizedBox(height: 80),
              // ✅ increase space // ✅ EXTRA SPACE so button is visible
            ],


          ),
        ),
      ),
    );
  }
}













