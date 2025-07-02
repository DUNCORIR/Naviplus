// =========================
// File: src/pages/AddPLD.jsx
// Description: Form to add a new Physical Location Descriptor (PLD).
// =========================

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css';  // ✅ Import shared form styling

function AddPLD() {
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [building, setBuilding] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem('authToken');

    try {
      await axios.post('http://127.0.0.1:8000/api/plds/', {
        name,
        description,
        building,
      }, {
        headers: {
          Authorization: `Token ${token}`
        }
      });

      alert('PLD created successfully.');
      navigate('/plds');
    } catch (error) {
      alert('Failed to create PLD: ' + (error.response?.data?.detail || error.message));
    }
  };

  return (
    <div className="form-container">
      <h2>Add New PLD</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">PLD Name:</label>
          <input
            id="name"
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="description">Description:</label>
          <input
            id="description"
            type="text"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="building">Building ID:</label>
          <input
            id="building"
            type="number"
            value={building}
            onChange={(e) => setBuilding(e.target.value)}
            required
          />
        </div>

        <button type="submit" className="form-button">Create PLD</button>
      </form>
    </div>
  );
}

export default AddPLD;