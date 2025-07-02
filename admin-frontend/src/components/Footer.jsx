// ==============================
// File: src/components/Footer.jsx
// Description: Global footer displayed across all pages
// ==============================

import React from 'react';
import '../styles/Footer.css'; // Import the footer styles

function Footer() {
  return (
    <footer className="footer-container">
      {/* Left section: Copyright */}
      <div className="footer-left">
        &copy; {new Date().getFullYear()} Naviplus. All rights reserved.
      </div>

      {/* Right section: Navigation or Contact */}
      <div className="footer-right">
        <a href="/about">About</a>
        <a href="/support">Support</a>
        <a href="/contact">Contact</a>
      </div>
    </footer>
  );
}

export default Footer;
