import React, { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import EventCard from '../cards/EventCard';

// Widget Kalender Kecil
const CalendarWidget = () => {
    const [date, setDate] = useState(27);
    const renderDays = () => {
      let days = [];
      for (let i = 1; i <= 30; i++) {
        const isSelected = i === date;
        days.push(
          <button key={i} onClick={() => setDate(i)} className={`w-10 h-10 flex items-center justify-center rounded-full text-sm transition-all duration-300 ${isSelected ? 'bg-[#82B1FF] text-white shadow-lg font-bold scale-110' : 'text-gray-700 hover:bg-gray-100'}`}>
            {i}
          </button>
        );
      }
      return days;
    };
  
    return (
      <div className="select-none">
        <div className="flex justify-between items-center mb-6 px-2">
          <ChevronLeft className="text-gray-400 cursor-pointer" />
          <h3 className="font-bold text-lg text-gray-900">May 2025</h3>
          <ChevronRight className="text-gray-400 cursor-pointer" />
        </div>
        <div className="grid grid-cols-7 text-center mb-4 text-xs font-bold text-gray-400 uppercase">
            {['S','M','T','W','T','F','S'].map(d => <span key={d}>{d}</span>)}
        </div>
        <div className="grid grid-cols-7 gap-y-2 justify-items-center">{renderDays()}</div>
      </div>
    );
};

export default function EventSection() {
    return (
        <div>
            <div className="flex items-center gap-4 mb-3">
                <div className="w-2 h-10 bg-black rounded-full"></div>
                <h2 className="text-4xl font-bold text-gray-900">Today's Event</h2>
            </div>
            <p className="text-lg text-gray-500 mb-12 pl-6">Events available today, on the 27th.</p>
            
            <div className="flex flex-col lg:flex-row gap-12">
                <div className="flex-1 grid grid-cols-1 md:grid-cols-2 gap-8 content-start">
                    <EventCard title="Legong Dance" loc="Ubud Palace" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" />
                    <EventCard title="Kecak Fire" loc="Pura Dalem" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" />
                </div>
                <div className="lg:w-[350px] bg-white rounded-[32px] shadow-xl border border-gray-100 p-8 h-fit">
                    <CalendarWidget />
                </div>
            </div>
        </div>
    );
}