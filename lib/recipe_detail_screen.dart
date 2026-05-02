import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RecipeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  const RecipeDetailScreen({required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {

  int servings = 2;
  bool isFavorite= false;

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recipeId = widget.recipe['id'];
    if (recipeId == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(recipeId);

    if (isFavorite) {
      await favRef.delete();
    } else {
      await favRef.set({
        'name': widget.recipe['name'],
        'image': widget.recipe['image'],
        'cuisine': widget.recipe['cuisine'],
        'difficulty': widget.recipe['difficulty'],
        'addedAt': Timestamp.now(),
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  /// 🔊 TEXT TO SPEECH OBJECT
  FlutterTts tts = FlutterTts();

  /// 🔊 SPEAK RECIPE STEPS
  Future<void> speakRecipe(List steps) async {

    String text = "";

    for (int i = 0; i < steps.length; i++) {
      text += "Step ${i + 1}. ${steps[i]}. ";
    }

    await tts.setLanguage("en-US");   // add this
    await tts.setSpeechRate(0.45);
    await tts.setPitch(1.0);

    await tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    var r = widget.recipe;
    List ingredients = r['ingredients'] ?? [];
    List steps = r['steps'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(r['name'] ?? "Recipe"),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: toggleFavorite,
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            r['image'] != null
                ? Image.network(
              r['image'],
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            )
                : Container(
              height: 220,
              color: Colors.orange[100],
              child: Center(
                child: Icon(Icons.restaurant_menu,
                    size: 80, color: Colors.orange),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// INFO CHIPS
                  Row(
                    children: [
                      _infoChip(Icons.timer, "${r['cookingTime'] ?? '?'} min"),
                      SizedBox(width: 8),
                      _infoChip(Icons.bar_chart, r['difficulty'] ?? ""),
                      SizedBox(width: 8),
                      _infoChip(Icons.local_fire_department,
                          "${r['calories'] ?? '?'} kcal"),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// SERVINGS
                  Row(
                    children: [
                      Text("Servings:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (servings > 1) setState(() => servings--);
                        },
                      ),
                      Text("$servings",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => servings++),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  /// 🔊 AUDIO BUTTON
                  ElevatedButton.icon(
                    onPressed: () => speakRecipe(steps),
                    icon: Icon(Icons.volume_up),
                    label: Text("Listen Instructions"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () async {
                      await tts.stop();
                    },
                    icon: Icon(Icons.stop),
                    label: Text("Stop Audio"),
                  ),
                  SizedBox(height: 20),
                  /// INGREDIENTS
                  Text(
                    "Ingredients",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),

                  SizedBox(height: 8),

                  ...ingredients.map((ing) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        SizedBox(width: 8),
                        Text(ing.toString()),
                      ],
                    ),
                  )),

                  SizedBox(height: 16),

                  /// STEPS
                  Text(
                    "Steps",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800]),
                  ),

                  SizedBox(height: 8),

                  ...steps.asMap().entries.map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.green[700],
                          child: Text("${e.key + 1}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                        SizedBox(width: 10),
                        Expanded(child: Text(e.value.toString())),
                      ],
                    ),
                  )),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.green[700]),
      label: Text(label),
      backgroundColor: Colors.green[50],
    );
  }
}