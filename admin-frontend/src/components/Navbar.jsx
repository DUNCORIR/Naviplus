// =========================
// File: src/components/Navbar.jsx
// Description: Responsive navigation bar with Naviplus logo and hamburger toggle
// =========================

import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../styles/Navbar.css'; // Import stylesheet

function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);


  // On mount, check token presence
  useEffect(() => {
    const token = localStorage.getItem('authToken');
    setIsAuthenticated(!!token); // Set true if token exists
  }, []);

  // Toggle mobile menu
  const toggleMenu = () => setMenuOpen(!menuOpen);

  // Close menu
  const closeMenu = () => setMenuOpen(false);

  return (
    <nav className="navbar">
      {/* Logo and Brand */}
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

      {/* Hamburger toggle */}
      <div className="navbar-toggle" onClick={toggleMenu}>
        <span></span>
        <span></span>
        <span></span>
      </div>

      {/* Navigation Links */}
      <div className={`navbar-links ${menuOpen ? 'show' : ''}`}>
        <Link to="/" className="navbar-link" onClick={closeMenu}>Home</Link>

        {/* Auth-specific links */}
        {!isAuthenticated ? (
          <>
            <Link to="/login" className="navbar-link" onClick={closeMenu}>Login</Link>
            <Link to="/signup" className="navbar-link" onClick={closeMenu}>Sign Up</Link>
          </>
        ) : (
          <>
            <Link to="/buildings" className="navbar-link" onClick={closeMenu}>Manage Buildings</Link>
            <Link to="/add-building" className="navbar-link" onClick={closeMenu}>Add Building</Link>

            {/* Remove this Logout link if you prefer Logout button only in BuildingsList */}
            {/* <button onClick={handleLogout} className="navbar-link logout-button">Logout</button> */}
          </>
        )}
      </div>
    </nav>
  );
}

export default Navbar;