# 📚 Flash Cards

A Flutter-based **Flash Cards & Quiz application** designed to help users organize study material, create flashcards, and test their knowledge through interactive quizzes.

The project focuses on clean UI, local data persistence, state management, reusable components, and a smooth study experience.

---

## ✨ Features

### 🔐 Authentication
- User registration and login.
- Persistent login state.
- Local user data handling.

### 🏠 Home
The home screen provides access to the main parts of the application and gives the user a simple starting point for studying.

### 📂 Folder Management
Users can organize flashcards into folders.

- Create folders.
- Edit folders.
- Delete folders.
- Open a folder to view its flashcards.
- Add a flashcard directly to a selected folder.

### 🃏 Flashcard Management
Each flashcard contains:

- **Question**
- **Answer**
- **Hint** (optional)
- **Folder ID**

Flashcards are connected to folders through their `folderId`, allowing the app to retrieve the cards belonging to a specific folder.

### 🧠 Quiz System
Users can create a quiz from their flashcards.

The quiz flow is:

```text
Quiz Setup
    ↓
Questions
    ↓
Answers
    ↓
Quiz Score
```

The app keeps track of the user's performance and displays the final result.

### 🕘 Quiz History
Previous quizzes can be viewed through the quiz history screen.

### 👤 Profile
A dedicated profile screen for user-related information and account management.

---

# 📱 Screenshots

## 🏠 Home

<p align="center">
  <img src="screenshots/home.png" width="220" alt="Home Screen">
</p>

---

## 📂 Folders

<p align="center">
  <img src="screenshots/folders.png" width="220" alt="Folders Screen">
</p>

Users can create and organize their study material into separate folders.

---

## 🃏 Add Flashcard

<p align="center">
  <img src="screenshots/add_flash_card.png" width="220" alt="Add Flashcard Screen">
</p>

The flashcard creation screen allows the user to select a folder and enter a question, answer, and optional hint.

---

## 👀 Flashcard Front & Back

<table>
  <tr>
    <td align="center">
      <b>Front</b><br><br>
      <img src="screenshots/front_of_flash_card.png" width="220" alt="Flashcard Front">
    </td>
    <td align="center">
      <b>Back</b><br><br>
      <img src="screenshots/back_of_flash_card.png" width="220" alt="Flashcard Back">
    </td>
  </tr>
</table>

The flashcard interface separates the question from the answer to support active recall.

---

## 🧠 Quiz Setup

<p align="center">
  <img src="screenshots/quiz_setup.png" width="220" alt="Quiz Setup Screen">
</p>

The user can configure the quiz before starting.

---

## ❓ Quiz Question

<p align="center">
  <img src="screenshots/question.png" width="220" alt="Quiz Question Screen">
</p>

Questions are presented interactively so the user can test their knowledge.

---

## 🏆 Quiz Score

<p align="center">
  <img src="screenshots/quiz_score.png" width="220" alt="Quiz Score Screen">
</p>

After completing the quiz, the application displays the user's final score.

---

## 👤 Profile

<p align="center">
  <img src="screenshots/profile.png" width="220" alt="Profile Screen">
</p>

---

## 🕘 Quiz History

<p align="center">
  <img src="screenshots/quizzes_history.png" width="220" alt="Quiz History Screen">
</p>

---

# 🛠️ Technologies Used

| Technology | Usage |
|---|---|
| **Flutter** | Mobile application development |
| **Dart** | Application programming language |
| **BLoC** | Event-based state management |
| **Cubit** | Lightweight state management |
| **Hive** | Local database and structured data persistence |
| **SharedPreferences** | Lightweight persistent key-value storage |
| **Flutter Animations** | UI transitions and interaction feedback |

---

# 🧩 State Management

The project uses both **BLoC** and **Cubit**, depending on the complexity of each feature.

### BLoC

BLoC is used for features that benefit from an explicit event → state architecture.

```text
User Action
    ↓
Event
    ↓
BLoC
    ↓
State
    ↓
UI
```

For example, adding or deleting flashcards/folders can be handled through events dispatched to the corresponding BLoC.

### Cubit

Cubit is used where the state logic is simpler and does not require a separate event class.

This keeps simpler features easier to read and maintain.

---

# 💾 Local Data Storage

The application uses two local persistence solutions for different purposes.

## Hive

Hive is used for structured application data such as:

```text
Folders
Flashcards
Quiz-related data
```

A flashcard is associated with a folder using its `folderId`.

Example:

```text
Folder
  │
  ├── Flashcard
  ├── Flashcard
  └── Flashcard
```

## SharedPreferences

SharedPreferences is used for lightweight persistent values such as login/session-related information and simple user preferences.

### Why both?

```text
Hive
 └── Structured application data

SharedPreferences
 └── Simple key-value data
```

Each storage solution is used according to the type of data it is best suited for.

---

# 🎬 Animations & UI

Animations are used to make the application feel more responsive and polished.

The UI uses:

- Rounded components.
- Consistent spacing.
- Reusable input styles.
- Interactive buttons.
- Visual feedback.
- Screen/dialog transitions.
- Simple and focused layouts.

The goal is to keep the interface easy to understand while making the study flow feel interactive.

---

# 🏗️ Architecture

The project follows a feature-oriented structure with separation between the UI, business/state logic, models, and core components.

A simplified architecture:

```text
             ┌──────────────┐
             │      UI      │
             └──────┬───────┘
                    │
                    ↓
          ┌───────────────────┐
          │   BLoC / Cubit    │
          └─────────┬─────────┘
                    │
                    ↓
          ┌───────────────────┐
          │  Local Persistence │
          └───────┬─────┬─────┘
                  │     │
                Hive  SharedPreferences
```

This separation helps make the project easier to maintain, debug, and extend.

---

# 📁 Project Structure

A simplified view of the project:

```text
lib/
│
├── bloc/
│   ├── flash_cards_bloc.dart
│   ├── flash_cards_event.dart
│   ├── flash_cards_state.dart
│   ├── flash_card_folder_bloc.dart
│   └── ...
│
├── core/
│   └── colors.dart
│
├── models/
│   ├── flash_card_model.dart
│   ├── folder_model.dart
│   └── ...
│
├── features/
│   ├── cards/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── quiz/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── profile/
│   │   └── ...
│   │
│   └── ...
│
└── main.dart
```

---

# 🔄 Main User Flow

```text
Login / Register
       ↓
      Home
       ↓
    Folders
       ↓
 Select Folder
       ↓
 Add Flashcards
       ↓
  Start Quiz
       ↓
 Answer Questions
       ↓
   View Score
       ↓
 Quiz History
```

---

# 🚀 Getting Started

## Prerequisites

Make sure you have:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or a physical Android device

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
```

Navigate to the project:

```bash
cd flash_cards
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 🧪 Main Flows to Test

After running the application, the main flows are:

```text
Authentication
      ↓
Folder Creation
      ↓
Flashcard Creation
      ↓
Flashcard Retrieval
      ↓
Quiz Setup
      ↓
Quiz Questions
      ↓
Quiz Score
      ↓
Quiz History
```

---

# 🎯 Project Goals

This project was built to practice and demonstrate:

- Flutter development.
- Dart programming.
- BLoC architecture.
- Cubit state management.
- Local database management using Hive.
- Persistent storage using SharedPreferences.
- CRUD operations.
- Data modeling.
- Feature-based project organization.
- Form validation.
- Navigation.
- Dialogs.
- Reusable widgets.
- Animations.
- Building a complete application flow.

---

# 🔮 Future Improvements

Possible future improvements include:

- ☁️ Cloud synchronization.
- 🔄 Backup and restore.
- 📊 More detailed learning statistics.
- 🔔 Study reminders.
- ⭐ Favorite flashcards.
- 🔍 Flashcard search.
- 🏷️ Tags and categories.
- 🌙 Dark mode.
- 📅 Spaced repetition.
- 📈 Advanced progress tracking.

---

# 👩‍💻 Author

**Haneen Waleed**

Computer Science Student  
Flutter Developer

---

## ⭐ Support

If you find this project useful, consider giving the repository a ⭐.
