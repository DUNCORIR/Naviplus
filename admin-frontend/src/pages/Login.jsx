// =========================
// File: src/pages/Login.jsx
// Description: Admin login page to authenticate and retrieve token, then redirect.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';  // React Router hook to navigate pages

function Login() {
  // Form input state
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  // useNavigate allows redirecting after login
  const navigate = useNavigate();

  // Handle form submission for login
  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      // Send login request to Django API
      const response = await axios.post('http://127.0.0.1:8000/api/token-auth/', {
        username,
        password,
      });

      // Save token to local storage
      localStorage.setItem('Token', response.data.token);

      // Redirect to dashboard
      navigate('/dashboard');
    } catch (error) {
      alert('Login failed: ' + error.message);
      console.error(error);
    }
  };

  return (
    <div>
      <h2>Login</h2>
      {/* Login form for username and password */}
      <form onSubmit={handleLogin}>
        <input
          type="text"
          placeholder="Username"
          onChange={(e) => setUsername(e.target.value)}
          required
        /><br />
        <input
          type="password"
          placeholder="Password"
          onChange={(e) => setPassword(e.target.value)}
          required
        /><br />
        <button type="submit">Log In</button>
      </form>
    </div>
  );
}

export default Login;