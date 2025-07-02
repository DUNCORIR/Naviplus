// =========================
// File: src/App.js
// Description: Main React entry point with routing logic.
// =========================

import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Navbar from './components/Navbar';
import BuildingsList from './pages/BuildingsList';
import Signup from './pages/Signup';
import PLDsList from './pages/PLDsList';
import PLDCreate from './pages/PLDCreate';
import AddBuilding from './pages/AddBuilding';



function App() {
  return (
    <Router>
      <Navbar />
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/buildings" element={<BuildingsList />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/plds" element={<PLDsList />} />
        <Route path="/plds/new" element={<PLDCreate />} />
        <Route path="/add-building" element={<AddBuilding />} />

        {/* More routes will be added here */}
      </Routes>
    </Router>
  );
}

export default App;