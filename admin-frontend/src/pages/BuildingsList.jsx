// =========================
// File: src/pages/BuildingsList.jsx
// Description: Lists all buildings from the backend API with token-based access. Includes create, logout, and link to PLDs.
// =========================

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../utils/axiosConfig';

function BuildingsList() {
  const [buildings, setBuildings] = useState([]);
  const [error, setError] = useState('');
  const [name, setName] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('token');
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

  // Handle logout and clear token
  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate('/login');
  };

  // Handle building creation
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
    <div style={{ maxWidth: '600px', margin: 'auto', padding: '20px' }}>
      <h2>Building List</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* Logout button */}
      <button onClick={handleLogout} style={{ marginBottom: '20px' }}>Logout</button>

      {/* Create new building */}
      <form onSubmit={handleCreate} style={{ marginBottom: '20px' }}>
        <input
          type="text"
          placeholder="New building name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
          style={{ marginRight: '10px', padding: '5px' }}
        />
        <button type="submit">Add Building</button>
      </form>

      <ul>
        {buildings.map((building) => (
          <li key={building.id}>
            {building.name} &nbsp;
            <a href={`/plds?building_id=${building.id}`}>View PLDs</a>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BuildingsList;