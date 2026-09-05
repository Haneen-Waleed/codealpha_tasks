# 📚 Flash Cards

A modern and interactive **Flash Cards mobile application** built with Flutter.

The app is designed to help users organize their study materials into folders, create flashcards, review them, and test their knowledge through interactive quizzes.

The project focuses on clean UI, local data persistence, state management, reusable widgets, and smooth user interactions.

---

## ✨ Features

### 🔐 User Authentication
- User registration and login.
- Stores user-related data locally.
- Keeps the user logged in between app sessions.
- Logout functionality.

### 📂 Folder Management
Users can organize their flashcards into different folders.

- Create new folders.
- Edit existing folders.
- Delete folders.
- Open a folder to view its flashcards.
- Add flashcards directly to a specific folder.

### 🃏 Flashcard Management
Each flashcard contains:

- ❓ Question
- ✅ Answer
- 💡 Optional Hint
- 📁 Folder association

Users can create and organize their own flashcards and keep them stored locally.

### 🧠 Quiz System
The application includes an interactive quiz system based on the user's flashcards.

- Select a folder for the quiz.
- Configure the quiz.
- Answer questions interactively.
- Track the user's answers.
- Display the final score.
- Review quiz results.
- Keep track of quiz history.

### 📊 Quiz Results
After completing a quiz, the user can see:

- Total questions.
- Correct answers.
- Incorrect answers.
- Final score.
- Performance summary.

### 🕘 Quiz History
The application keeps a history of previous quizzes so the user can review their previous performance.

### 👤 Profile
The app includes a profile section where the user can manage/view their account information.

### 🎨 Modern UI
The application focuses on:

- Clean and simple interface.
- Consistent color system.
- Rounded cards and inputs.
- Clear visual hierarchy.
- Responsive layouts.
- Interactive buttons and dialogs.
- Smooth animations and transitions.

---

# 🛠️ Technologies & Tools

## Flutter

The application is built using **Flutter**, allowing the app to have a single codebase while providing a native-like mobile experience.

---

## Dart

The project is written in **Dart**, Flutter's primary programming language.

---

## BLoC & Cubit

The project uses the **BLoC pattern** for state management.

### BLoC

BLoC is used when the feature requires an event → state flow.

For example:

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