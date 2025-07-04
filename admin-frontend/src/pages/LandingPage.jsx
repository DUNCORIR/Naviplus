// =========================
// File: src/pages/LandingPage.jsx
// Description: Public-facing landing page describing Naviplus and guiding users to Sign Up or Log In.
// =========================

import React from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/LandingPage.css'; // Import styles
import { FaBuilding, FaListUl, FaLock } from 'react-icons/fa'; // Icons for features

function LandingPage() {
  const navigate = useNavigate();

  // Navigate to login page
  const goToLogin = () => navigate('/login');

  // Navigate to signup page
  const goToSignup = () => navigate('/signup');

  return (
    <div className="landing-container">
      {/* =========================
          Hero Section: Image, Title & Subtitle
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
          Feature Highlights
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
          Call-To-Action Section (Sign Up & Log In)
      ========================= */}
      <section className="landing-cta">
        {/* CTA Block for Sign Up */}
        <div className="cta-block cta-signup">
          <h3>New to Naviplus?</h3>
          <p>Create an account to start managing buildings and PLDs.</p>
          <button onClick={goToSignup} className="cta-button">Sign Up</button>
        </div>

        {/* CTA Block for Log In */}
        <div className="cta-block cta-login">
          <h3>Already have an account?</h3>
          <p>Log in to access your admin dashboard.</p>
          <button onClick={goToLogin} className="cta-button secondary">Log In</button>
        </div>
      </section>
    </div>
  );
}

export default LandingPage;