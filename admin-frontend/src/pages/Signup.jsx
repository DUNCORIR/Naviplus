// =========================
// File: src/pages/Signup.jsx
// Description: Signup form to create admin account with password visibility toggle.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css';

// Signup component for new user registration
function Signup() {
  // Form field state
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false); // Toggle password visibility
  const [error, setError] = useState('');
  const navigate = useNavigate();

  // Handle form submission to create new user
  const handleSignup = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://127.0.0.1:8000/api/signup/', { username, password });
      alert('Signup successful. You can now log in.');
      navigate('/login'); // Redirect to login on success
    } catch (err) {
      setError(err.response?.data?.error || 'Signup failed.'); // Show error
    }
  };

  return (
    // Container for signup form
    <div className="form-container">
      <h2>Sign Up</h2>

      {/* Display error message if any */}
      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* Signup form with username and password inputs */}
      <form onSubmit={handleSignup} className="form-group">
        {/* Username input */}
        <div className="form-group">
          <label htmlFor="username">Username:</label>
          <input
            type="text"
            id="username"
            className="form-input"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>

        {/* Password input with toggle */}
        <div className="form-group">
          <label htmlFor="password">Password:</label>
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <input
              type={showPassword ? 'text' : 'password'}
              id="password"
              className="form-input"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{ flex: 1 }}
            />
            {/* Button to toggle password visibility */}
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              style={{
                marginLeft: '10px',
                padding: '8px',
                fontSize: '12px',
                cursor: 'pointer',
              }}
            >
              {showPassword ? 'Hide' : 'Show'}
            </button>
          </div>
        </div>

        {/* Submit button */}
        <button type="submit" className="form-button">Sign Up</button>
      </form>
    </div>
  );
}

export default Signup;