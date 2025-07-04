// ==========================
// File: src/components/PrivateRoute.jsx
// Description: Protects routes from unauthenticated access
// ==========================

import React from 'react';
import { Navigate } from 'react-router-dom';

const PrivateRoute = ({ children }) => {
  const token = localStorage.getItem('authToken');
  return token ? children : <Navigate to="/login" replace />;
};

export default PrivateRoute;