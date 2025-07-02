// =========================
// File: src/pages/Signup.jsx
// Description: Signup form to create admin account and get token.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css';  // Import the shared form styles

function Signup() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleSignup = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://127.0.0.1:8000/api/signup/', {
        username,
        password,
      });
      alert('Signup successful. You can now log in.');
      navigate('/login');
    } catch (err) {
      alert('Signup failed: ' + (err.response?.data?.error || err.message));
    }
  };

  return (
    <div className="form-container">
      <h2>Sign Up</h2>
      <form onSubmit={handleSignup}>
        <div className="form-group">
          <label htmlFor="username">Username:</label>
          <input
            type="text"
            id="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password:</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        <button type="submit" className="form-button">Sign Up</button>
      </form>
    </div>
  );
}

export default Signup;