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
import Footer from './components/Footer';


function App() {
  return (
    <Router>
      <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
        <Navbar />

        {/* Main content grows to push footer down */}
        <main style={{ flex: '1' }}>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/signup" element={<Signup />} />
            <Route path="/buildings" element={<BuildingsList />} />
            <Route path="/plds" element={<PLDsList />} />
            <Route path="/plds/new" element={<PLDCreate />} />
            <Route path="/add-building" element={<AddBuilding />} />
          </Routes>
        </main>

        {/* Footer stays at the bottom */}
        <Footer />
      </div>
    </Router>
  );
}

export default App;