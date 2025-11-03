# 📘 StudySync - Flutter Frontend

**StudySync** is a modern, mobile-friendly Flutter application designed to enhance student learning and academic organization. It allows learners to access courses, manage their study programs, and track progress — all within a clean, intuitive UI.  
This repository contains the **frontend Flutter application** for the StudySync project.

---

## Project Overview

StudySync aims to simplify digital learning for students while providing admins an efficient way to publish and manage educational programs.  
The **frontend app** focuses on responsive design, clear navigation, and smooth user experience built entirely with **Flutter**.

---

## Objectives

- Build a **user-friendly mobile interface** for students and admins.  
- Support **program discovery, enrollment, and progress tracking**.  
- Establish a scalable Flutter project structure for future extensions.  
- Implement a clean, modular, and maintainable codebase using **best practices** in Flutter UI development.

---

## Target Users

### Learners
High school and university students who want to manage tasks, collaborate with peers, and track their study progress

---

## Core Features (MVP)

User Authentication (Email/Google Sign-In)
1.  Personal Dashboard displaying tasks, streaks, and daily goals
2.  Task Management – Create, edit, and track study or project tasks
3.  Group Workspaces for collaboration and shared task boards
4.  Reminders and notifications for upcoming deadlines
5.  Progress Analytics showing completion charts and streaks (for future updates)
6.  Clean, responsive UI built with Flutter components


---

## App Navigation Flow

| Screen | Description | Navigation |
|:-------|:-------------|:------------|
| **Login** | Entry screen with sign-in fields | → Home |
| **Home** | Displays overview and quick links | → Program Listing / Profile |
| **Program Listing** | Shows all available courses | → Program Details |
| **Program Details** | Detailed info of a selected course | ← Back to Listing |
| **Profile** | User info and settings | ← Back to Home |

---

## Project Structure


```
lib/
├── main.dart                # Entry point of the app
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── program_list_screen.dart
│   ├── program_detail_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── custom_button.dart
│   ├── program_card.dart
│   └── navigation_bar.dart
├── models/
│   └── program_model.dart
└── utils/
└── constants.dart
```


---

## Tech Stack

- **Framework:** Flutter (Dart)
- **UI:** Material Design Widgets
- **State Management:** Provider (planned for later stages)
- **Version Control:** Git + GitHub

---

## Setup Instructions

1. **Clone this repository**
   bash
   git clone https://github.com/syedhuzyfaali/Flutter-Virtual-Internship.git
   cd studysphere-frontend


2. **Install dependencies**

   bash
   flutter pub get
   

3. **Run the app**

   bash
   flutter run
   

---




# 📘 CHANGELOG

## Version 1.0.0 – Course Module Implementation

### 🧩 Program Listing Page
- **Added dynamic API integration** using the `http` package to fetch paginated course data from a remote endpoint.  
- **Implemented JSON parsing** and data mapping into a custom `Course` model to manage structured content within the app.  
- **Introduced state management** using `setState()` to handle transitions between loading, success, and error states.  
- **Integrated loading indicator** using `SpinKitCubeGrid` from the `flutter_spinkit` package to enhance user feedback during data retrieval.  
- **Added error handling** with `try-catch` blocks and `SnackBar` notifications to manage network issues and API failures gracefully.  
- **Designed responsive UI components** for listing courses, including course title, summary, lecturer, and enrollment deadlines.  
- **Implemented pagination controls** (Next/Previous) to navigate through API pages dynamically.  
- **Enabled navigation** to detailed course pages (`ProgramDetails_Screen`) upon item selection for a smooth user flow.  

---

### 🧠 Program Details Screen
- **Connected detailed course view** to fetch individual course data dynamically using the course’s unique ID parameter.  
- **Enhanced state management** by maintaining loading states and real-time UI updates upon successful data fetch or failure.  
- **Reinforced error handling** with descriptive `SnackBar` alerts to provide user-friendly feedback during network or decoding errors.  
- **Integrated loading spinner (`SpinKitCubeGrid`)** for seamless user experience while awaiting data response.  
- **Implemented versatile image handling** that supports base64, remote URLs, and invalid image fallbacks, ensuring consistent visual presentation.  
- **Refined layout design** to display key course details such as title, instructor, summary, and enrollment deadline in a clear, structured format.  

---

### 📝 Course Registration Form
- **Introduced modal registration form** using `AlertDialog` for a non-intrusive and accessible user experience.  
- **Added form validation logic** leveraging `Form` and `TextFormField` validators to ensure accurate data entry for name, email, and phone fields.  
- **Implemented form submission workflow** with simulated API call delay (`Future.delayed`) to mimic real-world data posting.  
- **Integrated submission state feedback** with a `CircularProgressIndicator` to indicate ongoing form processing.  
- **Added success feedback mechanism** via a `SnackBar` message confirming enrollment submission and user acknowledgment.  
- **Ensured UI responsiveness and data consistency** through `GlobalKey<FormState>` management and proper form lifecycle control.  

---

### ⚙️ Overall Improvements
- Optimized **API-driven architecture** for dynamic content delivery. 
- Enhanced **user experience (UX)** with intuitive feedback loops and visual cues.  
- Improved **app reliability** through structured error management and robust state handling.  
- Ensured **UI consistency** across both listing and detail views with clean layout, modern color scheme, and responsive widgets.  

---

### Challenges Faced

- Integrating Firebase services and handling authentication securely
- Managing asynchronous API requests and state across screens
- Designing consistent UI components adaptable across devices
- Resolving dependency conflicts during build and deployment

### Learning Outcomes

- Strengthened understanding of Flutter architecture and Firebase integration
- Improved team collaboration and version control practices
- Enhanced problem-solving and debugging skills in real-world scenarios
- Learned best practices for UI/UX consistency and data handling

⭐ **If you find this useful, don’t forget to star the repo!**



---

