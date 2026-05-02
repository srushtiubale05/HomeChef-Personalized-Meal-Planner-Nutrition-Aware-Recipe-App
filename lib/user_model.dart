class UserModel {
  int age;
  double weight;
  double height;
  String gender;
  String activity;
  String diet;


  double calories;
  double protein;
  double carbs;
  double fat;
  double water;
  String? profileImageUrl;


  UserModel({
    required this.age,
    required this.weight,
    required this.height,
    required this.gender,
    required this.activity,
    required this.diet,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.water,
    this.profileImageUrl,
  });


  Map<String, dynamic> toMap() {
    return {
      "age": age,
      "weight": weight,
      "height": height,
      "gender": gender,
      "activity": activity,
      "diet": diet,
      "calories": calories,
      "protein": protein,
      "carbs": carbs,
      "fat": fat,
      "water": water,
      "profileImageUrl": profileImageUrl,
    };
  }
}

