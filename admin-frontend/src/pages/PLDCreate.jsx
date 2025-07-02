// =========================
// File: src/pages/PLDCreate.jsx
// Description: Form to create a new PLD and assign it to a building.
// =========================

import React, { useEffect, useState } from 'react';
import axios from '../utils/axiosConfig';
import { useNavigate } from 'react-router-dom';

function PLDCreate() {
  const [label, setLabel] = useState('');
  const [buildingId, setBuildingId] = useState('');
  const [buildings, setBuildings] = useState([]);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    // Fetch buildings for dropdown
    const token = localStorage.getItem('authToken');
    if (!token) {
      navigate('/login');
      return;
    }

    axios.get('http://127.0.0.1:8000/api/buildings/', {
      headers: { Authorization: `Token ${token}` }
    })
    .then((res) => {
      setBuildings(res.data);
    })
    .catch((err) => {
      console.error(err);
      setError('Failed to load buildings.');
    });
  }, [navigate]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const token = localStorage.getItem('authToken');

    try {
      await axios.post('http://127.0.0.1:8000/api/plds/', {
        label,
        building: buildingId
      }, {
        headers: { Authorization: `Token ${token}` }
      });
      alert('PLD created successfully');
      navigate('/plds');
    } catch (err) {
      console.error(err);
      setError('Failed to create PLD. Please check input.');
    }
  };

  return (
    <div style={{ maxWidth: '500px', margin: 'auto', padding: '20px' }}>
      <h2>Create PLD</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: '10px' }}>
          <label>Label:</label>
          <input
            type="text"
            value={label}
            onChange={(e) => setLabel(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          />
        </div>
        <div style={{ marginBottom: '10px' }}>
          <label>Building:</label>
          <select
            value={buildingId}
            onChange={(e) => setBuildingId(e.target.value)}
            required
            style={{ width: '100%', padding: '8px' }}
          >
            <option value="">Select a building</option>
            {buildings.map((b) => (
              <option key={b.id} value={b.id}>
                {b.name}
              </option>
            ))}
          </select>
        </div>
        <button type="submit" style={{ width: '100%', padding: '10px' }}>
          Create PLD
        </button>
      </form>
    </div>
  );
}

export default PLDCreate;