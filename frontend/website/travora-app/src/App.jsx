// src/App.jsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/common/Navbar';
import Home from './pages/Home';
// Import halaman lain jika sudah dibuat:
// import Profile from './pages/Profile';
// import Destination from './pages/Destination';

export default function App() {
  return (
    <Router>
      <div className="min-h-screen bg-[#FAFAFA] font-poppins text-gray-800">
        <Navbar />
        
        <div className="pt-[90px]"> {/* Memberi jarak karena Navbar fixed */}
          <Routes>
            <Route path="/" element={<Home />} />
            {/* <Route path="/profile" element={<Profile />} /> */}
            {/* <Route path="/destination/:id" element={<Destination />} /> */}
            
            {/* Halaman 404 sederhana */}
            <Route path="*" element={<div className="p-20 text-center">Halaman belum dibuat</div>} />
          </Routes>
        </div>

        {/* Footer bisa ditaruh disini */}
        <footer className="bg-white py-10 mt-20 text-center border-t">
            <p>© 2025 Travora</p>
        </footer>
      </div>
    </Router>
  );
}