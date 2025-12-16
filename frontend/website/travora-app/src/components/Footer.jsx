import React from 'react';

// Ikon SVG Pengganti lucide-react
const MapPin = ({ size = 24, className = "", color = "currentColor", fill = "none" }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill={fill} stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z" />
    <circle cx="12" cy="10" r="3" />
  </svg>
);

const ArrowRight = ({ size = 24, className = "", color = "currentColor" }) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="M5 12h14" />
    <path d="m12 5 7 7-7 7" />
  </svg>
);

export default function Footer({ onScrollTop }) {
  return (
    <footer className="bg-white py-16 px-6 border-t border-gray-200 mt-20">
      <div className="max-w-7xl mx-auto flex flex-col">
        <div className="flex justify-between items-center w-full mb-10 relative">
          <div className="absolute left-1/2 -translate-x-1/2 flex items-center gap-3 cursor-pointer group" onClick={onScrollTop}>
            <MapPin size={40} className="text-[#5E9BF5] group-hover:scale-110 transition" fill="#5E9BF5" color="white" />
            <span className="text-4xl font-bold text-[#5E9BF5]">Travora</span>
          </div>
          <div></div>
          <button onClick={onScrollTop} className="w-16 h-16 bg-[#82B1FF] rounded-full flex items-center justify-center text-white hover:bg-[#6fa5ff] transition shadow-xl hover:-translate-y-2">
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