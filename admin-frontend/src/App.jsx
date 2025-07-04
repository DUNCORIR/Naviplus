// =========================
// File: src/App.jsx
// Description: Main React entry point with routing logic and route protection.
// =========================

import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Signup from './pages/Signup';
import Navbar from './components/Navbar';
import BuildingsList from './pages/BuildingsList';
import AddBuilding from './pages/AddBuilding';

/**
 * Wrapper component to protect private routes.
 * Redirects to /login if no auth token found in localStorage.
 */
const PrivateRoute = ({ element }) => {
  const token = localStorage.getItem('authToken');
  return token ? element : <Navigate to="/login" replace />;
};

function App() {
  return (
    <Router>
      <Navbar /> {/* Navigation bar shown on all pages */}

      <Routes>
        {/* Public routes */}
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />

        {/* Protected routes */}
        <Route path="/dashboard" element={<PrivateRoute element={<Dashboard />} />} />
        <Route path="/buildings" element={<PrivateRoute element={<BuildingsList />} />} />
        <Route path="/add-building" element={<PrivateRoute element={<AddBuilding />} />} />

        {/* Redirect all other paths to login or dashboard */}
        <Route path="*" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </Router>
  );
}

export default App;