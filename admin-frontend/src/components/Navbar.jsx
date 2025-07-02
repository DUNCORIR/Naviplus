// =========================
// File: src/components/Navbar.jsx
// Description: Top navigation bar for switching between views.
// =========================

import React from 'react';
import { Link } from 'react-router-dom';
import './Navbar.css'; 

function Navbar() {
  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/dashboard" className="nav-link">Dashboard</Link>
        <Link to="/buildings" className="nav-link">Buildings</Link>
        <Link to="/plds" className="nav-link">PLDs</Link>
        <Link to="/add-building" className="nav-link">Add Building</Link>
        <Link to="/signup" className="nav-link">Sign Up</Link>
        <Link to="/login" className="nav-link">Logout</Link>
      </div>
    </nav>
  );
}

export default Navbar;
