// =========================
// File: src/index.js
// Description: Entry point of the React application.
// =========================

import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

// Mount the App component into root div
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);