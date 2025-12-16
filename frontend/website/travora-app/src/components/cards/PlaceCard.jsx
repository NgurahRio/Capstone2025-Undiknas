import React from 'react';
import { Star } from 'lucide-react';

export default function PlaceCard({ title, subtitle, rating = "4.9", tag = "Popular", img, onPress }) {
  // Fallback gambar jika database kosong/error
  const imageSrc = img || 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';

  return (
    <div onClick={onPress} className="min-w-[280px] h-[400px] rounded-[32px] relative overflow-hidden group cursor-pointer snap-start shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-2 flex-shrink-0">
      <img src={imageSrc} className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
      
      <div className="absolute top-6 left-6 bg-white px-4 py-2 rounded-2xl flex items-center gap-2 text-sm font-bold shadow-md z-10">
        <Star size={16} fill="orange" stroke="none" /> {rating}
      </div>
      
      <div className="absolute bottom-8 left-8 right-8 text-white z-10">
        <h3 className="font-bold text-2xl mb-2 leading-tight">{title}</h3>
        <p className="text-sm text-gray-300 mb-4 font-light leading-snug line-clamp-2">{subtitle}</p>
        <span className="bg-[#5E9BF5] text-white text-[10px] font-bold px-4 py-1.5 rounded-full uppercase tracking-wider shadow-sm shadow-blue-900/50">
          {tag}
        </span>
      </div>
    </div>
  );
}