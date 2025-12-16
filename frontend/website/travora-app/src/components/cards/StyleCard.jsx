import React from 'react';

export default function StyleCard({ title, desc, img, onPress }) {
  return (
    <div onClick={onPress} className="bg-white rounded-[32px] shadow-lg overflow-hidden border border-gray-100 cursor-pointer hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 group h-full flex flex-col">
      <div className="h-56 overflow-hidden">
        <img src={img} className="h-full w-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
      </div>
      <div className="p-8 flex flex-col flex-1">
        <h4 className="font-bold text-xl text-gray-900 mb-2">{title}</h4>
        <p className="text-sm text-gray-500 mb-8 font-light line-clamp-2 flex-1">{desc}</p>
        <div className="flex justify-end">
          <span className="text-[11px] bg-[#82B1FF] text-white px-4 py-2 rounded-lg font-bold uppercase tracking-widest group-hover:bg-[#5E9BF5] transition shadow-md shadow-blue-100">
            LEARN MORE
          </span>
        </div>
      </div>
    </div>
  );
}