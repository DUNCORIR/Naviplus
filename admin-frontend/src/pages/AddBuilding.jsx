// =========================
// File: src/pages/AddBuilding.jsx
// Description: Form to create a new building entry using API.
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css';  // ✅ Import shared styling

function AddBuilding() {
  const [name, setName] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');
  const [description, setDescription] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem('authToken');

    try {
      await axios.post('http://127.0.0.1:8000/api/buildings/', {
        name,
        latitude: parseFloat(latitude),
        longitude: parseFloat(longitude),
        description
      }, {
        headers: {
          Authorization: `Token ${token}`
        }
      });

      alert('Building created successfully.');
      navigate('/buildings');
    } catch (error) {
      alert('Failed to create building: ' + (error.response?.data?.detail || error.message));
      console.error(error.response?.data);
    }
  };

  return (
    <div className="form-container">
      <h2>Add New Building</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Building Name:</label>
          <input
            id="name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="latitude">Latitude:</label>
          <input
            id="latitude"
            type="number"
            step="any"
            value={latitude}
            onChange={(e) => setLatitude(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="longitude">Longitude:</label>
          <input
            id="longitude"
            type="number"
            step="any"
            value={longitude}
            onChange={(e) => setLongitude(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="description">Description (optional):</label>
          <textarea
            id="description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
        </div>

        <button type="submit" className="form-button">Create Building</button>
      </form>
    </div>
  );
}

export default AddBuilding;