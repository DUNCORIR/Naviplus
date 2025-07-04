// =========================
// File: src/pages/PLDsList.jsx
// Description: Lists and creates PLDs (location descriptors) for a selected building.
// =========================

import React, { useEffect, useState } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import api from '../utils/axiosClient';
import '../styles/Form.css';

function PLDsList() {
  const [plds, setPlds] = useState([]);
  const [description, setDescription] = useState('');
  const [buildingId, setBuildingId] = useState(null);
  const [error, setError] = useState('');
  const navigate = useNavigate();
  const location = useLocation();

  // Extract building_id from query params
  useEffect(() => {
    const params = new URLSearchParams(location.search);
    const id = params.get('building_id');

    if (!id) {
      setError('No building selected.');
      return;
    }

    setBuildingId(id);

    // Check for token
    const token = localStorage.getItem('token');
    if (!token) {
      navigate('/login');
      return;
    }

    // Fetch PLDs
    api.get(`plds/?building_id=${id}`)
      .then((res) => setPlds(res.data))
      .catch((err) => {
        console.error(err);
        setError('Failed to fetch PLDs');
      });
  }, [location, navigate]);

  // Create a new PLD
  const handleCreate = async (e) => {
    e.preventDefault();
    try {
      const res = await api.post('plds/', {
        description,
        building: buildingId,
      });
      setPlds([...plds, res.data]);
      setDescription('');
    } catch (err) {
      alert('Failed to create PLD');
      console.error(err);
    }
  };

  // Logout function
  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate('/login');
  };

  return (
    <div className="form-container">
      <h2>Physical Location Descriptors (PLDs)</h2>

      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* Navigation buttons */}
      <div className="button-row">
        <button onClick={() => navigate('/buildings')} className="form-button">
          Back to Buildings
        </button>
        <button onClick={handleLogout} className="form-button logout-button">
          Logout
        </button>
      </div>

      {/* Form to create new PLD */}
      <form onSubmit={handleCreate} className="form-inline">
        <input
          type="text"
          className="form-input"
          placeholder="Enter PLD description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          required
        />
        <button type="submit" className="form-button">Add PLD</button>
      </form>

      {/* List of PLDs */}
      <ul className="form-list">
        {plds.map((pld) => (
          <li key={pld.id} className="form-list-item">
            {pld.description}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default PLDsList;