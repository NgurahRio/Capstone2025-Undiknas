import React from 'react';
import { MapPin, ArrowRight } from 'lucide-react';

export default function Footer() {
  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <footer className="bg-white py-16 px-6 lg:px-20 border-t border-gray-100 mt-20">
      <div className="max-w-7xl mx-auto flex flex-col">
        <div className="flex justify-between items-center w-full mb-10 relative">
          <div className="absolute left-1/2 -translate-x-1/2 flex items-center gap-3 cursor-pointer group" onClick={scrollToTop}>
            <MapPin size={40} className="text-[#5E9BF5] group-hover:scale-110 transition" fill="#5E9BF5" color="white" />
            <span className="text-4xl font-bold text-[#5E9BF5]">Travora</span>
          </div>
          <div></div>
          <button onClick={scrollToTop} className="w-16 h-16 bg-[#82B1FF] rounded-full flex items-center justify-center text-white hover:bg-[#6fa5ff] transition shadow-xl hover:-translate-y-2">
            <ArrowRight size={32} className="-rotate-90" />
          </button>
        </div>
        <div className="w-full h-[1px] bg-gray-100 mb-8"></div>
        <div className="flex justify-between items-center text-sm text-gray-400">
          <div className="flex gap-6">
            <span>Terms</span>
            <span>Privacy</span>
            <span>Cookies</span>
          </div>
          <p>Copyright © 2025 • Travora.</p>
        </div>
      </div>
    </footer>
  );
}