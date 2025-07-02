// =========================
// File: src/api/axiosClient.js
// Description: Axios instance configured with base URL and auth token.
// =========================

import axios from 'axios';

// Create a reusable axios instance
const axiosClient = axios.create({
  baseURL: 'http://127.0.0.1:8000/api/', // Base Django API URL
});

// Add auth token if available (can improve later with interceptors)
axiosClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken'); // Get token from local storage
  if (token) {
    config.headers.Authorization = `Token ${token}`;
  }
  return config;
});

export default axiosClient;