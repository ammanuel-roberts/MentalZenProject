Mental Zen

Mental Zen is a Flutter app I built for journaling and basic mental wellness tracking. The idea is to give users a simple place to write entries, choose a mood, and look back at how they’ve been feeling over time.

Features
Login and registration using Firebase Authentication
Create, view, and delete journal entries (stored in Firestore)
Mood selection for each entry
Insights screen that shows simple mood patterns
Resources screen with mindfulness content from Firebase Storage
Basic notification setup using Firebase Cloud Messaging
How It Works

After logging in, the user can go to the New Entry screen and write a journal entry, select a mood, and save it.

Each entry is stored in Firestore under that specific user, so everyone only sees their own data.

The History screen shows all past entries, and the Insights screen looks at the moods across entries to show simple trends.

The Resources screen loads external files from Firebase Storage and opens them in the browser.

Tech Used
Flutter (Dart)
Firebase Authentication
Firestore
Firebase Storage
Firebase Cloud Messaging
Running the App
Clone the repo
Run flutter pub get
Run flutter run
Notes

This project was mainly focused on getting the core features working and connecting everything to Firebase. The UI is pretty simple, but the main goal was to build a working system that handles user data correctly.
