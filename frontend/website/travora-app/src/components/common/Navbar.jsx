import React, { useEffect, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { MapPin, MessageCircle, User } from 'lucide-react';

export default function Navbar() {
  const location = useLocation();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  
  const isActive = (path) => location.pathname === path;

  // Cek Login setiap kali Navbar dimuat atau lokasi berubah
  useEffect(() => {
    const checkUser = () => {
        const storedUser = localStorage.getItem('travora_user');
        if (storedUser) {
            setUser(JSON.parse(storedUser));
        } else {
            setUser(null);
        }
    };
    
    checkUser();
    
    // Listener tambahan jika localStorage berubah (opsional, untuk safety)
    window.addEventListener('storage', checkUser);
    return () => window.removeEventListener('storage', checkUser);
  }, [location]); // Re-run saat pindah halaman

  const handleNav = (menu) => {
    if (menu === 'Event') {
        if (location.pathname === '/') {
            const eventSection = document.getElementById('events-section');
            if (eventSection) eventSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } else {
            navigate('/');
            setTimeout(() => {
                const eventSection = document.getElementById('events-section');
                if (eventSection) eventSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, 100);
        }
    } else if (menu === 'Home') {
        navigate('/');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        navigate(`/${menu.toLowerCase()}`);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  return (
    <nav className="fixed top-0 left-0 right-0 h-[90px] bg-white/95 backdrop-blur-md z-50 border-b border-gray-100 flex items-center justify-center">
      <div className="max-w-7xl w-full px-6 flex items-center justify-between">
        <Link to="/" className="flex items-center gap-2 cursor-pointer hover:opacity-80 transition" onClick={() => window.scrollTo(0,0)}>
          <MapPin className="text-[#5E9BF5]" size={28} fill="#5E9BF5" color="white" />
          <span className="text-2xl font-bold text-[#5E9BF5] tracking-tight">Travora</span>
        </Link>

        <div className="hidden lg:flex items-center gap-12">
          {['Home', 'Event', 'Bookmark', 'Profile'].map((item) => (
             <button 
                key={item} 
                onClick={() => handleNav(item)}
                className={`text-base capitalize transition-all duration-300 ${
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
            <a
              href="https://wa.me/6285166189866"
              target="_blank"
              rel="noopener noreferrer"
              className="bg-[#576D85] text-white px-5 py-2.5 rounded-xl flex items-center gap-2 hover:bg-[#4a5e73] transition shadow-md shadow-gray-200 text-sm font-semibold"
            >
                <MessageCircle size={18} /> Chat
            </a>
            
            {/* LOGIKA LOGIN / PROFILE */}
            {user ? (
                <button onClick={() => navigate('/profile')} className="flex items-center gap-2 bg-gray-100 text-gray-700 px-4 py-2.5 rounded-xl font-bold hover:bg-gray-200 transition">
                    <div className="w-6 h-6 bg-[#5E9BF5] rounded-full flex items-center justify-center text-white text-xs">
                        <User size={14} />
                    </div>
                    <span className="text-sm max-w-[100px] truncate">{user.username}</span>
                </button>
            ) : (
                <button onClick={() => navigate('/auth')} className="bg-[#82B1FF] text-white px-6 py-2.5 rounded-xl font-bold hover:bg-[#6fa5ff] transition shadow-md text-sm">
                    Log In
                </button>
            )}
        </div>
      </div>
    </nav>
  );
}
