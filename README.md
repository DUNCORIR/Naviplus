Naviplus - Smart Navigation for the Visually Impaired

Naviplus is a full-stack portfolio project designed to improve indoor navigation for visually impaired individuals. It features a Django backend, a React-based admin dashboard, and a Flutter-powered mobile app with voice and text-to-speech accessibility.

🌐 Project Structure
Naviplus/
├── backend/             # Django REST API
├── admin-frontend/     # React Admin Dashboard
├── mobile/             # Flutter Mobile App
└── README.md           # Project Overview (this file)

📄 Backend Overview (/backend)

Django REST Framework

Token-based authentication

Models: Building, PLD (Physical Location Descriptor), UserProfile

Endpoints: /api/buildings/, /api/plds/, /api/navigate/, /api/login/, /api/signup/

SQLite for development

✅ Fully tested with frontend + mobile clients

🌐 Admin Frontend (/admin-frontend)

Built with React + Axios

Authentication via JWT

Key Features:

Add/edit buildings

Add/edit PLDs (entrances, elevators, etc.)

Dashboard overview

Routing with React Router

CSS modules for styling

📱 Mobile App (/mobile)

Built with Flutter

Target audience: visually impaired users

Features:

Accessible welcome screen (TTS)

Login + token storage

Voice command navigation (speech_to_text, flutter_tts)

Scan buildings + Get directions

Google Maps integration coming soon

Screens: Login, Welcome, Menu, ScanBuilding, NavigationAssistance, VoiceCommand

Optimized for both emulator and real Android devices

🔢 Setup Instructions

Backend:
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver

Admin Frontend:

cd admin-frontend
npm install
npm start

Mobile App:
cd mobile
flutter pub get
flutter run
Note: Emulator setup via Android Studio is required for mobile testing.

🔐 Authentication Flow

User signs up or logs in (mobile / dashboard)

Token is stored (localStorage for React, SharedPreferences for Flutter)

All API requests include Authorization: Token <token> header

🎨 Future Improvements

Google Maps integration for mobile

Offline navigation mode

Admin role-based permissions

Advanced voice command handling ("Start from entrance to stairs")

👩‍💻 Contributors

Duncan Korir

[Team contributions managed via GitHub commits & pull requests]

🌎 License

This project is for educational and demonstration purposes only by Alx.