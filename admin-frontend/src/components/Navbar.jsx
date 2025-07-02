// =========================
// File: src/components/Navbar.jsx
// Description: Top navigation bar for switching between views.
// =========================

import React from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  return (
    <nav style={{ padding: '10px', borderBottom: '1px solid #ccc' }}>
      {/* Navigation links */}
      <Link to="/dashboard" style={{ marginRight: '10px' }}>Dashboard</Link>
      <Link to="/buildings" style={{ marginRight: '10px' }}>Buildings</Link>
      <Link to="/plds" style={{ marginRight: '10px' }}>PLDs</Link>
      <Link to="/login" style={{ marginRight: '10px' }}>Login</Link>
      <Link to="/signup" style={{ marginRight: '10px' }}>Sign Up</Link>
      <Link to="/add-building" style={{ marginRight: '10px' }}>Add Building</Link>

    </nav>
  );
}

export default Navbar;
