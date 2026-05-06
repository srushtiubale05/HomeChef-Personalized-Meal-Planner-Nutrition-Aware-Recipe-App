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
<img width="343" height="745" alt="Screenshot 2026-05-05 150417" src="https://github.com/user-attachments/assets/fe72445c-72ea-46f7-898b-ab540d267f35" />
<img width="356" height="747" alt="Screenshot 2026-05-05 150456" src="https://github.com/user-attachments/assets/2720b745-93f9-498f-947e-d80fbb264bb4" />
<img width="351" height="749" alt="Screenshot 2026-05-05 150640" src="https://github.com/user-attachments/assets/62b5a2ec-d4d5-4002-874f-01451d277f1e" />
<img width="349" height="750" alt="Screenshot 2026-05-05 150707" src="https://github.com/user-attachments/assets/ecfc7e56-ac99-4fc1-b2e9-e1877086d090" />
<img width="347" height="748" alt="Screenshot 2026-05-05 150734" src="https://github.com/user-attachments/assets/be7b2a99-79e4-431a-a596-e0ebcb6c7009" />
<img width="354" height="754" alt="Screenshot 2026-05-05 150802" src="https://github.com/user-attachments/assets/43fe006b-b51c-48a5-94de-bb071442f822" />
<img width="343" height="740" alt="Screenshot 2026-05-05 150832" src="https://github.com/user-attachments/assets/d709fc02-1cee-466a-a125-8f80ac247c04" />
<img width="352" height="740" alt="Screenshot 2026-05-05 151022" src="https://github.com/user-attachments/assets/4f6ef428-9f64-4565-b00a-06f22ce6ae7b" />
<img width="346" height="742" alt="Screenshot 2026-05-05 151050" src="https://github.com/user-attachments/assets/8242be02-e871-4254-96c3-6f9137415180" />
<img width="345" height="745" alt="Screenshot 2026-05-05 151105" src="https://github.com/user-attachments/assets/06184506-dfc0-46da-8052-fd9623759f2d" />
<img width="349" height="739" alt="Screenshot 2026-05-05 151153" src="https://github.com/user-attachments/assets/056737cc-419f-4600-b6de-cde7fde848e3" />
<img width="354" height="738" alt="Screenshot 2026-05-05 151214" src="https://github.com/user-attachments/assets/fe36d962-6ff4-48df-aae7-8a22d28ca1b6" />
<img width="349" height="746" alt="Screenshot 2026-05-05 151252" src="https://github.com/user-attachments/assets/8369ad20-4c34-41c5-a79f-a793b664e142" />
<img width="344" height="738" alt="Screenshot 2026-05-05 151322" src="https://github.com/user-attachments/assets/9b8f6eb8-f4a9-43f9-a83b-03b64579b2b4" />
<img width="353" height="745" alt="Screenshot 2026-05-05 151349" src="https://github.com/user-attachments/assets/c83b1ef2-2c0f-499a-8994-1ce4b1b14fcb" />
<img width="353" height="736" alt="Screenshot 2026-05-05 151509" src="https://github.com/user-attachments/assets/e8923c4f-c463-42c2-82bb-c949165e9320" />
<img width="343" height="752" alt="Screenshot 2026-05-05 151545" src="https://github.com/user-attachments/assets/4ddfda6f-ec87-43d1-8be2-4b0b0fda3784" />
<img width="347" height="740" alt="Screenshot 2026-05-05 151813" src="https://github.com/user-attachments/assets/5f6dbbb4-c941-495f-96ee-4d0b3ff8da54" />
<img width="351" height="747" alt="Screenshot 2026-05-05 151822" src="https://github.com/user-attachments/assets/5e52f8cc-adc0-4c10-89cf-d4b7d2a0eb81" />
<img width="361" height="757" alt="Screenshot 2026-05-05 150347" src="https://github.com/user-attachments/assets/a9bd240b-ee4f-45b4-b77b-3cefb59c0ecd" />



