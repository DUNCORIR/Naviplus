// =========================
// File: src/components/Navbar.jsx
// Description: Responsive navigation bar with Naviplus logo and hamburger toggle
// =========================

import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import '../styles/Navbar.css'; // Import stylesheet

function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false); // State to control mobile menu

  // Toggle menu visibility on mobile
  const toggleMenu = () => setMenuOpen(!menuOpen);

  // Close menu when a link is clicked
  const closeMenu = () => setMenuOpen(false);

  return (
    <nav className="navbar">
      {/* Brand: logo + title */}
      <div className="navbar-brand">
        <div className="navbar-logo-wrapper">
          <img
            src="/images/naviplus-logo.png"
            alt="Naviplus Logo"
            className="navbar-logo"
          />
        </div>
        <Link to="/" className="navbar-link brand-link">Naviplus</Link>
      </div>

      {/* Hamburger icon for mobile view */}
      <div className="navbar-toggle" onClick={toggleMenu}>
        <span></span>
        <span></span>
        <span></span>
      </div>

      {/* Main navigation links */}
      <div className={`navbar-links ${menuOpen ? 'show' : ''}`}>
        <Link to="/" className="navbar-link" onClick={closeMenu}>Home</Link>
        <Link to="/login" className="navbar-link" onClick={closeMenu}>Login</Link>
        <Link to="/buildings" className="navbar-link" onClick={closeMenu}>Manage Buildings</Link>
        <Link to="/add-building" className="navbar-link" onClick={closeMenu}>Add Building</Link>
        <Link to="/signup" className="navbar-link" onClick={closeMenu}>Sign Up</Link>
      </div>
    </nav>
  );
}

export default Navbar;