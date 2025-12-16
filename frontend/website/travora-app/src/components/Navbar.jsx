import React from 'react';
import { MapPin, MessageCircle } from 'lucide-react';

export default function Navbar({ activeTab, handleTabPress, isLoggedIn, toggleLogin }) {
  return (
    <nav className="fixed top-0 left-0 right-0 h-[90px] bg-white/90 backdrop-blur-md z-50 border-b border-gray-100 flex items-center justify-center transition-all duration-300">
      <div className="max-w-7xl w-full px-6 flex items-center justify-between">
        
        {/* Logo */}
        <div className="flex items-center gap-2 cursor-pointer hover:opacity-80 transition" onClick={() => handleTabPress('home')}>
          <MapPin className="text-[#5E9BF5]" size={28} fill="#5E9BF5" color="white" />
          <span className="text-2xl font-bold text-[#5E9BF5] tracking-tight">Travora</span>
        </div>

        {/* Menu Tengah */}
        <div className="hidden lg:flex items-center gap-12">
          {['home', 'event', 'bookmark', 'profile'].map((tab) => (
            <button 
              key={tab}
              onClick={() => handleTabPress(tab)}
              className={`text-base capitalize transition-all duration-300 px-2 py-1 ${activeTab === tab ? 'font-bold text-black border-b-2 border-black' : 'font-medium text-gray-400 hover:text-[#5E9BF5]'}`}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Tombol Kanan */}
        <div className="flex items-center gap-4">
          <button className="bg-[#576D85] text-white px-5 py-2.5 rounded-xl flex items-center gap-2 hover:bg-[#4a5e73] transition shadow-md shadow-gray-200">
            <MessageCircle size={18} /> <span className="text-sm font-semibold">Chat</span>
          </button>
          
          {/* Logic: Tombol Login muncul jika belum login, atau tombol Logout muncul di dalam ProfilePage */}
          {!isLoggedIn && (
            <button 
              onClick={toggleLogin}
              className="bg-[#82B1FF] text-white px-6 py-2.5 rounded-xl font-bold hover:bg-[#6fa5ff] transition shadow-md shadow-blue-100 text-sm"
            >
              Log In
            </button>
          )}
        </div>
      </div>
    </nav>
  );
}