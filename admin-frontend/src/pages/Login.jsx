// =========================
// File: src/pages/Login.jsx
// Description: Admin login page to authenticate and retrieve token.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css'; // Global form styles

function Login() {
  // States to manage user input
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false); // Toggle password visibility

  const navigate = useNavigate(); // React Router hook to navigate pages

  // Function to handle login form submission
  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      // Send login credentials to backend
      const response = await axios.post('http://127.0.0.1:8000/api/token-auth/', {
        username,
        password,
      });

      // Store token in localStorage
      localStorage.setItem('token', response.data.token);

      // Navigate to dashboard
      navigate('/dashboard');
    } catch (error) {
      alert('Login failed: ' + (error.response?.data?.non_field_errors || error.message));
      console.error(error);
    }
  };

  // Toggle visibility of the password field
  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <div className="form-container">
      {/* Page Title */}
      <h2>Login</h2>

      {/* Login form */}
      <form onSubmit={handleLogin}>
        {/* Username field */}
        <div className="form-group">
          <label htmlFor="username">Username:</label>
          <input
            id="username"
            type="text"
            className="form-input"
            placeholder="Enter your username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>

        {/* Password field */}
        <div className="form-group">
          <label htmlFor="password">Password:</label>
          <input
            id="password"
            type={showPassword ? 'text' : 'password'}
            className="form-input"
            placeholder="Enter your password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        {/* Show/hide password toggle */}
        <div style={{ marginBottom: '15px' }}>
          <label>
            <input
              type="checkbox"
              checked={showPassword}
              onChange={togglePasswordVisibility}
            />{' '}
            Show Password
          </label>
        </div>

        {/* Submit login button */}
        <button type="submit" className="form-button">Log In</button>
      </form>
    </div>
  );
}

export default Login;
