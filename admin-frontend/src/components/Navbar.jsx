// =========================
// File: src/components/Navbar.jsx
// Description: Responsive navigation bar with hamburger toggle
// =========================

import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import '../styles/Navbar.css'; // Correctly linked style sheet

function Navbar() {
  // State for toggling mobile menu visibility
  const [menuOpen, setMenuOpen] = useState(false);

  // Function to toggle menu open/close
  const toggleMenu = () => {
    setMenuOpen(!menuOpen);
  };

  // Function to close menu when a link is clicked
  const closeMenu = () => {
    setMenuOpen(false);
  };

  return (
    <nav className="navbar">
      {/* Brand logo or title */}
      <div className="navbar-brand">
        <Link to="/" className="navbar-link brand-link">Naviplus</Link>
      </div>

      {/* Hamburger icon for mobile */}
      <div className="navbar-toggle" onClick={toggleMenu}>
        <span></span>
        <span></span>
        <span></span>
      </div>

      {/* Navigation links */}
      <div className={`navbar-links ${menuOpen ? 'show' : ''}`}>
        <Link to="/" className="navbar-link" onClick={closeMenu}>Home</Link>
        <Link to="/signup" className="navbar-link" onClick={closeMenu}>Sign Up</Link>
        <Link to="/login" className="navbar-link" onClick={closeMenu}>Login</Link>
        <Link to="/buildings" className="navbar-link" onClick={closeMenu}>Manage Buildings</Link>
        <Link to="/add-building" className="navbar-link" onClick={closeMenu}>Add Building</Link>
      </div>
    </nav>
  );
}

export default Navbar;