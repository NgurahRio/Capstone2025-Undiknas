import React, { useEffect, useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { MapPin, MessageCircle } from 'lucide-react';
import api from '../../api';

export default function Navbar() {
  const location = useLocation();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  
  const isActive = (path) => location.pathname === path;

  // Cek Login setiap kali Navbar dimuat atau lokasi berubah
  useEffect(() => {
    const checkUser = () => {
        const storedUser = localStorage.getItem('travora_user');
        const token = localStorage.getItem('travora_token');

        if (storedUser && token) {
            setUser(JSON.parse(storedUser));
        } else {
            localStorage.removeItem('travora_user');
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
        navigate('/events');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else if (menu === 'Home') {
        navigate('/');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
        navigate(`/${menu.toLowerCase()}`);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  const getAvatarUrl = () => {
    const img =
      user?.image ||
      user?.image_user ||
      user?.imageUser ||
      user?.image_profile ||
      user?.profile_image ||
      user?.profileImage ||
      user?.avatar ||
      user?.photo ||
      user?.picture;

    if (!img) {
      const name = user?.username || 'Traveler';
      return `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=5E9BF5&color=fff`;
    }

    if (typeof img === 'string') {
      if (img.startsWith('http') || img.startsWith('data:')) return img;
      // Jika string mengandung base64 atau cukup panjang, anggap base64
      const maybeBase64 = img.includes('base64') || img.length > 100;
      if (maybeBase64) return `data:image/jpeg;base64,${img}`;
      // Jika backend mengembalikan path relatif, gabungkan dengan baseURL
      const base = api.defaults.baseURL?.replace(/\/$/, '') || '';
      const path = img.startsWith('/') ? img : `/${img}`;
      return `${base}${path}`;
    }

    return img;
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
                    ((item === 'Event' && location.pathname.startsWith('/events')) ||
                    (item !== 'Event' && isActive(item === 'Home' ? '/' : `/${item.toLowerCase()}`))) 
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
                <button
                  onClick={() => navigate('/profile')}
                  className="flex items-center gap-1.5 text-gray-800 font-semibold hover:text-[#5E9BF5] transition"
                >
                    <img
                      src={getAvatarUrl()}
                      alt={user.username || 'Profile'}
                      className="w-8 h-8 rounded-full object-cover border border-gray-700"
                    />
                    <span className="text-sm max-w-[140px] truncate">{user.username}</span>
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
