import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  static const Color primary = Color(0xFFFF9A86);
  static const Color secondary = Color(0xFFFFB399);
  static const Color accent = Color(0xFFFFD6A6);
  static const Color background = Color(0xFFFFF0BE);

  Future<void> _removeFavorite(BuildContext context, String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(recipeId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Removed from favorites")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: Text("My Favorites",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: primary,
          elevation: 0,
        ),
        body: Center(child: Text("Please login to view favorites.")),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("My Favorites ❤️",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .orderBy('addedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: primary));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline, size: 80, color: secondary),
                  SizedBox(height: 16),
                  Text(
                    "No favorites yet!",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap ❤️ on any recipe to save it here.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final data =
              favorites[index].data() as Map<String, dynamic>;
              final recipeId = favorites[index].id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('recipes')
                              .doc(recipeId)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Scaffold(
                                body: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final recipeData = snapshot.data!.data() as Map<String, dynamic>;

                            return RecipeDetailScreen(
                              recipe: {...recipeData, 'id': recipeId},
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: data['image'] != null &&
                              data['image'].toString().isNotEmpty
                              ? Image.network(
                            data['image'],
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 72,
                              height: 72,
                              color: accent,
                              child: Icon(Icons.restaurant_menu,
                                  color: primary),
                            ),
                          )
                              : Container(
                            width: 72,
                            height: 72,
                            color: accent,
                            child: Icon(Icons.restaurant_menu,
                                color: primary),
                          ),
                        ),
                        SizedBox(width: 14),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${data['cuisine'] ?? ''} · ${data['difficulty'] ?? ''}",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        // Remove button
                        IconButton(
                          icon:
                          Icon(Icons.favorite, color: primary, size: 26),
                          onPressed: () =>
                              _removeFavorite(context, recipeId),
                          tooltip: "Remove from favorites",
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


