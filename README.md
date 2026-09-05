📚 Flash Cards

A modern Flutter flashcard application designed to make studying, reviewing, and testing knowledge simple and interactive.

The app allows users to organize flashcards into folders, study cards using a front/back experience, create quizzes, track quiz history, and manage their profile.

📱 UI Preview

<p align="center">
  <img src="screenshots/home.png" width="140">
  <img src="screenshots/folders.png" width="140">
  <img src="screenshots/add_flash_card.png" width="140">
  <img src="screenshots/front_of_flash_card.png" width="140">
  <img src="screenshots/back_of_flash_card.png" width="140">
</p>

<p align="center">
  <img src="screenshots/quiz_setup.png" width="140">
  <img src="screenshots/question.png" width="140">
  <img src="screenshots/quiz_score.png" width="140">
  <img src="screenshots/profile.png" width="140">
  <img src="screenshots/quizzes_history.png" width="140">
</p>

✨ Features

🗂️ Flashcard Organization

Create and manage study folders.

Add flashcards directly to a selected folder.

Edit and delete folders.

Keep flashcards organized by subject or topic.

📝 Flashcards

Each flashcard contains:

Question

Answer

Hint

The study experience separates the question and answer into a front/back card flow to make revision more interactive.

🧠 Quiz System

Choose a folder/topic for the quiz.

Configure the quiz before starting.

Answer questions interactively.

View the final score.

Keep a history of previous quizzes.

👤 Profile

Dedicated profile screen.

User-related information and settings in one place.

💾 Local Data Persistence

The application uses local storage to keep important data available between sessions:

Hive for structured local application data such as folders and flashcards.

SharedPreferences for lightweight persistent preferences/user-related values.

🔄 State Management

The project uses Flutter BLoC architecture with:

BLoC for event-driven and more complex application flows.

Cubit for simpler state-management logic.

This keeps UI code separated from business logic and makes the application easier to maintain.

🎬 Animations

Animations are used throughout the app to provide a smoother and more engaging user experience, especially around the flashcard/quiz flow.

🛠️ Tech Stack

Technology

Usage

Flutter / Dart

Application development

BLoC

Event-driven state management

Cubit

Lightweight state management

Hive

Local database / persistent structured data

SharedPreferences

Lightweight local persistence

Material UI

User interface

Animations

Interactive UI experience

🏗️ Architecture

The project follows a feature-based Flutter structure with separation between UI, state management, models, and core utilities.

lib/
├── bloc/
│   ├── flash_cards_bloc.dart
│   ├── flash_cards_event.dart
│   ├── flash_cards_state.dart
│   └── ...
│
├── core/
│   ├── colors.dart
│   └── ...
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
│   ├── folders/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── quiz/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   └── profile/
│
└── main.dart

The exact folders/files may vary as the project continues to evolve.

🎨 App Screens

🏠 Home

The home screen acts as the main entry point of the application and provides access to the user's study content.



📁 Folders

Folders help users organize flashcards by subject, course, or topic.



➕ Add New Flashcard

Users can create a new flashcard by entering a question, answer, hint, and selecting the folder where the card should be stored.



🃏 Flashcard Front

The front of the flashcard displays the question and provides the main study interaction.



💡 Flashcard Back

The back of the card reveals the answer and provides the information needed for review.



⚙️ Quiz Setup

Before starting a quiz, users can configure the quiz according to the available study material.



❓ Quiz Question

Users answer flashcard-based questions during the quiz.



🏆 Quiz Score

After completing a quiz, the application displays the user's result.



📊 Quiz History

Users can review their previous quiz activity and results.



👤 Profile

The profile screen provides access to user-related information and options.



🔄 Application Flow

                 ┌─────────────┐
                 │    Home     │
                 └──────┬──────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
      Folders         Quiz         Profile
          │             │
          ▼             ▼
   Add Flashcard    Quiz Setup
          │             │
          ▼             ▼
    Flashcard       Questions
    Front/Back          │
                        ▼
                    Quiz Score
                        │
                        ▼
                  Quiz History

💾 Data Storage

Hive

Hive is used for storing structured application data locally.

For example, flashcards can be stored with information such as:

Question
Answer
Hint
FolderId

Folders can contain information such as:

Title
Id

Using a FolderId allows flashcards to be associated with their corresponding folder.

SharedPreferences

SharedPreferences is used for small persistent values that do not require a full database structure.

🧩 State Management

The application uses both BLoC and Cubit, depending on the complexity of each feature.

BLoC

BLoC follows an event → state approach:

User Action
    ↓
Event
    ↓
BLoC
    ↓
Business Logic
    ↓
New State
    ↓
UI Update

For example, adding a flashcard can follow:

Add Flashcard Button
        ↓
AddFlashCardEvent
        ↓
FlashCardsBloc
        ↓
Save Card
        ↓
Emit Updated State
        ↓
UI Rebuilds

Cubit

Cubit is used where the state logic is simpler and does not require a separate event class.

🎯 Why This Project?

This project was built to practice and demonstrate practical Flutter development concepts, including:

Flutter UI development

Feature-based project organization

BLoC and Cubit state management

Local database management with Hive

Persistent preferences with SharedPreferences

Navigation between multiple screens

Form validation

Reusable widgets

Animations

Quiz logic

CRUD operations

Managing relationships between folders and flashcards

🚀 Getting Started

1. Clone the repository

git clone <https://github.com/Haneen-Waleed/codealpha_tasks.git>

2. Open the project

cd flash_cards

3. Install dependencies

flutter pub get

4. Run the application

flutter run

📱 Requirements

Before running the project, make sure you have:

Flutter SDK

Dart SDK

Android Studio or VS Code

An Android emulator or physical Android device

🔐 Configuration

If the project contains Firebase/Google service configuration, make sure the required configuration files are present before running the application.

For Android, this may include:

android/app/google-services.json

Do not commit private credentials, API keys, or other sensitive configuration files to a public repository.

📌 Future Improvements

Possible future improvements include:

☁️ Cloud synchronization

🔐 More complete authentication

📈 Detailed learning statistics

🔔 Study reminders

⭐ Favorite flashcards

🔍 Search and filtering

🎯 Spaced repetition

🌙 Dark mode

📤 Import/export flashcards

🏅 More quiz modes and achievements

👩‍💻 Author

Hanin Waleed

Computer Science Student & Flutter Developer

⭐ Project Status

This project is actively being developed and improved as part of my Flutter development journey.

If you find the project useful or interesting, consider giving it a ⭐ on GitHub.
