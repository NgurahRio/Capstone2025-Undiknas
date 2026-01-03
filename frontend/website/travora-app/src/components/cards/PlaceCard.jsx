import React from 'react';
import { Star, MapPin, CalendarDays, Clock3 } from 'lucide-react';

export default function PlaceCard({
  title,
  subtitle,
  rating,
  img,
  tag,
  description,
  onPress,
  className,
  actionLabel,
  metaLocation,
  metaDate,
  metaTime,
  priceLabel,
}) {
  const imageSrc = img && img !== '' ? img : 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';
  const displayRating = rating ? String(rating) : 'New';
  const descText = description || subtitle || '';
  const ctaText = actionLabel || 'LEARN MORE';
  const isNew = displayRating.toLowerCase() === 'new';
  const showMeta = metaLocation || metaDate || metaTime;

  return (
    <div
      onClick={onPress}
      className={`w-full bg-white rounded-[10px] shadow-md border border-gray-100 hover:shadow-xl overflow-hidden cursor-pointer transition-transform duration-300 hover:-translate-y-1 ${className || ''}`}
    >
      <div className="h-[170px] w-full overflow-hidden p-1">
        <img src={imageSrc} alt={title} className="w-full h-full object-cover rounded-[10px]" />
      </div>

      <div className="flex flex-col">
        <div className="p-4 flex flex-col gap-3">
          <div className="flex flex-row relative justify-between">
            <div className="top-3 right-3 bg-white/95 text-gray-800 text-xs font-semibold rounded-full px-3 py-1 shadow-sm flex items-center gap-1">
              <Star size={14} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
              <span>{isNew ? 'New' : displayRating}</span>
            </div>
            {tag && (
              <span className="
                top-3 left-3
                text-[11px] font-semibold text-black
                bg-gradient-to-r from-[#4084C4] to-transparent
                px-3 py-1
                rounded-full
                shadow-sm
              ">
                {tag}
              </span>
            )}
          </div>
          <h3 className="text-[17px] font-bold text-gray-900 leading-snug line-clamp-2 min-h-[42px]">{title || 'Unknown Destination'}</h3>
          {showMeta ? (
            <div className="text-[13px] text-gray-700 space-y-1.5 leading-snug">
              {metaLocation && (
                <div className="flex items-start gap-1.5">
                  <MapPin size={13} className="text-[#82B1FF] flex-shrink-0 mt-[2px]" />
                  <span className="line-clamp-1">{metaLocation}</span>
                </div>
              )}
              {metaDate && (
                <div className="flex items-start gap-1.5 font-semibold text-gray-900">
                  <CalendarDays size={13} className="text-[#82B1FF] flex-shrink-0 mt-[2px]" />
                  <span className="line-clamp-1">{metaDate}</span>
                </div>
              )}
              {metaTime && (
                <div className="flex items-start gap-1.5">
                  <Clock3 size={13} className="text-[#82B1FF] flex-shrink-0 mt-[2px]" />
                  <span className="line-clamp-1">{metaTime}</span>
                </div>
              )}
            </div>
          ) : (
            <p className="text-[14px] text-gray-500 leading-snug line-clamp-2 min-h-[40px]">{descText}</p>
          )}
        </div>

        <div className="mt-2 flex justify-end">
          {priceLabel ? (
            <span className="text-[11px] font-bold text-white bg-[#82B1FF] px-4 py-2 rounded-md shadow-sm">
              {priceLabel}
            </span>
          ) : (
            <button
              className="text-[11px] font-bold text-white bg-[#82B1FF] px-5 py-3 rounded-tl-[10px] shadow-sm hover:bg-[#6aa5ff] transition"
              onClick={(e) => {
                e.stopPropagation();
                onPress?.();
              }}
            >
              {ctaText}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
