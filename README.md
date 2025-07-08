# 🚀 Naviplus Project - README

Welcome to the **Naviplus** portfolio project — a full-stack web and mobile application designed to support indoor navigation for visually impaired users and manage building infrastructure via an admin dashboard.

## 🧭 Project Overview

* 📱 [Mobile App](#-naviplus---mobile-readme) - Flutter-based app for visually impaired users
* 🛠️ [Backend API](#-naviplus---backend-readme) - Django RESTful API powering mobile and admin
* 🧑‍💼 [Admin Frontend](#-naviplus---admin-frontend-readme) - React dashboard for managing buildings and PLDs

## 🏷️ Tech Stack

![Flutter](https://img.shields.io/badge/Mobile-Flutter-blue)
![Django](https://img.shields.io/badge/Backend-Django-green)
![React](https://img.shields.io/badge/Frontend-React-lightblue)
![SQLite](https://img.shields.io/badge/Database-SQLite-lightgrey)
![API](https://img.shields.io/badge/API-REST-red)

---

# 📁 Naviplus - Admin Frontend README

This is the **admin dashboard** for the Naviplus project. It is built using **React**, and allows administrators to manage buildings, PLDs (Physical Location Descriptors), and view a dashboard.

## 📌 Features

* 🔐 Admin login and token-based authentication
* 🏢 Add, update, delete buildings
* 🗺️ Add, update, delete PLDs
* 📊 Dashboard showing buildings and associated data

## 🛠️ Tech Stack

* React (Functional Components)
* React Router DOM
* Axios for API communication
* CSS Modules

## 🚀 Setup Instructions

```bash
cd admin-frontend
npm install
npm start
```

## 🔐 Authentication

* Uses token-based auth (`Authorization: Token <token>`) stored in `localStorage`
* Protected routes via `PrivateRoute.jsx`

## 🔧 Project Structure

```
src/
├── api/                # Axios base client
├── components/         # Navbar, Footer, Route protection
├── pages/              # Building/PLD CRUD, Auth, Dashboard
├── styles/             # CSS modules
└── utils/              # Axios helpers
```

## ✅ To Do / Roadmap

* Add role-based admin levels
* Add pagination and filtering
* UI enhancements and accessibility checks

---

# 📁 Naviplus - Backend README

This is the **backend API** for the Naviplus project, built with **Django** and **Django REST Framework (DRF)**. It serves both the admin frontend and the Flutter-based mobile app, providing secure, token-authenticated endpoints.

## 🧩 Features

* ✅ Token-based authentication
* ✅ Custom signup + login endpoints
* ✅ Building and PLD (Physical Location Descriptor) management
* ✅ Smart `/navigate/` endpoint for retrieving directions between PLDs
* ✅ Admin + API structure ready for scale

## 🛠️ Tech Stack

* Python 3
* Django 4.x
* Django REST Framework (DRF)
* SQLite (development)
* Token Auth (via DRF)

## 📁 Project Structure

```
backend/
├── api/                # Core API app
│   ├── models.py       # Building, PLD, UserProfile
│   ├── views.py        # ViewSets + custom navigation endpoint
│   ├── serializers.py  # Serializers for API
│   └── urls.py         # API routes
├── core/               # Django project
│   └── settings.py     # DRF + Token Auth config
├── db.sqlite3          # Dev database
├── manage.py
└── requirements.txt
```

## 🔐 Endpoints

| Method | Endpoint          | Description                                 |
| ------ | ----------------- | ------------------------------------------- |
| POST   | `/api/signup/`    | Create new user                             |
| POST   | `/api/login/`     | Obtain token                                |
| GET    | `/api/buildings/` | List buildings (auth only)                  |
| GET    | `/api/plds/`      | Filtered by `building` param                |
| GET    | `/api/navigate/`  | Get directions: ?building=1\&start=X\&end=Y |

> All protected routes require: `Authorization: Token <your_token>`

## ⚙️ Setup Instructions

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## 🧪 Test Users

You can create a test user via:

```bash
curl -X POST http://localhost:8000/api/signup/ \
  -H 'Content-Type: application/json' \
  -d '{"username": "testuser", "password": "pass1234"}'
```

## ✅ Roadmap / Improvements

* Add floor-level navigation logic
* Include admin-level permissions
* Add OpenAPI/Swagger documentation
* Add unit + integration tests

---

# 📁 Naviplus - Mobile README

This is the **Flutter-based mobile app** for the Naviplus project. It enables visually impaired users to access voice-guided indoor navigation within buildings managed through the backend/admin dashboard.

## 📌 Features

* 🔐 Login and signup for users
* 📡 Fetch buildings and PLDs from API
* 🔁 Voice command support (e.g., "navigate from entrance to lift")
* 🔊 Text-to-Speech for spoken guidance
* 🧭 Turn-by-turn indoor navigation using PLD-based routes
* 🗺️ Google Maps integration (optional)

## 🛠️ Tech Stack

* Flutter + Dart
* flutter\_tts
* speech\_to\_text
* shared\_preferences
* http (REST API)

## 📁 Directory Structure

```
lib/
├── main.dart
├── models/             # Data models (Building, PLD)
├── screens/            # Login, Signup, Navigation, Voice UI, etc.
├── services/           # api_service.dart
└── widgets/            # Reusable UI components
```

## 🚀 Setup Instructions

```bash
cd mobile
flutter pub get
flutter run
```

> ✅ Make sure your emulator/device has microphone and TTS support.

## 🔐 Authentication

* Token is saved in `SharedPreferences`
* All API requests include `Authorization: Token <token>`

## 🧪 Voice Usage

* Voice Command Screen: "Navigate from X to Y"
* Screen auto-detects voice commands and opens navigation

## ✅ Roadmap

* Improve TTS accessibility
* Save navigation history locally
* Integrate with real Google Indoor Maps (future)