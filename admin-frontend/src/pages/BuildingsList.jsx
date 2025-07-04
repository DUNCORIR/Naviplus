// =========================
// File: src/pages/BuildingsList.jsx
// Description: Lists all buildings from the backend API with token-based access. 
// Includes create, logout, and link to PLDs.
// =========================

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api/axiosClient';  // ✅ Axios instance with token config
import '../styles/Form.css';           // ✅ Shared form styling

function BuildingsList() {
  // State to store buildings retrieved from the backend
  const [buildings, setBuildings] = useState([]);

  // Error state in case fetching fails
  const [error, setError] = useState('');

  // State for new building name input
  const [name, setName] = useState('');

  const navigate = useNavigate(); // Hook to programmatically redirect

  // On component mount, fetch building list from the API
  useEffect(() => {
    let isMounted = true;  // Cleanup safety flag

    // Call backend to get list of buildings (requires auth token)
    api.get('buildings/')
      .then((response) => {
        if (isMounted) {
          setBuildings(response.data);  // Store response in state
        }
      })
      .catch((err) => {
        console.error(err);
        if (isMounted) {
          setError('Failed to fetch buildings. Redirecting to login...');
          navigate('/login'); // Redirect to login if not authenticated
        }
      });

    // Cleanup function on unmount
    return () => { isMounted = false; };
  }, [navigate]);

  // Logout button clears auth token and redirects to login
  const handleLogout = () => {
    localStorage.removeItem('authToken');  // Remove token from localStorage
    navigate('/login');
  };

  // Form submission handler to create a new building
  const handleCreate = async (e) => {
    e.preventDefault(); // Prevent page reload on submit
    try {
      // Send POST request to backend with building name
      const response = await api.post('buildings/', { name });

      // Add newly created building to the local list
      setBuildings([...buildings, response.data]);

      // Clear input field
      setName('');
    } catch (err) {
      alert('Failed to create building');
      console.error(err);
    }
  };

  return (
    <div className="form-container">
      <h2>Building List</h2>

      {/* Error message, if any */}
      {error && <p style={{ color: 'red' }}>{error}</p>}

      {/* Logout button */}
      <button
        onClick={handleLogout}
        className="form-button"
        style={{ marginBottom: '20px' }}
      >
        Logout
      </button>

      {/* Form to add new building */}
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

      {/* Render list of buildings with links to their PLDs */}
      <ul className="form-list">
        {buildings.map((building) => (
          <li key={building.id} className="form-list-item">
            <strong>{building.name}</strong> — 
            <a
              href={`/plds?building_id=${building.id}`}
              style={{ marginLeft: '8px' }}
            >
              View PLDs
            </a>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default BuildingsList;