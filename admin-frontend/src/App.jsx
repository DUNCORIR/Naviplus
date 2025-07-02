// =========================
// File: src/App.jsx
// Description: Main React entry point with routing logic.
// =========================

import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Navbar from './components/Navbar';
import Signup from './pages/Signup';

function App() {
  return (
    <Router>
      <Navbar /> {/* Always visible navigation */}
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/signup" element={<Signup />} />
        {/* More routes will be added here */}
      </Routes>
    </Router>
  );
}

export default App;