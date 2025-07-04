// =========================
// File: src/utils/axiosClient.js
// Description: Configure axios with auth token from localStorage
// =========================

import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api/',
});

// Set token if available
const token = localStorage.getItem('token');
if (token) {
  api.defaults.headers.common['Authorization'] = `Token ${token}`;
}

export default api;