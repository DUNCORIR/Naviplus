// =========================
// File: src/pages/Signup.jsx
// Description: Signup form to create admin account and get token.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Signup() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();  // Initialize navigation

  // Function to handle signup form submission
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
  

  // Render the signup form
  return (
    <div style={{ maxWidth: '400px', margin: 'auto', padding: '20px' }}>
      <h2>Sign Up</h2>
      <form onSubmit={handleSignup}>
        <div style={{ marginBottom: '10px' }}>
          <label htmlFor="username">Username:</label>
          <input
            type="text"
            id="username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
            style={{ width: '100%', padding: '8px', boxSizing: 'border-box' }}
          />
        </div>
        <div style={{ marginBottom: '10px' }}>
          <label htmlFor="password">Password:</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            style={{ width: '100%', padding: '8px', boxSizing: 'border-box' }}
          />
        </div>
        <button type="submit" style={{ width: '100%', padding: '10px' }}>Sign Up</button>
      </form>
    </div>
  );
}

export default Signup;
