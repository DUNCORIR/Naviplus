// =========================
// File: src/pages/Dashboard.jsx
// Description: Simple admin dashboard with separate layout for buttons.
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

      {/* Manage Buildings Button */}
      <div style={{ marginBottom: '20px' }}>
        <button className="form-button" onClick={() => navigate('/buildings')}>
          Manage Buildings
        </button>
      </div>

      {/* Logout Button */}
      <div>
        <button className="form-button" onClick={handleLogout}>
          Logout
        </button>
      </div>
    </div>
  );
}

export default Dashboard;