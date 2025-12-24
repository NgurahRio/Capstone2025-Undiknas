import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Calendar from 'react-calendar';
import { MapPin, ArrowRight, Clock, RefreshCw, Star } from 'lucide-react';
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

  const priceLabel = () => {
    if (!item.price || parseFloat(item.price) <= 0) return "FREE ACCESS";
    const val = parseFloat(item.price);
    return `IDR ${Math.round(val).toLocaleString('id-ID')}`;
  };

  const ratingLabel = () => {
    const val = parseFloat(item?.rating);
    if (Number.isFinite(val) && val > 0) return val.toFixed(1);
    if (Number.isFinite(item?.calculatedRating) && item.calculatedRating > 0) return item.calculatedRating.toFixed(1);
    return "New";
  };

  return (
    <div 
      onClick={onPress}
      className="group cursor-pointer bg-white rounded-[18px] border border-gray-100 shadow-md hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden hover:-translate-y-1 h-full"
    >
        {/* Gambar */}
        <div className="relative h-[150px] w-full overflow-hidden">
            <img 
                src={processImage(item.image_event)} 
                alt={item.nameevent} 
                className="w-full h-full object-cover group-hover:scale-110 transition duration-700"
            />
            <div className="absolute top-3 right-3 bg-white/90 rounded-full px-3 py-1 text-[11px] font-bold text-gray-800 shadow-sm flex items-center gap-1">
              <Star size={12} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
              <span>{ratingLabel()}</span>
            </div>
        </div>

        {/* Konten */}
        <div className="p-4 flex flex-col gap-2 flex-1">
            <h3 className="text-base font-bold text-gray-900 leading-tight">{item.nameevent || "Event"}</h3>
            <div className="flex items-center gap-1.5 text-gray-500 text-[12px] font-medium">
                <MapPin size={12} className="text-[#5E9BF5] flex-shrink-0" />
                <span className="truncate">{item.location || "Bali"}</span>
            </div>
            <p className="text-sm text-gray-500 leading-snug line-clamp-2">{item.description || "Exciting experience awaits you."}</p>

            <div className="mt-auto flex justify-end">
              <span className="text-[11px] font-bold text-white bg-[#82B1FF] px-3 py-2 rounded-md shadow-sm">
                {priceLabel()}
              </span>
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
    <div className="w-full bg-[#EEF3FF] rounded-[28px] px-4 py-8 lg:px-8">
      <style>{calendarStyles}</style>

      {/* HEADER */}
      <div className="flex items-center gap-4 mb-8">
         <div className="w-1.5 h-8 bg-[#5E9BF5] rounded-full"></div>
         <h2 className="text-4xl font-bold text-gray-900">Event Today</h2>
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
                             : <span>displays for: <span className="font-bold text-[#5E9BF5]">All Upcoming Events</span></span>
                           }
                        </p>
                        <button onClick={handleReset} className="text-[10px] text-[#5E9BF5] font-bold flex items-center gap-1 hover:underline">
                            <RefreshCw size={10} /> Tampilkan Semua
                        </button>
                    </div>
                    
                    {/* GRID 3 KOLOM AGAR KARTU KECIL (COMPACT) */}
                    <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
                        {filteredEvents.map((item) => (
                            <EventCardList 
                                key={item.id_event || item.id}
                                item={item}
                                onPress={() => navigate(`/events/${item.id_event || item.id}`)}
                            />
                        ))}
                    </div>
                </>
            ) : (
                <div className="flex flex-col items-center justify-center h-full bg-gray-50 rounded-[32px] border border-dashed border-gray-200 py-12">
                    <p className="text-gray-500 font-bold mb-1 text-sm">Tidak ada acara.</p>
                    <button onClick={handleReset} className="mt-2 px-4 py-1.5 bg-[#5E9BF5] text-white rounded-full font-bold text-xs">Tampilkan Semua</button>
                </div>
            )}
        </div>

        {/* KALENDER (KANAN) */}
        <div className="w-full lg:w-1/3 order-1 lg:order-2">
           <div className="bg-white p-5 rounded-[28px] shadow-lg border border-gray-100 sticky top-24">
              <Calendar 
                onChange={handleDateChange} 
                value={selectedDate} 
                locale="id-ID" 
                prev2Label={null} 
                next2Label={null}
                tileContent={tileContent} 
              />
              <div className="mt-4 pt-3 border-t border-gray-100">
                  <div className="flex items-center gap-2 mb-1">
                      <div className="w-1.5 h-1.5 rounded-full bg-[#5E9BF5]"></div>
                      <span className="text-[10px] text-gray-500 font-bold">Acara Aktif</span>
                  </div>
                  <div className="text-[10px] text-gray-400 leading-relaxed">
                      Pilih tanggal bertanda untuk melihat detail.
                  </div>
              </div>
           </div>
        </div>

      </div>
    </div>
  );
}
