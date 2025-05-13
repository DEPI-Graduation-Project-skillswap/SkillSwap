# SkillSwap

SkillSwap is a mobile application built with Flutter and Firebase that connects people with complementary skills, allowing them to exchange knowledge and expertise. Users can find others who have skills they want to learn, and offer their own skills in return.

## Features

### User Authentication
- Sign up/login with email and password
- Email verification
- User profile setup with skills and interests

### Profile Management
- User profiles with personal information
- Skill management (offered skills and wanted skills)
- Profile customization

### Social Connections
- Friend requests system
- Friends list with accepted connections
- Real-time notifications for friend activities

### Communication
- Real-time chat with connections
- Chat notifications
- Message history and read status tracking

### Skill Discovery
- Search for users by name or skills
- Browse users with relevant skills
- Filter search results

### Notifications System
- Friend request notifications
- Message notifications
- Notification indicators on tab bar

## Technical Stack

### Frontend
- **Flutter**: Cross-platform UI framework
- **BLoC/Cubit**: State management
- **Provider**: Additional state management

### Backend & Data
- **Firebase Authentication**: User authentication
- **Cloud Firestore**: NoSQL database for data storage
- **Firebase Storage**: Media storage

### Architecture
- Follows a variation of Clean Architecture
- Organized by feature modules
- Separation of data, domain, and presentation layers

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Firebase project set up

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/SkillSwap.git
cd SkillSwap
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
   - Create a Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and place google-services.json (Android) or GoogleService-Info.plist (iOS) in the appropriate directory
   - Enable Authentication, Firestore and Storage in Firebase Console

4. Run the app
```bash
flutter run
```

## Project Structure

The project follows a modular structure organized by features:

```
lib/
├── auth/                 # Authentication related code
├── chat/                 # Chat functionality
├── friends/              # Friends management
├── home/                 # Home screen and related components
├── landing/              # App landing pages
├── notifications/        # Notifications system
├── requests/             # Friend requests handling
├── search/               # Search functionality
├── settings/             # App settings
├── shared/               # Shared utilities, widgets, and themes
├── user_profile/         # User profile management
├── home_screen.dart      # Main app scaffold with bottom navigation
└── main.dart             # App entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

