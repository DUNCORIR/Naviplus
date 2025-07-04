// =========================
// File: src/pages/BuildingsList.jsx
// Description: Lists all buildings from the backend API with token-based access. Includes create, logout, and link to PLDs.
// =========================

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/axiosClient';
import '../styles/Form.css'; // ✅ Apply shared styles

function BuildingsList() {
  const [buildings, setBuildings] = useState([]);
  const [error, setError] = useState('');
  const [name, setName] = useState('');
  const navigate = useNavigate();

  // Fetch buildings on page load
  useEffect(() => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      navigate('/login');
      return;
    }

    api.get('buildings/')
      .then((response) => {
        setBuildings(response.data);
      })
      .catch((err) => {
        console.error(err);
        setError('Failed to fetch buildings. Redirecting to login...');
        navigate('/login');
      });
  }, [navigate]);

  // Logout handler
  const handleLogout = () => {
    localStorage.removeItem('authToken');
    navigate('/login');
  };

  // Create building handler
  const handleCreate = async (e) => {
    e.preventDefault();
    try {
      const response = await api.post('buildings/', { name });
      setBuildings([...buildings, response.data]);
      setName('');
    } catch (err) {
      alert('Failed to create building');
      console.error(err);
    }
  };

  return (
    <div className="form-container">
      <h2>Building List</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* Logout */}
      <button onClick={handleLogout} className="form-button" style={{ marginBottom: '20px' }}>
        Logout
      </button>

      {/* Create new building form */}
      <form onSubmit={handleCreate} className="form-inline">
        <input
          type="text"
          placeholder="New building name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
          className="form-input"
        />
        <button type="submit" className="form-button">Add Building</button>
      </form>

      {/* List buildings */}
      <ul className="form-list">
        {buildings.map((building) => (
          <li key={building.id} className="form-list-item">
            <strong>{building.name}</strong> — 
            <a href={`/plds?building_id=${building.id}`} style={{ marginLeft: '8px' }}>
              View PLDs
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BuildingsList;