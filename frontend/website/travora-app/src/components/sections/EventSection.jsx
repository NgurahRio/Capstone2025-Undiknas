import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Calendar from 'react-calendar';
import { MapPin, ArrowRight, Clock, RefreshCw } from 'lucide-react';
import { api } from '../../api';

import 'react-calendar/dist/Calendar.css';

// --- CSS KALENDER ---
const calendarStyles = `
  .react-calendar { width: 100%; border: none; font-family: 'Inter', sans-serif; background: #ffffff; border-radius: 24px; padding: 12px; font-size: 12px; }
  .react-calendar__navigation button { font-size: 14px; font-weight: 700; color: #1F2937; }
  .react-calendar__tile { padding: 8px 4px; font-weight: 600; font-size: 12px; }
  .react-calendar__tile--active { background: #5E9BF5 !important; color: white !important; border-radius: 8px; }
  .react-calendar__tile--now { background: #EFF6FF; color: #5E9BF5; border-radius: 8px; }
  .event-dot { height: 4px; width: 4px; background-color: #5E9BF5; border-radius: 50%; margin: 2px auto 0; }
`;

// --- COMPONENT CARD EVENT COMPACT (VERSI KECIL) ---
const EventCardList = ({ item, onPress }) => {
  const processImage = (img) => {
    const fallback = "https://images.unsplash.com/photo-1492684223066-81342ee5ff30";
    if (!img) return fallback;
    try { if (typeof img === 'string' && img.trim().startsWith('[')) { const p = JSON.parse(img); if (p.length > 0) img = p[0]; } } catch(e) {}
    if (img && !img.startsWith('http') && !img.startsWith('data:')) return `data:image/jpeg;base64,${img}`;
    return img || fallback;
  };

  const getDateParts = (dateStr) => {
    if (!dateStr) return { day: '??', month: 'TBA' };
    const d = new Date(dateStr);
    return {
        day: d.getDate(),
        month: d.toLocaleDateString('en-GB', { month: 'short' }).toUpperCase()
    };
  };

  const { day, month } = getDateParts(item.start_date);

  return (
    <div 
      onClick={onPress}
      className="group cursor-pointer bg-white rounded-[20px] border border-gray-100 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden hover:-translate-y-1 h-full"
    >
        {/* --- BAGIAN ATAS: GAMBAR (LEBIH PENDEK 140px) --- */}
        <div className="h-[140px] w-full relative overflow-hidden">
            <img 
                src={processImage(item.image_event)} 
                alt={item.nameevent} 
                className="w-full h-full object-cover group-hover:scale-110 transition duration-700"
            />
            
            {/* Overlay */}
            <div className="absolute inset-x-0 bottom-0 h-1/2 bg-gradient-to-t from-black/50 to-transparent opacity-60"></div>

            {/* BADGE TANGGAL KECIL */}
            <div className="absolute top-2 left-2 bg-white/95 backdrop-blur-md rounded-[12px] w-[40px] h-[45px] flex flex-col items-center justify-center shadow-md">
                <span className="text-[9px] font-bold text-gray-400 tracking-wider uppercase leading-none mb-0.5">{month}</span>
                <span className="text-lg font-black text-[#5E9BF5] leading-none">{day}</span>
            </div>

            {/* BADGE HARGA KECIL */}
            <div className="absolute top-2 right-2 bg-black/40 backdrop-blur-md px-2 py-1 rounded-lg border border-white/10">
                <span className="text-[10px] font-bold text-white tracking-wide">
                    {item.price && parseFloat(item.price) > 0 
                        ? `IDR ${parseInt(item.price / 1000)}K` 
                        : "FREE"
                    }
                </span>
            </div>
        </div>

        {/* --- BAGIAN BAWAH: DESKRIPSI COMPACT --- */}
        <div className="p-3 flex flex-col gap-2 flex-1">
            
            {/* Judul & Lokasi */}
            <div>
                <h3 className="text-base font-bold text-gray-900 mb-1 leading-tight group-hover:text-[#5E9BF5] transition line-clamp-2">
                    {item.nameevent || "Event"}
                </h3>
                
                <div className="flex items-center gap-1.5 text-gray-500 text-[11px] font-medium">
                    <MapPin size={12} className="text-[#5E9BF5] flex-shrink-0" />
                    <span className="truncate">{item.location || "Bali"}</span>
                </div>
            </div>

            {/* Garis */}
            <div className="w-full h-[1px] bg-gray-100 my-1"></div>

            {/* Waktu & Tombol */}
            <div className="flex items-center justify-between mt-auto">
                {item.start_time ? (
                    <div className="flex items-center gap-1.5 text-gray-400 text-[10px] font-bold bg-gray-50 px-2 py-1 rounded-full">
                        <Clock size={10} />
                        <span>{item.start_time.slice(0, 5)}</span>
                    </div>
                ) : <div></div>}

                <div className="w-7 h-7 rounded-full bg-[#5E9BF5] flex items-center justify-center text-white shadow-md group-hover:scale-110 transition-transform duration-300">
                    <ArrowRight size={14} className="-rotate-45 group-hover:rotate-0 transition-transform duration-300" />
                </div>
            </div>
        </div>
    </div>
  );
};

export default function EventSection() {
  const navigate = useNavigate();
  const [allEvents, setAllEvents] = useState([]);
  const [filteredEvents, setFilteredEvents] = useState([]);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [loading, setLoading] = useState(true);

  // --- LOGIC HELPER ---
  const toDBFormat = (dateObj) => {
      const year = dateObj.getFullYear();
      const month = String(dateObj.getMonth() + 1).padStart(2, '0');
      const day = String(dateObj.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
  };

  const normalizeDate = (dbString) => String(dbString || "").trim().substring(0, 10);

  const isDateInRange = (targetDateStr, startDateStr, endDateStr) => {
      const target = targetDateStr; 
      const start = normalizeDate(startDateStr);
      const end = endDateStr ? normalizeDate(endDateStr) : start;
      return target >= start && target <= end;
  };

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const res = await api.get('/events');
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        
        const sorted = data.sort((a,b) => (a.start_date || "").localeCompare(b.start_date || ""));
        setAllEvents(sorted);
        
        const todayStr = toDBFormat(new Date());
        const todayEvents = sorted.filter(ev => isDateInRange(todayStr, ev.start_date, ev.end_date));

        if (todayEvents.length > 0) {
            setFilteredEvents(todayEvents);
        } else {
            const upcoming = sorted.filter(ev => normalizeDate(ev.start_date) >= todayStr);
            setFilteredEvents(upcoming.slice(0, 3));
        }
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchEvents();
  }, []);

  const handleDateChange = (date) => {
    setSelectedDate(date);
    const selectedStr = toDBFormat(date);
    const matches = allEvents.filter(ev => isDateInRange(selectedStr, ev.start_date, ev.end_date));
    setFilteredEvents(matches);
  };

  const handleReset = () => {
    const today = new Date();
    setSelectedDate(today);
    const todayStr = toDBFormat(today);
    let upcoming = allEvents.filter(ev => normalizeDate(ev.start_date) >= todayStr);
    if (upcoming.length === 0) upcoming = allEvents.slice(-3).reverse();
    setFilteredEvents(upcoming.slice(0, 3));
  };

  const tileContent = ({ date, view }) => {
    if (view === 'month') {
        const tileDateStr = toDBFormat(date);
        const hasEvent = allEvents.some(ev => isDateInRange(tileDateStr, ev.start_date, ev.end_date));
        if (hasEvent) return <div className="event-dot"></div>;
    }
    return null;
  };

  return (
    <div className="w-full">
      <style>{calendarStyles}</style>

      {/* HEADER */}
      <div className="flex items-center gap-4 mb-8">
         <div className="w-1.5 h-8 bg-[#5E9BF5] rounded-full"></div>
         <h2 className="text-4xl font-bold text-gray-900">Today's Event</h2>
      </div>

      <div className="flex flex-col lg:flex-row gap-8 items-start">
        
        {/* LIST EVENT (KIRI) */}
        <div className="w-full lg:w-2/3 order-2 lg:order-1 min-h-[400px]">
            {loading ? (
                <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
                   {[1,2,3].map(i => <div key={i} className="h-[200px] bg-gray-100 rounded-[20px] animate-pulse"></div>)}
                </div>
            ) : filteredEvents.length > 0 ? (
                <>
                    <div className="flex items-center justify-between px-1 mb-3">
                        <p className="text-xs text-gray-500">
                           {isDateInRange(toDBFormat(selectedDate), filteredEvents[0].start_date, filteredEvents[0].end_date)
                             ? <span>On: <span className="font-bold text-gray-900">{selectedDate.toLocaleDateString('en-GB')}</span></span>
                             : <span>Showing: <span className="font-bold text-[#5E9BF5]">Suggestions</span></span>
                           }
                        </p>
                        <button onClick={handleReset} className="text-[10px] text-[#5E9BF5] font-bold flex items-center gap-1 hover:underline">
                            <RefreshCw size={10} /> Show All
                        </button>
                    </div>
                    
                    {/* GRID 3 KOLOM AGAR KARTU KECIL (COMPACT) */}
                    <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
                        {filteredEvents.map((item) => (
                            <EventCardList 
                                key={item.id_event || item.id}
                                item={item}
                                onPress={() => navigate(`/events/${item.id_event}`)}
                            />
                        ))}
                    </div>
                </>
            ) : (
                <div className="flex flex-col items-center justify-center h-full bg-gray-50 rounded-[32px] border border-dashed border-gray-200 py-12">
                    <p className="text-gray-500 font-bold mb-1 text-sm">No events.</p>
                    <button onClick={handleReset} className="mt-2 px-4 py-1.5 bg-[#5E9BF5] text-white rounded-full font-bold text-xs">Show All</button>
                </div>
            )}
        </div>

        {/* KALENDER (KANAN) */}
        <div className="w-full lg:w-1/3 order-1 lg:order-2">
           <div className="bg-white p-5 rounded-[28px] shadow-lg border border-gray-100 sticky top-24">
              <Calendar 
                onChange={handleDateChange} 
                value={selectedDate} 
                locale="en-US" 
                prev2Label={null} 
                next2Label={null}
                tileContent={tileContent} 
              />
              <div className="mt-4 pt-3 border-t border-gray-100">
                  <div className="flex items-center gap-2 mb-1">
                      <div className="w-1.5 h-1.5 rounded-full bg-[#5E9BF5]"></div>
                      <span className="text-[10px] text-gray-500 font-bold">Active Event</span>
                  </div>
                  <div className="text-[10px] text-gray-400 leading-relaxed">
                      Select marked dates to see details.
                  </div>
              </div>
           </div>
        </div>

      </div>
    </div>
  );
}