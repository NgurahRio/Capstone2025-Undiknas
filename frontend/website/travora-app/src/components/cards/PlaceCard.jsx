import React from 'react';
import { Star, MapPin } from 'lucide-react';

export default function PlaceCard({ title, subtitle, rating, img, onPress, className }) {
  // Fallback Image
  const imageSrc = img && img !== "" ? img : 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';
  const displayRating = rating ? String(rating) : "4.8";

  return (
    <div 
      onClick={onPress} 
      // Class default h-[360px] agar seragam, tapi bisa ditimpa lewat props className
      className={`relative h-[360px] rounded-[32px] overflow-hidden cursor-pointer group shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-2 ${className || ''}`}
    >
      {/* 1. GAMBAR FULL BACKGROUND */}
      <img 
        src={imageSrc} 
        className="w-full h-full object-cover group-hover:scale-110 transition duration-700 ease-in-out" 
        alt={title} 
      />

      {/* 2. GRADIENT OVERLAY (Hitam Pudar di Bawah) */}
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-90"></div>
      
      {/* 3. RATING BADGE (Pojok Kanan Atas - Glass Effect) */}
      <div className="absolute top-4 right-4 bg-white/20 backdrop-blur-md border border-white/20 px-3 py-1 rounded-full flex items-center gap-1 shadow-sm">
        <Star size={12} fill="#FFD700" stroke="none" /> 
        <span className="text-white font-bold text-xs">{displayRating}</span>
      </div>

      {/* 4. TEXT CONTENT (Di Bawah) */}
      <div className="absolute bottom-6 left-6 right-6 text-white z-10">
        <h3 className="text-xl font-bold mb-2 leading-tight line-clamp-2 group-hover:text-[#82B1FF] transition-colors">
            {title || "Unknown Destination"}
        </h3>
        
        <div className="flex items-center gap-2 text-gray-300 text-xs font-medium">
            <MapPin size={16} className="text-[#5E9BF5]" />
            <span className="truncate">{subtitle || "Bali, Indonesia"}</span>
        </div>
      </div>
    </div>
  );
}