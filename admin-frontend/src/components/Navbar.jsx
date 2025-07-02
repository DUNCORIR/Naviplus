// =========================
// File: src/components/NavBar.jsx
// Description: Navigation bar with links to different app routes.
// =========================

import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/Navbar.css';  // Import the NavBar-specific styles

function NavBar() {
  return (
    <nav className="navbar">
      {/* App Title / Brand */}
      <div className="navbar-brand">
        <Link to="/" className="navbar-link brand-link">Naviplus</Link>
      </div>

      {/* Navigation Links */}
      <div className="navbar-links">
        <Link to="/" className="navbar-link">Home</Link>
        <Link to="/signup" className="navbar-link">Sign Up</Link>
        <Link to="/login" className="navbar-link">Login</Link>
        <Link to="/buildings" className="navbar-link">Manage Buildings</Link>
        <Link to="/add-building" className="navbar-link">Add Building</Link>
      </div>
    </nav>
  );
}

export default NavBar;