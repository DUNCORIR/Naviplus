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