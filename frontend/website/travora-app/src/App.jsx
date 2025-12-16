import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

// IMPORT SEMUA HALAMAN
import Navbar from './components/common/Navbar';
import Footer from './components/common/Footer';
import Home from './pages/Home';
import Destination from './pages/Destination';
import Profile from './pages/Profile';
import Auth from './pages/Auth';
import Bookmark from './pages/Bookmark'; // <--- PASTIKAN INI ADA!

export default function App() {
  return (
    <Router>
      <div className="min-h-screen bg-[#FAFAFA] font-poppins text-gray-800">
        
        <Routes>
            {/* 1. Halaman Auth (Tanpa Navbar/Footer) */}
            <Route path="/auth" element={<Auth />} /> 
            
            {/* 2. Halaman Utama (Pakai Navbar & Footer) */}
            <Route path="*" element={
                <>
                    <Navbar />
                    {/* Padding top 90px agar tidak ketutup Navbar */}
                    <div className="pt-[90px] min-h-screen"> 
                        <Routes>
                            <Route path="/" element={<Home />} />
                            
                            {/* --- INI YANG HILANG SEBELUMNYA --- */}
                            <Route path="/bookmark" element={<Bookmark />} />
                            {/* ---------------------------------- */}

                            <Route path="/destination/:id" element={<Destination />} />
                            <Route path="/profile" element={<Profile />} />
                            
                            {/* Halaman 404 jika rute ngawur */}
                            <Route path="*" element={
                                <div className="text-center pt-20 font-bold text-gray-400">
                                    404 - Halaman Tidak Ditemukan
                                </div>
                            } />
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