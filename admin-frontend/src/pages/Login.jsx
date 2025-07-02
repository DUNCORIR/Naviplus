// =========================
// File: src/pages/Login.jsx
// Description: Admin login page with better layout, styling, and inline error handling.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import '../styles/Form.css';  // Shared form styles
import { useNavigate } from 'react-router-dom';

function Login() {
  // State for input fields
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  // Navigation and error handling
  const navigate = useNavigate();
  const [error, setError] = useState('');

  // Handle login form submission
  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://127.0.0.1:8000/api/token-auth/', {
        username,
        password,
      });

      localStorage.setItem('token', response.data.token);
      navigate('/dashboard');
    } catch (err) {
      setError('Invalid username or password');
      console.error(err);
    }
  };

  return (
    <div className="form-container">
      <h2>Admin Login</h2>

      {/* Inline error message */}
      {error && <p style={{ color: 'red', marginBottom: '10px' }}>{error}</p>}

      {/* Login form */}
      <form onSubmit={handleLogin} className="form-group">
        <div className="form-group">
          <label htmlFor="username">Username</label>
          <input
            id="username"
            type="text"
            className="form-input"
            placeholder="Enter username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input
            id="password"
            type="password"
            className="form-input"
            placeholder="Enter password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        <button type="submit" className="form-button">Log In</button>
      </form>
    </div>
  );
}

export default Login;