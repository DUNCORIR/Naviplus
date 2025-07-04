// =========================
// File: src/components/Navbar.jsx
// Description: Responsive navigation bar with conditional links and logout
// =========================

import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../styles/Navbar.css'; // Global navbar styles

function Navbar() {
  const [menuOpen, setMenuOpen] = useState(false); // Controls mobile menu toggle
  const navigate = useNavigate();
  const token = localStorage.getItem('authToken'); // Get token to check auth state

  // Toggle menu in mobile view
  const toggleMenu = () => setMenuOpen(!menuOpen);

  // Close menu when a link is clicked
  const closeMenu = () => setMenuOpen(false);

  // Handle logout: clear token and redirect to login
  const handleLogout = () => {
    localStorage.removeItem('authToken');
    navigate('/login');
  };

  return (
    <nav className="navbar">
      {/* Brand: Logo + Title */}
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

      {/* Navigation links (conditionally shown based on login) */}
      <div className={`navbar-links ${menuOpen ? 'show' : ''}`}>
        <Link to="/" className="navbar-link" onClick={closeMenu}>Home</Link>

        {token ? (
          <Link to="/logout" className="navbar-link" onClick={() => {
            localStorage.removeItem('authToken');
            closeMenu();
            window.location.href = "/login";
          }}>Logout</Link>
        ) : (
          <>
            <Link to="/login" className="navbar-link" onClick={closeMenu}>Login</Link>
            <Link to="/signup" className="navbar-link" onClick={closeMenu}>Sign Up</Link>
          </>
        )}

        {token && (
          <>
            <Link to="/dashboard" className="navbar-link" onClick={closeMenu}>Dashboard</Link>
            <Link to="/buildings" className="navbar-link" onClick={closeMenu}>Manage Buildings</Link>
            <Link to="/add-building" className="navbar-link" onClick={closeMenu}>Add Building</Link>
            <span
              className="navbar-link"
              onClick={() => {
                closeMenu();
                handleLogout();
              }}
              style={{ cursor: 'pointer' }}
            >
              Logout
            </span>
          </>
        )}
      </div>
    </nav>
  );
}

export default Navbar;