import React from 'react';
import { MapPin } from 'lucide-react';

export default function EventCard({ title, loc, img, onPress }) {
  return (
    <div onClick={onPress} className="bg-white border border-gray-100 rounded-[32px] overflow-hidden shadow-md cursor-pointer hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col group h-full">
      <div className="h-48 overflow-hidden relative">
        <img src={img} className="h-full w-full object-cover group-hover:scale-105 transition duration-500" alt={title} />
        <div className="absolute inset-0 bg-black/10 group-hover:bg-transparent transition"></div>
      </div>
      <div className="p-8 flex flex-col flex-1">
        <h4 className="font-bold text-2xl text-gray-900 mb-2">{title}</h4>
        <div className="flex items-center gap-2 text-sm text-[#5E9BF5] mb-4 font-semibold">
          <MapPin size={16} /> {loc}
        </div>
        <p className="text-sm text-gray-400 italic mb-6 flex-1">Experience the beauty of traditional performance.</p>
        <div className="flex justify-end mt-auto">
          <span className="bg-[#82B1FF] text-white text-[10px] font-bold px-4 py-2 rounded-xl uppercase tracking-widest shadow-md">FREE ACCESS</span>
        </div>
      </div>
    </div>
  );
}