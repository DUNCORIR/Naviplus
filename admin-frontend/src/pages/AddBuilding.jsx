// =========================
// File: src/pages/AddBuilding.jsx
// Description: Form to create a new building entry using API.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function AddBuilding() {
  const [name, setName] = useState('');
  const [location, setLocation] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem('authToken');

    try {
      await axios.post('http://127.0.0.1:8000/api/buildings/', {
        name,
        location,
      }, {
        headers: {
          Authorization: `Token ${token}`
        }
      });
      alert('Building created successfully.');
      navigate('/buildings'); // Redirect to building list
    } catch (error) {
      alert('Failed to create building: ' + (error.response?.data?.detail || error.message));
    }
  };

  return (
    <div style={{ maxWidth: '400px', margin: 'auto' }}>
      <h2>Add New Building</h2>
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: '10px' }}>
          <label htmlFor="name">Building Name:</label>
          <input
            id="name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <div style={{ marginBottom: '10px' }}>
          <label htmlFor="location">Location:</label>
          <input
            id="location"
            type="text"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <button type="submit" style={{ padding: '10px', width: '100%' }}>Create Building</button>
      </form>
    </div>
  );
}

export default AddBuilding;