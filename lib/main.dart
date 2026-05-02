import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homechef/recipe_detail_screen.dart';
import 'package:homechef/recipe_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'home_page.dart';
import 'login.dart';
import 'meal_planner_screen.dart';

/// 🔥 NEW IMPORTS FOR FCM
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// 🔥 BACKGROUND HANDLER (REQUIRED FOR CLOSED APP NOTIFICATIONS)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background notification: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// 🔥 ENABLE BACKGROUND NOTIFICATIONS
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  /// 🔥 REQUEST PERMISSION + SAVE TOKEN
  Future<void> setupFCM() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// request notification permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// get device token
    String? token = await messaging.getToken();

    print("FCM TOKEN: $token");

    /// save token to firestore (if logged in)
    if (FirebaseAuth.instance.currentUser != null) {

      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "fcmToken": token
      }, SetOptions(merge: true));
    }

    /// receive notification when app is open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("Foreground notification: ${message.notification?.title}");

    });
  }

  @override
  Widget build(BuildContext context) {

    /// initialize FCM
    setupFCM();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {

  final String username;

  MainScreen({required this.username});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = [
    HomePage(username: widget.username),
    RecipeScreen(),
    AllRecipesScreen(),
    MealPlannerScreen(),
  ];

  void openChatbot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: ChatbotScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      /// CHATBOT FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: openChatbot,
        backgroundColor: Colors.green,
        child: Icon(Icons.chat),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Recipes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "All Recipes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Meal Planner",
          ),
        ],
      ),
    );
  }
}















// ... rest of your existing code (RecipeScreen, ChatbotScreen) unchanged
































































// ================= RECIPES SCREEN =================
































// ================= RECIPES =================
class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}
































class _RecipeScreenState extends State<RecipeScreen> {
  List recipes = [];
  List selectedIngredients = [];
































  List<Map<String, String>> allIngredients = [
    {"name": "rice", "image": "assets/images/rice.png"},
    {"name": "carrot", "image": "assets/images/carrot.png"},
    {"name": "beans", "image": "assets/images/beans.png"},
    {"name": "paneer", "image": "assets/images/paneer(1).png"},
    {"name": "butter", "image": "assets/images/butter.png"},
    {"name": "tomato", "image": "assets/images/tomato.png"},
    {"name": "egg", "image": "assets/images/egg.png"},
    {"name": "oil", "image": "assets/images/oil.png"},
  ];
































  Future<void> fetchRecipes() async {
    var snapshot = await FirebaseFirestore.instance.collection('recipes').get();
































    var filtered = snapshot.docs.where((doc) {
      var data = doc.data();
      List ingredients = data['ingredients'];
































      List<String> ingredientList =
      ingredients.map((e) => e.toString().toLowerCase()).toList();
































      return selectedIngredients.every((selected) {
        return ingredientList.any((item) => item.contains(selected));
      });
    }).map((doc) => doc.data()).toList();
































    setState(() {
      recipes = filtered;
    });
  }
































  Widget _infoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 14, color: Colors.green),
      label: Text(label, style: TextStyle(fontSize: 12)),
      backgroundColor: Colors.green[50],
    );
  }
































  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomeChef")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "Select Ingredients",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
































            SizedBox(height: 10),
































            // 🔥 INGREDIENT GRID
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allIngredients.map((item) {
                String name = item['name']!;
                String image = item['image']!;
                bool isSelected = selectedIngredients.contains(name);
































                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIngredients.remove(name);
                      } else {
                        selectedIngredients.add(name);
                      }
                    });
                  },
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[200] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Image.asset(image, height: 40),
                        SizedBox(height: 5),
                        Text(name, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
































            SizedBox(height: 10),
































            ElevatedButton(
              onPressed: fetchRecipes,
              child: Text("Generate Recipes"),
            ),
































            SizedBox(height: 10),
































            // 🔥 RECIPE CARDS (UPDATED UI)
            Expanded(
              child: recipes.isEmpty
                  ? Center(child: Text("No recipes found"))
                  : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  var recipe = recipes[index];
































                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(
                            recipe: Map<String, dynamic>.from(recipe),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              recipe['image'],
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
































                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe['name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    _infoChip(Icons.timer,
                                        "${recipe['cookingTime']} min"),
                                    SizedBox(width: 6),
                                    _infoChip(Icons.bar_chart,
                                        recipe['difficulty']),
                                    SizedBox(width: 6),
                                    _infoChip(Icons.local_fire_department,
                                        "${recipe['calories']} kcal"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
















































// ================= CHATBOT SCREEN =================
// ================= CHATBOT =================
class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}


class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController controller = TextEditingController();
  List<Map<String, String>> messages = [];


  static const String apiKey = "AIzaSyD9bwTFRPbUCg318JnFBxBVd4CUv4slkk";


  Future<String> getBotResponse(String userMessage) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey",
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": userMessage}
              ]
            }
          ]
        }),
      );

      print(response.body); // debug

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        // 🔥 Friendly fallback instead of error
        return getFallbackResponse(userMessage);
      }
    } catch (e) {
      // 🔥 Network/API failure fallback
      return getFallbackResponse(userMessage);
    }
  }


  String getFallbackResponse(String userMessage) {
    List<String> fallbackReplies = [
      "Hmm, interesting question! What do you think about it?",
      "That's something worth thinking about 🤔",
      "I’d say it depends, but what’s your take?",
      "Can you tell me more about that?",
      "That’s a good one! Let’s explore it together.",
      "I’m not completely sure, but it sounds interesting!",
    ];

    fallbackReplies.shuffle();
    return fallbackReplies.first;
  }

  void sendMessage() async {
    String userText = controller.text;
    if (userText.isEmpty) return;


    setState(() {
      messages.add({"sender": "user", "text": userText});
      messages.add({"sender": "bot", "text": "Typing..."});
    });


    controller.clear();


    String reply = await getBotResponse(userText);


    setState(() {
      messages.removeLast();
      messages.add({"sender": "bot", "text": reply});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) {
                var msg = messages[i];
                return Align(
                  alignment: msg["sender"] == "user"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg["sender"] == "user"
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg["text"]!),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: controller),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage)
            ],
          )
        ],
      ),
    );
  }
}












































