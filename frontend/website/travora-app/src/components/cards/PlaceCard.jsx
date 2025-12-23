import React from 'react';
import { Star } from 'lucide-react';

export default function PlaceCard({ title, subtitle, rating, img, tag, description, onPress, className }) {
  const imageSrc = img && img !== "" ? img : 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';
  const displayRating = rating ? String(rating) : "4.8";
  const descText = description || subtitle || "Protected forest with free-roaming monkeys.";

  return (
    <div
      onClick={onPress}
      className={`w-full bg-white rounded-[18px] shadow-md hover:shadow-lg overflow-hidden cursor-pointer transition-transform duration-300 hover:-translate-y-1 ${className || ''}`}
    >
      <div className="h-[170px] w-full overflow-hidden">
        <img src={imageSrc} alt={title} className="w-full h-full object-cover" />
      </div>

      <div className="p-4 flex flex-col gap-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 text-sm font-semibold text-gray-700">
            <Star size={16} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
            <span>{displayRating}</span>
          </div>
          {tag && (
            <span className="text-[11px] font-semibold text-[#2f5aa5] bg-[#E9F2FF] px-3 py-1 rounded-full">
              {tag}
            </span>
          )}
        </div>

        <div>
          <h3 className="text-lg font-bold text-gray-900 leading-tight mb-1">{title || "Unknown Destination"}</h3>
          <p className="text-sm text-gray-500 leading-snug line-clamp-2">{descText}</p>
        </div>

        <div className="mt-3">
          <div className="flex justify-end">
            <button
              className="text-[11px] font-bold text-white bg-[#7FB4FF] px-5 py-2 rounded-md shadow-sm hover:bg-[#6aa7ff] transition"
              onClick={(e) => {
                e.stopPropagation();
                onPress?.();
              }}
            >
              LEARN MORE
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
