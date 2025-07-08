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
