// =========================
// File: src/pages/PLDsList.jsx
// Description: Lists all PLDs with their building name using token-based access.
// =========================

import React, { useEffect, useState } from 'react';
import axios from '../utils/axiosConfig';
import { useNavigate } from 'react-router-dom';

function PLDsList() {
  const [plds, setPlds] = useState([]);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('authToken');
    if (!token) {
      navigate('/login');
      return;
    }

    axios.get('http://127.0.0.1:8000/api/plds/', {
      headers: { Authorization: `Token ${token}` }
    })
    .then((response) => {
      setPlds(response.data);
    })
    .catch((err) => {
      console.error(err);
      if (err.response?.status === 401) {
        navigate('/login');
      } else {
        setError('Failed to load PLDs.');
      }
    });
  }, [navigate]);

  return (
    <div>
      <h2>PLDs List</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      <ul>
        {plds.map((pld) => (
          <li key={pld.id}>
            <strong>{pld.label}</strong> — Building ID: {pld.building}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default PLDsList;