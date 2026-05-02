import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MealPlannerScreen extends StatefulWidget {
  @override
  _MealPlannerScreenState createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {

  double userCalorieGoal = 0;

  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> loadUserCalorieGoal() async {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        userCalorieGoal = (doc["calories"] ?? 0).toDouble();
      });
    }
  }

  /// ORDERED LIST OF DAYS
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  String selectedDay = "Monday";

  Map<String, Map<String, String>> weeklyPlan = {
    "Monday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Tuesday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Wednesday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Thursday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Friday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Saturday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
    "Sunday": {"Breakfast": "", "Lunch": "", "Dinner": ""},
  };

  TimeOfDay breakfastTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay lunchTime = TimeOfDay(hour: 13, minute: 0);
  TimeOfDay dinnerTime = TimeOfDay(hour: 20, minute: 0);

  int calculateDayCalories(List<Map<String, dynamic>> recipes) {

    int total = 0;

    for (var meal in ["Breakfast", "Lunch", "Dinner"]) {

      String recipeName = weeklyPlan[selectedDay]![meal]!;

      if (recipeName.isNotEmpty) {

        var recipe = recipes.firstWhere(
              (r) => r["name"] == recipeName,
          orElse: () => {},
        );

        if (recipe.isNotEmpty) {
          total += (recipe["calories"] ?? 0) as int;
        }
      }
    }

    return total;
  }

  @override
  void initState() {
    super.initState();
    initNotifications();
    loadMealPlan();
    loadUserCalorieGoal();
  }

  void initNotifications() async {
    tz.initializeTimeZones();

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(String title, TimeOfDay time) async {

    final now = DateTime.now();

    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    await notificationsPlugin.zonedSchedule(
      title.hashCode,
      title,
      "Time for your planned meal 🍽",
      tz.TZDateTime.from(scheduled, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'meal_channel',
          'Meal Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> saveMealPlan() async {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({
      "mealPlanner": weeklyPlan
    }, SetOptions(merge: true));
  }

  Future<void> loadMealPlan() async {

    String uid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists && doc.data()!.containsKey("mealPlanner")) {

      Map data = doc["mealPlanner"];

      setState(() {
        weeklyPlan = data.map((day, meals) =>
            MapEntry(day, Map<String, String>.from(meals)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFE8F5E9),

      appBar: AppBar(
        title: Text("Meal Planner"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Select Day",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedDay,

              items: days
                  .map((day) => DropdownMenuItem(
                value: day,
                child: Text(day),
              ))
                  .toList(),

              onChanged: (value) {
                setState(() {
                  selectedDay = value!;
                });
              },

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 25),

            mealTile(selectedDay, "Breakfast"),
            mealTile(selectedDay, "Lunch"),
            mealTile(selectedDay, "Dinner"),

            SizedBox(height: 30),

            timeTile("Breakfast Time", breakfastTime, (time) {
              setState(() => breakfastTime = time);
              scheduleNotification("Breakfast Reminder", time);
            }),

            timeTile("Lunch Time", lunchTime, (time) {
              setState(() => lunchTime = time);
              scheduleNotification("Lunch Reminder", time);
            }),

            timeTile("Dinner Time", dinnerTime, (time) {
              setState(() => dinnerTime = time);
              scheduleNotification("Dinner Reminder", time);
            }),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: () async {

                  await saveMealPlan();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Meal planner saved successfully 🍽"),
                    ),
                  );
                },

                child: Text(
                  "Set Meal Planner",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {

                await notificationsPlugin.show(
                  0,
                  "Meal Reminder",
                  "Time for your planned meal 🍽",
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      'meal_channel',
                      'Meal Reminders',
                      importance: Importance.max,
                      priority: Priority.high,
                    ),
                  ),
                );
              },

              child: Text("Test Notification"),
            ),
          ],
        ),
      ),
    );
  }

  Widget mealTile(String day, String mealType) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(
        title: Text(mealType),

        subtitle: Text(
          weeklyPlan[day]![mealType]!.isEmpty
              ? "Select Recipe"
              : weeklyPlan[day]![mealType]!,
        ),

        trailing: Icon(Icons.restaurant_menu),

        onTap: () {
          showRecipePicker(day, mealType);
        },
      ),
    );
  }

  Widget timeTile(
      String title,
      TimeOfDay time,
      Function(TimeOfDay) onPicked) {

    return ListTile(
      title: Text(title),

      subtitle: Text(time.format(context)),

      trailing: Icon(Icons.access_time),

      onTap: () async {

        TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);

        if (picked != null) {
          onPicked(picked);
        }
      },
    );
  }

  /// UPDATED RECIPE PICKER WITH CALORIE BAR
  void showRecipePicker(String day, String mealType) async {

    var snapshot =
    await FirebaseFirestore.instance.collection('recipes').get();

    List<Map<String, dynamic>> recipes =
    snapshot.docs.map((doc) => doc.data()).toList();

    int currentCalories = calculateDayCalories(recipes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (_) {

        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.75,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Select Recipe",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height:20),

              Text(
                "Today's Calories: $currentCalories / ${userCalorieGoal.toInt()} kcal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height:10),

              LinearProgressIndicator(
                value: userCalorieGoal == 0
                    ? 0
                    : currentCalories / userCalorieGoal,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),

              SizedBox(height:20),

              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,

                  itemBuilder: (context, index) {

                    var recipe = recipes[index];

                    return Card(
                      child: ListTile(

                        title: Text(recipe["name"]),

                        subtitle:
                        Text("${recipe["calories"] ?? 0} kcal"),

                        trailing: Icon(Icons.restaurant_menu),

                        onTap: () async {

                          setState(() {
                            weeklyPlan[day]![mealType] =
                            recipe["name"];
                          });

                          await saveMealPlan();

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}