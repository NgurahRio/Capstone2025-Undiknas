import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { MapPin, MessageCircle } from 'lucide-react';

export default function Navbar() {
  const location = useLocation();
  const navigate = useNavigate();
  
  const isActive = (path) => location.pathname === path;

  // FUNGSI NAVIGASI PINTAR
  const handleNav = (menu) => {
    if (menu === 'Event') {
        // Jika kita sudah di Home ('/'), langsung scroll
        if (location.pathname === '/') {
            const eventSection = document.getElementById('events-section');
            if (eventSection) eventSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } else {
            // Jika kita di halaman lain (misal Profile), pindah ke Home dulu, baru scroll
            navigate('/');
            setTimeout(() => {
                const eventSection = document.getElementById('events-section');
                if (eventSection) eventSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, 100); // Delay sedikit agar halaman Home render dulu
        }
    } else if (menu === 'Home') {
        navigate('/');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        // Untuk Bookmark & Profile
        navigate(`/${menu.toLowerCase()}`);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  return (
    <nav className="fixed top-0 left-0 right-0 h-[90px] bg-white/95 backdrop-blur-md z-50 border-b border-gray-100 flex items-center justify-center">
      <div className="max-w-7xl w-full px-6 flex items-center justify-between">
        <div onClick={() => handleNav('Home')} className="flex items-center gap-2 cursor-pointer hover:opacity-80 transition">
          <MapPin className="text-[#5E9BF5]" size={28} fill="#5E9BF5" color="white" />
          <span className="text-2xl font-bold text-[#5E9BF5] tracking-tight">Travora</span>
        </div>

        <div className="hidden lg:flex items-center gap-12">
          {['Home', 'Event', 'Bookmark', 'Profile'].map((item) => (
             <button 
                key={item} 
                onClick={() => handleNav(item)}
                className={`text-base capitalize transition-all duration-300 ${
                    // Highlight aktif logic: Event tidak pernah "aktif" karena dia cuma scroll
                    (item !== 'Event' && isActive(item === 'Home' ? '/' : `/${item.toLowerCase()}`)) 
                    ? 'font-bold text-black border-b-2 border-black pb-1' 
                    : 'font-medium text-gray-400 hover:text-[#5E9BF5]'
                }`}
             >
                {item}
             </button>
          ))}
        </div>

        <div className="flex items-center gap-4">
            <button className="bg-[#576D85] text-white px-5 py-2.5 rounded-xl flex items-center gap-2 hover:bg-[#4a5e73] transition shadow-md shadow-gray-200 text-sm font-semibold">
                <MessageCircle size={18} /> Chat
            </button>
            
            <button onClick={() => navigate('/auth')} className="bg-[#82B1FF] text-white px-6 py-2.5 rounded-xl font-bold hover:bg-[#6fa5ff] transition shadow-md text-sm">
                Log In
            </button>
        </div>
      </div>
    </nav>
  );
}