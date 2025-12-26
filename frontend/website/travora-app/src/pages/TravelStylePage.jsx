import React from 'react';

import TravelStyle from '../components/sections/TravelStyleSection';

export default function TravelStylePage() {
  return (
    <div className="w-full pb-20">
      <div className="w-full h-[300px] relative flex items-center justify-center bg-gray-900 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-black/60 to-transparent z-10"></div>
        <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1528892952291-009c663ce843?auto=format&fit=crop&w=1600&q=80')] bg-cover bg-center opacity-70"></div>
        <div className="relative z-20 text-center">
          <h1 className="text-5xl font-bold text-white">Travel Style</h1>
          <p className="text-white/80 mt-2">Pick your travel style and explore more destinations</p>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 lg:px-10 py-10">
        <div className="mb-6 text-sm text-gray-500 flex items-center gap-2">
          <span className="text-[#5E9BF5] font-semibold">Home</span>
          <span className="text-gray-300">›</span>
          <span className="text-gray-700 font-semibold">Travel Style</span>
        </div>
        <TravelStyle initialShowAll hideViewMore />
      </div>
    </div>
  );
}
