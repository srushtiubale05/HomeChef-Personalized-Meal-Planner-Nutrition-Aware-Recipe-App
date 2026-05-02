# 🍽️ HomeChef – Smart Meal Planning & Recipe App

## 🚀 Overview

**HomeChef** is a modern Flutter-based mobile application designed to simplify meal planning and promote healthier eating habits.

The app enables users to explore recipes, plan daily meals, track calorie intake, and receive personalized health insights. It integrates Firebase for authentication and real-time data storage, making the experience dynamic and scalable.

---

## ✨ Features

### 👤 User Management

* Secure login & registration using Firebase Authentication
* Personalized user profiles
* Stores health data (calories, protein, carbs, etc.)

### 🍲 Recipe System

* Browse recipes from Firestore database
* View detailed recipe instructions
* Ingredients and step-by-step cooking guide
* Recipe images and metadata (calories, time, difficulty)

### 🔊 Voice Cooking Instructions

* Text-to-Speech (TTS) support
* Hands-free cooking experience
* Reads recipe steps aloud

### 📅 Smart Meal Planner

* Plan meals for Breakfast, Lunch, and Dinner
* Stores plans per user in Firestore
* Time-based meal reminders
* Dynamic calorie calculation for selected meals

### 📊 Nutrition Tracking

* Compares selected meals with user's calorie goal
* Displays calorie progress visually
* Helps users maintain a balanced diet

### 💡 Health Tips Slider

* Auto-scrolling tips using PageView + Timer
* Improves user engagement

### 🤖 Chatbot Assistant

* Basic chatbot for food and health queries
* Enhances interactivity

### 🔔 Notifications

* Meal reminders using local notifications
* Optional Firebase Cloud Messaging support

---

## 🛠️ Tech Stack

### Frontend

* Flutter (Dart)

### Backend

* Firebase Firestore (NoSQL Database)
* Firebase Authentication

### Packages Used

* `flutter_tts` → Voice instructions
* `firebase_auth` → Authentication
* `cloud_firestore` → Database
* `firebase_messaging` → Notifications
* `flutter_local_notifications` → Scheduled reminders
* `image_picker` → Profile images
* `http` → API calls

---

## 📱 App Architecture

User Flow:

Login/Register
→ Home Page
→ Browse Recipes
→ Select Meal Plan
→ Track Calories
→ Receive Notifications

---

## 📂 Project Structure

```
lib/
│
├── main.dart
├── home_page.dart
├── login.dart
├── register.dart
├── profile.dart
├── onboarding.dart
├── meal_planner_screen.dart
├── recipe_screen.dart
├── recipe_detail_screen.dart
├── chatbot_screen.dart
├── firebase_service.dart
├── user_model.dart
```

---

## ⚙️ How to Run the Project

### 1. Clone the Repository

```
git clone https://github.com/your-username/homechef.git
cd homechef
```

### 2. Install Dependencies

```
flutter pub get
```

### 3. Setup Firebase

* Add `google-services.json` in `android/app/`
* Enable:

  * Firebase Authentication
  * Cloud Firestore

### 4. Run App

```
flutter run
```

---

## 🔥 Key Highlights

* Real-time database integration using Firebase
* Personalized nutrition-based meal planning
* Clean, modern UI design
* Multimedia support (audio instructions)
* Scalable and modular architecture

---


