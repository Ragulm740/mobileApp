# mobileApp

Project Overview
This application demonstrates:

Task 1: Modern UI/UX with Material Design 3
Task 2: RESTful API integration with JSONPlaceholder
Task 3: Local data caching with Hive
Task 4: Android APK & AAB builds with signing
Task 5: iOS Push Notification setup with Firebase

Architecture
Technology Stack

Framework: Flutter 3.x
Language: Dart
State Management: StatefulWidget (can be upgraded to Provider/Riverpod)
API Client: HTTP package
Local Storage: Hive NoSQL Database
Push Notifications: Firebase Cloud Messaging (FCM)
Connectivity: connectivity_plus package

Features
1. Authentication (Task 1)

Mobile number validation (10 digits, starts with 6-9)
OTP generation and validation
Dynamic form field enabling/disabling
Smooth animations and transitions
Material Design 3 components

2. Dashboard (Task 1)

User profile display
Interactive menu cards with animations
Navigation to different sections
Logout functionality
Gradient backgrounds and modern UI

3. Posts Integration (Task 2)

Fetch posts from JSONPlaceholder API
Display posts in card layout
Pull-to-refresh functionality
Pagination with infinite scroll
Loading indicators
Error handling (network errors, timeouts)
Post detail modal

4. Local Caching (Task 3)

Automatic caching using Hive
Offline data access
Cache timestamp tracking
Connectivity monitoring
Offline indicator banner
Seamless online/offline switching

5. Push Notifications (Task 5)

Firebase Cloud Messaging integration
Notification permission handling
Foreground message handling
Background message handling
Topic subscription support
FCM token generation

Setup Instructions
Firebase Setup
Create Firebase project at https://console.firebase.google.com
Add Android app (download google-services.json → android/app/)
Add iOS app (download GoogleService-Info.plist → ios/Runner/)

Building for Release
Android APK & AAB

Generate Keystore

bashkeytool -genkey -v -keystore android/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload

Create key.properties

propertiesstorePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks

Build APK

bashflutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

Build AAB

bashflutter build appbundle --release

iOS IPA (Mac Only)

Install Pods

bashcd ios && pod install && cd ..

Build IPA

bashflutter build ipa --release
