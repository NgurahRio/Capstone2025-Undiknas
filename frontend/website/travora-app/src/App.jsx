import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/common/Navbar';
import Footer from './components/common/Footer';
import Home from './pages/Home';
import Destination from './pages/Destination'; // Import Halaman Detail
import Profile from './pages/Profile'; // Import Halaman Profile (Akan dibuat di langkah 4)

export default function App() {
  return (
    <Router>
      <div className="min-h-screen bg-[#FAFAFA] font-poppins text-gray-800">
        <Navbar />
        
        <div className="pt-[90px]">
          <Routes>
            <Route path="/" element={<Home />} />
            
            {/* Route Dinamis untuk Detail */}
            <Route path="/destination/:id" element={<Destination />} />
            
            <Route path="/profile" element={<Profile />} />
            <Route path="*" element={<div className="p-20 text-center">Page Not Found</div>} />
          </Routes>
        </div>

        <Footer />
      </div>
    </Router>
  );
}