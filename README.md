# SkillSwap: A Comprehensive Micro Skill Exchange and Scheduling App

**Course/Track:** Mobile Development

**Team Members:**
* Mahmoud Abdullah Younes
* Hazem Mohamed Abdel Maged Ali
* Ashraf Gamal Rafeek Ali

## 1. Project Overview

### Objective
To develop a multi-role mobile application that empowers users to exchange skills directly. SkillSwap will allow users to list the skills they offer and the skills they wish to learn, match with suitable partners, and arrange knowledge-sharing sessions. The app also features in-app chat and a dedicated scheduling page where users can book sessions to exchange expertise. Additionally, the app will integrate a robust notification system to remind users about upcoming sessions and pending swap requests, ensuring timely and effective communication.

### Scope of Work
* **User Authentication & Onboarding:**
    * Implement secure user login via Firebase Authentication (with email OTP verification and optional WhatsApp integration for notifications).
    * Guide new users through profile creation where they specify skills offered and skills needed.
* **Skill Exchange Features:**
    * **Skill Feed:** Allow users to browse profiles, filter by skills, and view detailed user profiles.
    * **Matchmaking & Swap Requests:** Enable users to send and receive skill exchange requests.
    * **In-App Chat:** Integrate real-time messaging for users to negotiate session details.
* **Scheduling Session Page:**
    * Provide a dedicated interface where users can schedule a session to exchange knowledge.
    * Let users select a date, time, location (or virtual meeting details), and add a brief description of the intended exchange.
* **Notification Feature:**
    * Integrate push notifications (using Firebase Cloud Messaging) to remind users of upcoming scheduled sessions and notify them about new or pending swap requests.

### Expected Outcomes
* A versatile mobile application that facilitates seamless micro skill exchange and efficient session scheduling.
* Secure and smooth user login with robust authentication.
* Enhanced networking opportunities and effective scheduling for knowledge exchange.
* Timely notifications that increase user engagement by reminding users of scheduled sessions and pending swap requests.

## 2. Problem Statement
Individuals often have valuable skills to share but lack a platform that connects them with like-minded learners while also providing the tools to schedule and manage these exchanges efficiently. Traditional learning platforms may not offer the immediacy and personalization needed for one-to-one skill swaps, leading to missed opportunities. Additionally, without integrated scheduling, communication, and notification systems, coordinating these sessions can be cumbersome and ineffective.

## 3. Proposed Solution

### Technologies Used
* **Frontend:** Flutter (Dart) for cross-platform mobile development.
* **Backend:** Firebase for real-time database, authentication, and notifications.

### System Architecture

#### Frontend: Role-based User Interface
* **User Dashboard:**
    * Manage personal profiles, list skills offered and desired.
    * View upcoming scheduled sessions, pending requests.
* **Skill Feed:**
    * Browse and filter available skill offers.
    * Access detailed user profiles to assess match potential.
* **Swap Request & Chat:**
    * Send skill swap requests directly from profile pages.
    * Engage in real-time chat to negotiate session details.
* **Scheduling Session Page:**
    * Dedicated screen for scheduling a session:
        * Select date and time.
        * Enter location details (or virtual meeting link).
        * Provide a short description of the intended exchange.
* **Notification Center:**
    * A dedicated area within the app (or integrated with the dashboard) where users can review notifications related to upcoming sessions and pending swap requests.

#### Backend
* **Firebase Authentication:**
    * Secure login using email OTP verification (with optional WhatsApp integration for additional notifications).
* **Firebase Firestore:**
    * Store user profiles, skill listings, swap requests, chat messages, and scheduled session data.
* **Firebase Cloud Messaging:**
    * Deliver push notifications to remind users about scheduled sessions and new swap requests.
* **Cloud Functions:**
    * Automate notification triggers based on session schedules and request status.

## 4. Resources Needed

### Hardware/Software
* **Development Environment:**
    * Laptops/PCs with Flutter, Android Studio, and VS Code installed.
* **Testing Devices:**
    * Smartphones (Android) for thorough testing.
* **Backend Services:**
    * A Firebase account to manage authentication, database, cloud functions, and push notifications.

### Additional Resources
* UI/UX design tools (e.g., Figma) for prototyping and design mockups.

## 5. Getting Started

*(This section will be filled in by your team as the project progresses. It should include instructions on how to set up the development environment, clone the repository, install dependencies, and run the application.)*

**Example:**
1.  Clone the repository: `git clone https://github.com/your-username/skillswap.git`
2.  Navigate to the project directory: `cd skillswap`
3.  Install Flutter dependencies: `flutter pub get`
4.  Set up Firebase project and add configuration files (e.g., `google-services.json` for Android and `GoogleService-Info.plist` for iOS).
5.  Run the app: `flutter run`

## 6. Contributing

*(This section will outline how others can contribute to your project. You might want to include information on coding standards, pull request processes, and how to report bugs.)*

We welcome contributions to SkillSwap! If you'd like to contribute, please follow these steps:
1.  Fork the repository.
2.  Create a new branch for your feature or bug fix: `git checkout -b feature-name` or `git checkout -b bugfix-name`.
3.  Make your changes and commit them with clear and descriptive messages.
4.  Push your changes to your forked repository.
5.  Create a pull request to the main repository's `develop` or `main` branch.

Please ensure your code adheres to our coding standards and includes relevant tests.

## 7. License

*(Choose an appropriate open-source license for your project, e.g., MIT, Apache 2.0. You'll add the license text here or link to a LICENSE file in your repository.)*

This project is licensed under the [NAME OF LICENSE] - see the [LICENSE.md](LICENSE.md) file for details (if you create a separate file).

---

This README provides a good starting point. You and your team can expand on the "Getting Started," "Contributing," and "License" sections as your project develops.
