// =========================
// File: src/pages/LandingPage.jsx
// Description: Public-facing landing page that describes what the platform does and directs users to log in or sign up.
// =========================

import React from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/LandingPage.css';

function LandingPage() {
  const navigate = useNavigate();

  // Navigate to login page
  const goToLogin = () => navigate('/login');

  // Navigate to signup page
  const goToSignup = () => navigate('/signup');

  return (
    <div className="landing-container">
      {/* Headline and tagline */}
      <h1 className="landing-title">Welcome to Naviplus</h1>
      <p className="landing-subtitle">
        A smart building management platform for tracking physical locations and descriptors.
      </p>

      {/* Feature summary */}
      <ul className="landing-features">
        <li>✅ Manage multiple buildings from one place</li>
        <li>✅ Add and view PLDs (Physical Location Descriptors)</li>
        <li>✅ Token-secured login for administrators</li>
      </ul>

      {/* CTA buttons */}
      <div className="landing-buttons">
        <button onClick={goToLogin} className="form-button">Log In</button>
        <button onClick={goToSignup} className="form-button">Sign Up</button>
      </div>
    </div>
  );
}

export default LandingPage;