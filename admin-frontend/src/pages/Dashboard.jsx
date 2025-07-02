// =========================
// File: src/pages/Dashboard.jsx
// Description: Simple admin dashboard with links to building management.
// =========================

import React from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/Form.css';

function Dashboard() {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem('token');
    navigate('/login');
  };

  return (
    <div className="form-container">
      <h2>Welcome to Naviplus Admin Dashboard</h2>

      <div className="dashboard-links">
        <button
          className="form-button"
          style={{ marginRight: '10px' }}
          onClick={() => navigate('/buildings')}
        >
          Manage Buildings
        </button>
        <button className="form-button" onClick={handleLogout}>
          Logout
        </button>
      </div>
    </div>
  );
}

export default Dashboard;