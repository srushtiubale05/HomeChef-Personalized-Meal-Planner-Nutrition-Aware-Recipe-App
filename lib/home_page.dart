import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homechef/profile.dart';
import 'package:homechef/user_model.dart';
import 'recipe_detail_screen.dart';
import 'recipe_screen.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, dynamic>> recipes = [];

  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<String> healthTips = [
    "🥗 Eat vegetables daily for better immunity",
    "💪 Protein helps repair body tissues",
    "🔥 1g of protein contains 4 calories",
    "🍎 Fruits provide essential vitamins",
  ];

  Future<void> fetchRecipes() async {
    var snapshot =
    await FirebaseFirestore.instance.collection('recipes').get();

    setState(() {
      recipes = snapshot.docs
          .map((doc) => {...doc.data(), "id": doc.id})
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRecipes();

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (currentPage < healthTips.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
  }

  Widget recipeCard(Map<String, dynamic> recipe) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                recipe['image'] ?? "",
                width: 110,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 90,
                    color: Colors.orange[100],
                    child: Icon(Icons.restaurant_menu),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe['name'] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${recipe['cuisine'] ?? ''} • ${recipe['difficulty'] ?? ''}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HELLO HEADER
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(
                    "Hello ${widget.username} 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {

                      var data = await FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            user: UserModel(
                              age: data["age"],
                              weight: data["weight"],
                              height: data["height"],
                              gender: data["gender"],
                              activity: data["activity"],
                              diet: data["diet"],
                              calories: data["calories"],
                              protein: data["protein"],
                              carbs: data["carbs"],
                              fat: data["fat"],
                              water: data["water"],
                            ),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.pink[200],
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Recipes 🍳",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AllRecipesScreen(initialSearch: value),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            /// HEALTH SLIDER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.shade200,
                      Colors.orange.shade200,
                    ],
                  ),
                ),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: healthTips.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          healthTips[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 10),

            /// DOTS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                healthTips.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 10 : 8,
                  height: currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index
                        ? Colors.green
                        : Colors.green.shade200,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            /// TITLE
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Recommended Recipes 🍽",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
            ),

            SizedBox(height: 10),

            /// RECIPE LIST
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return recipeCard(recipes[index]);
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}