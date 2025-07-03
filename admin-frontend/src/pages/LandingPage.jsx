// =========================
// File: src/pages/LandingPage.jsx
// Description: Public-facing landing page that describes what the platform does and directs users to log in or sign up.
// =========================

import React from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/LandingPage.css';
import { FaBuilding, FaListUl, FaLock } from 'react-icons/fa'; // Feature icons

// =========================
// Component: LandingPage
// Description: Entry page with branding, hero image, features, and navigation
// =========================
function LandingPage() {
  const navigate = useNavigate();

  // Navigate to login page
  const goToLogin = () => navigate('/login');

  // Navigate to signup page
  const goToSignup = () => navigate('/signup');

  return (
    <div className="landing-container">
      {/* =========================
          Hero Section
          ========================= */}
      <section className="landing-hero">
        <img
          src="/images/hero-building.jpg"
          alt="Illustration of building navigation"
          className="hero-image"
        />
        <h1 className="landing-title">
          Welcome to <span className="brand-text">Naviplus</span>
        </h1>
        <p className="landing-subtitle">
          A smart building management platform for tracking physical locations and descriptors.
        </p>
      </section>

      {/* =========================
          Feature Cards Section
          ========================= */}
      <section className="landing-features-section">
        <div className="feature-card">
          <FaBuilding className="feature-icon" />
          <p><strong>Manage multiple buildings</strong> from one place</p>
        </div>

        <div className="feature-card">
          <FaListUl className="feature-icon" />
          <p><strong>Add and view PLDs</strong> (Physical Location Descriptors)</p>
        </div>

        <div className="feature-card">
          <FaLock className="feature-icon" />
          <p><strong>Token-secured login</strong> for administrators</p>
        </div>
      </section>

      {/* =========================
          Call-to-Action Buttons Section
          ========================= */}
      <section className="landing-buttons">
        <button onClick={goToLogin} className="form-button">Log In</button>
        <button onClick={goToSignup} className="form-button">Sign Up</button>
      </section>
    </div>
  );
}

export default LandingPage;