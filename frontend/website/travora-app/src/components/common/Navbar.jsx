import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { MapPin, MessageCircle } from 'lucide-react';

export default function Navbar() {
  const location = useLocation();
  const navigate = useNavigate();
  
  const isActive = (path) => location.pathname === path;

  // Handler sederhana untuk scroll ke atas saat pindah halaman
  const handleNav = (path) => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <nav className="fixed top-0 left-0 right-0 h-[90px] bg-white/95 backdrop-blur-md z-50 border-b border-gray-100 flex items-center justify-center">
      <div className="max-w-7xl w-full px-6 flex items-center justify-between">
        <Link to="/" onClick={() => handleNav('/')} className="flex items-center gap-2 cursor-pointer hover:opacity-80 transition">
          <MapPin className="text-[#5E9BF5]" size={28} fill="#5E9BF5" color="white" />
          <span className="text-2xl font-bold text-[#5E9BF5] tracking-tight">Travora</span>
        </Link>

        <div className="hidden lg:flex items-center gap-12">
          {['Home', 'Event', 'Bookmark', 'Profile'].map((item) => {
             const path = item === 'Home' ? '/' : `/${item.toLowerCase()}`;
             return (
                <Link 
                  key={item} 
                  to={path}
                  onClick={() => handleNav(path)}
                  className={`text-base capitalize transition-all duration-300 ${isActive(path) ? 'font-bold text-black border-b-2 border-black pb-1' : 'font-medium text-gray-400 hover:text-[#5E9BF5]'}`}
                >
                  {item}
                </Link>
             )
          })}
        </div>

        <div className="flex items-center gap-4">
            <button className="bg-[#576D85] text-white px-5 py-2.5 rounded-xl flex items-center gap-2 hover:bg-[#4a5e73] transition shadow-md shadow-gray-200 text-sm font-semibold">
                <MessageCircle size={18} /> Chat
            </button>
            
            <button onClick={() => navigate('/profile')} className="bg-[#82B1FF] text-white px-6 py-2.5 rounded-xl font-bold hover:bg-[#6fa5ff] transition shadow-md text-sm">
                Log In
            </button>
        </div>
      </div>
    </nav>
  );
}