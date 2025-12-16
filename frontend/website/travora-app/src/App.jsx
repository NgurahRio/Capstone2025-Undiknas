import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/common/Navbar';
import Footer from './components/common/Footer';
import Home from './pages/Home';
import Destination from './pages/Destination';
import Profile from './pages/Profile';
import Auth from './pages/Auth'; // IMPORT HALAMAN AUTH BARU

export default function App() {
  return (
    <Router>
      <div className="min-h-screen bg-[#FAFAFA] font-poppins text-gray-800">
        
        {/* Navbar akan muncul di semua halaman KECUALI di halaman Auth agar lebih fokus */}
        {/* Tapi di kode Auth.jsx tadi saya sudah masukkan Navbar manual, jadi aman */}
        
        <Routes>
            <Route path="/auth" element={<Auth />} /> {/* Halaman Login/Regis */}
            
            {/* Halaman-halaman utama dengan Layout lengkap */}
            <Route path="*" element={
                <>
                    <Navbar />
                    <div className="pt-[90px]">
                        <Routes>
                            <Route path="/" element={<Home />} />
                            <Route path="/destination/:id" element={<Destination />} />
                            <Route path="/profile" element={<Profile />} />
                        </Routes>
                    </div>
                    <Footer />
                </>
            } />
        </Routes>

      </div>
    </Router>
  );
}