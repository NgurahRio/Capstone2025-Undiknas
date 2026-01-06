import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Calendar from 'react-calendar';
import { MapPin, RefreshCw, Star, CalendarDays, Clock3 } from 'lucide-react';
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

const extractBackendRating = (item) => {
  const candidates = [
    item?.calculatedRating,
    item?.calculated_rating,
    item?.avg_rating,
    item?.rating,
  ];
  for (const val of candidates) {
    const num = parseFloat(val);
    if (Number.isFinite(num) && num > 0) return num;
  }
  return null;
};

// --- COMPONENT CARD EVENT COMPACT (VERSI KECIL) ---
const EventCardList = ({ item, onPress, ratingValue }) => {
  const processImage = (img) => {
    const fallback = "https://images.unsplash.com/photo-1492684223066-81342ee5ff30";
    if (!img) return fallback;
    try { if (typeof img === 'string' && img.trim().startsWith('[')) { const p = JSON.parse(img); if (p.length > 0) img = p[0]; } } catch(e) {}
    if (img && !img.startsWith('http') && !img.startsWith('data:')) return `data:image/jpeg;base64,${img}`;
    return img || fallback;
  };

  const priceLabel = () => {
    if (!item.price || parseFloat(item.price) <= 0) return "FREE ENTRY";
    const val = parseFloat(item.price);
    return `IDR ${Math.round(val).toLocaleString('id-ID')}`;
  };

  const ratingLabel = () => {
    const val = parseFloat(ratingValue);
    if (Number.isFinite(val) && val > 0) return val.toFixed(1);
    const backendVal = extractBackendRating(item);
    if (Number.isFinite(backendVal) && backendVal > 0) return backendVal.toFixed(1);
    return "New";
  };

  const formatDateRange = (start, end) => {
    if (!start) return "-";
    const format = (d) => new Date(d).toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' });
    return end && end !== start ? `${format(start)} - ${format(end)}` : format(start);
  };

  const formatTimeRange = (start, end) => {
    if (!start) return "-";
    return end ? `${start} - ${end}` : start;
  };

  return (
    <div 
      onClick={onPress}
      className="group cursor-pointer bg-white rounded-[10px] border border-gray-100 shadow-md hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden hover:-translate-y-1 h-full"
    >
        {/* Gambar */}
        <div className="relative h-[150px] w-full overflow-hidden p-1">
            <img 
                src={processImage(item.image_event)} 
                alt={item.nameevent} 
                className="w-full h-full object-cover group-hover:scale-110 transition duration-700 rounded-[10px]"
            />
            <div className="absolute top-3 right-3 bg-white/90 rounded-full px-3 py-1 text-[11px] font-bold text-gray-800 shadow-sm flex items-center gap-1">
              <Star size={12} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
              <span>{ratingLabel()}</span>
            </div>
        </div>

        {/* Konten */}
        <div className=" flex flex-col">
          <div className="p-4 flex flex-col gap-2">
            <h3 className="text-base font-bold text-gray-900 leading-tight line-clamp-2 min-h-[40px]">
              {item.nameevent || "Event"}
            </h3>
            <div className="flex items-center gap-1.5 text-gray-500 text-[12px] font-medium min-h-[32px]">
                <MapPin size={12} className="text-[#5E9BF5] flex-shrink-0" />
                <span className="truncate">{item.location || "Bali"}</span>
            </div>
            <div className="text-[12px] text-gray-700 space-y-1 leading-snug">
              <div className="flex items-start gap-1.5">
                <CalendarDays size={14} className="text-[#5E9BF5] mt-[1px]" />
                <span className="truncate font-semibold text-gray-800">
                  {formatDateRange(item.start_date, item.end_date)}
                </span>
              </div>
              <div className="flex items-start gap-1.5">
                <Clock3 size={14} className="text-[#5E9BF5] mt-[1px]" />
                <span className="truncate">{formatTimeRange(item.start_time, item.end_time)}</span>
              </div>
            </div>
          </div>

          <div className="mt-auto flex justify-end">
            <span className="text-[11px] font-bold text-white bg-[#82B1FF] px-4 py-3 rounded-tl-[10px] shadow-sm">
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
  const [reviews, setReviews] = useState([]);
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [selectedMonth, setSelectedMonth] = useState(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
  });
  const [availableMonths, setAvailableMonths] = useState([]);
  const [loading, setLoading] = useState(true);
  const [viewMode, setViewMode] = useState('today'); // 'today' | 'month'

  // --- LOGIC HELPER ---
  const toDBFormat = (dateObj) => {
      const year = dateObj.getFullYear();
      const month = String(dateObj.getMonth() + 1).padStart(2, '0');
      const day = String(dateObj.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
  };

  const endOfMonthString = (monthKey) => {
      const [year, month] = monthKey.split('-').map(Number);
      const endDay = new Date(year, month, 0).getDate();
      return `${year}-${String(month).padStart(2, '0')}-${String(endDay).padStart(2, '0')}`;
  };

  const normalizeDate = (dbString) => String(dbString || "").trim().substring(0, 10);

  const isDateInRange = (targetDateStr, startDateStr, endDateStr) => {
      const target = targetDateStr; 
      const start = normalizeDate(startDateStr);
      const end = endDateStr ? normalizeDate(endDateStr) : start;
      return target >= start && target <= end;
  };

  const rangesOverlap = (rangeStart, rangeEnd, windowStart, windowEnd) => {
      const start = normalizeDate(rangeStart);
      const end = normalizeDate(rangeEnd || rangeStart);
      return start <= windowEnd && end >= windowStart;
  };

  const formatDateLong = (dateObj) => {
      return dateObj.toLocaleDateString('id-ID', { day: '2-digit', month: 'long', year: 'numeric' });
  };

  const formatMonthLabel = (monthKey) => {
      const [year, month] = monthKey.split('-').map(Number);
      const dateObj = new Date(year, month - 1, 1);
      return dateObj.toLocaleDateString('id-ID', { month: 'long', year: 'numeric' });
  };

  const formatMonthName = (monthNumber) => {
      return new Date(2000, monthNumber - 1, 1).toLocaleDateString('id-ID', { month: 'long' });
  };

  const computeTodayEvents = (dateStr, events) => {
      const matches = events.filter(ev => isDateInRange(dateStr, ev.start_date, ev.end_date));
      if (matches.length > 0) return matches;
      const upcoming = events.filter(ev => normalizeDate(ev.start_date) >= dateStr);
      return upcoming.slice(0, 3);
  };

  const computeMonthEvents = (monthKey, events) => {
      if (!monthKey) return [];
      const start = `${monthKey}-01`;
      const end = endOfMonthString(monthKey);
      return events.filter(ev => rangesOverlap(ev.start_date, ev.end_date, start, end));
  };

  const parseMonthKey = (monthKey) => {
      if (!monthKey || typeof monthKey !== 'string' || !monthKey.includes('-')) {
        const now = new Date();
        return { year: now.getFullYear(), month: now.getMonth() + 1 };
      }
      const [yearStr, monthStr] = monthKey.split('-');
      const yearNum = Number(yearStr);
      const monthNum = Number(monthStr);
      const now = new Date();
      return {
        year: Number.isFinite(yearNum) ? yearNum : now.getFullYear(),
        month: Number.isFinite(monthNum) ? monthNum : (now.getMonth() + 1),
      };
  };

  const buildMonthKey = (year, month) => `${year}-${String(month).padStart(2, '0')}`;

  const getMonthKeyFromDate = (dateStr) => {
      if (!dateStr) return null;
      const normalized = normalizeDate(dateStr);
      if (!normalized || normalized.length < 7) return null;
      const [y, m] = normalized.split('-');
      return `${y}-${m}`;
  };

  const monthsBetween = (startStr, endStr) => {
      const start = normalizeDate(startStr);
      const end = normalizeDate(endStr || startStr);
      if (!start || !end) return [];
      const startDate = new Date(start);
      const endDate = new Date(end);
      if (Number.isNaN(startDate) || Number.isNaN(endDate)) return [];
      const months = [];
      const cur = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
      const last = new Date(endDate.getFullYear(), endDate.getMonth(), 1);
      while (cur <= last) {
        months.push(buildMonthKey(cur.getFullYear(), cur.getMonth() + 1));
        cur.setMonth(cur.getMonth() + 1);
      }
      return months;
  };

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const res = await api.get('/events');
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        
        const sorted = data.sort((a,b) => (a.start_date || "").localeCompare(b.start_date || ""));
        setAllEvents(sorted);

        // Build available month list based on event ranges (start -> end)
        const monthSet = new Set();
        sorted.forEach((ev) => {
          monthsBetween(ev.start_date, ev.end_date).forEach((mk) => monthSet.add(mk));
          // fallback if no end
          const mkStart = getMonthKeyFromDate(ev.start_date);
          if (mkStart) monthSet.add(mkStart);
        });
        const monthList = Array.from(monthSet).sort();
        setAvailableMonths(monthList);

        // Initialize default month selection to current if available else first available
        const todayStr = toDBFormat(new Date());
        const todayMonthKey = getMonthKeyFromDate(todayStr);
        const initialMonth = (todayMonthKey && monthSet.has(todayMonthKey)) ? todayMonthKey : monthList[0] || selectedMonth;
        setSelectedMonth(initialMonth);
        setFilteredEvents(computeTodayEvents(todayStr, sorted));
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchEvents();
  }, []);

  useEffect(() => {
    const fetchReviews = async () => {
      try {
        const res = await api.get('/review');
        const list = res.data?.data || res.data || [];
        setReviews(Array.isArray(list) ? list : []);
      } catch (err) {
        console.error('Gagal ambil review event:', err);
      }
    };
    fetchReviews();
  }, []);

  useEffect(() => {
    if (allEvents.length === 0) return;
    const todayStr = toDBFormat(selectedDate);
    if (viewMode === 'today') {
        setFilteredEvents(computeTodayEvents(todayStr, allEvents));
    } else {
        setFilteredEvents(computeMonthEvents(selectedMonth, allEvents));
    }
  }, [allEvents, selectedDate, selectedMonth, viewMode]);

  const ratingMap = useMemo(() => {
    if (!reviews.length) return {};
    const totals = {};
    const counts = {};
    reviews.forEach((r) => {
      const evId = String(r.eventId || r.event_id || '');
      const val = parseFloat(r.rating || 0);
      if (!evId || !Number.isFinite(val)) return;
      totals[evId] = (totals[evId] || 0) + val;
      counts[evId] = (counts[evId] || 0) + 1;
    });
    const result = {};
    Object.keys(totals).forEach((key) => {
      if (counts[key] > 0) result[key] = totals[key] / counts[key];
    });
    return result;
  }, [reviews]);

  const handleDateChange = (date) => {
    setSelectedDate(date);
    setViewMode('today');
  };

  const handleToggleAll = () => {
    if (viewMode === 'month') {
      setViewMode('today');
      setSelectedDate(new Date());
      return;
    }
    // Switch to month view using current month if available, otherwise first available from backend
    const now = new Date();
    const currentMonthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    const monthKey = availableMonths.includes(currentMonthKey) ? currentMonthKey : (availableMonths[0] || currentMonthKey);
    setSelectedMonth(monthKey);
    setViewMode('month');
  };

  const handleMonthSelect = (e) => {
    const newMonth = Number(e.target.value);
    if (!newMonth) return;
    const { year } = parseMonthKey(selectedMonth);
    setSelectedMonth(buildMonthKey(year, newMonth));
    setViewMode('month');
  };

  const handleYearSelect = (e) => {
    const newYear = Number(e.target.value);
    if (!newYear) return;
    const { month } = parseMonthKey(selectedMonth);
    setSelectedMonth(buildMonthKey(newYear, month));
    setViewMode('month');
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
        <h2 className="text-4xl font-bold text-gray-900">{viewMode === 'month' ? 'All Events' : 'Event Today'}</h2>
      </div>

      <div className="flex flex-col lg:flex-row gap-8 items-start">
        
        {/* LIST EVENT (KIRI) */}
        <div className="w-full lg:w-2/3 order-2 lg:order-1 min-h-[400px]">
            {loading ? (
                <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
                   {[1,2,3].map(i => <div key={i} className="h-[200px] bg-gray-100 rounded-[20px] animate-pulse"></div>)}
                </div>
            ) : (
              <>
                <div className="flex items-center justify-between px-1 mb-3">
                    <p className="text-xs text-gray-500">
                       {viewMode === 'today' ? (
                          <span>On: <span className="font-bold text-gray-900">{formatDateLong(selectedDate)}</span></span>
                       ) : (
                          <span>On: <span className="font-bold text-gray-900">{formatMonthLabel(selectedMonth)}</span></span>
                       )}
                    </p>
                    <div className="flex items-center gap-2">
                      {viewMode === 'month' && (() => {
                        const { year, month } = parseMonthKey(selectedMonth);
                        const monthKeys = availableMonths.length > 0 ? availableMonths : [selectedMonth];
                        const yearOptions = (() => {
                          const years = Array.from(new Set(monthKeys.map((mk) => Number(mk.split('-')[0])))).sort((a,b) => a - b);
                          if (years.length === 0) return [new Date().getFullYear()];
                          return years;
                        })();
                        const monthOptions = Array.from({ length: 12 }, (_, idx) => idx + 1);
                        return (
                          <div className="flex items-center gap-2 text-[10px] text-gray-500 font-bold">
                            <span>Pilih bulan:</span>
                            <select
                              value={month}
                              onChange={handleMonthSelect}
                              className="border border-gray-200 rounded-md px-2 py-1 text-[10px] text-gray-700 focus:outline-none focus:ring-1 focus:ring-[#5E9BF5]"
                            >
                              {monthOptions.map((m) => (
                                <option key={m} value={m}>{formatMonthName(m)}</option>
                              ))}
                            </select>
                            <select
                              value={year}
                              onChange={handleYearSelect}
                              className="border border-gray-200 rounded-md px-2 py-1 text-[10px] text-gray-700 focus:outline-none focus:ring-1 focus:ring-[#5E9BF5]"
                            >
                              {yearOptions.map((y) => (
                                <option key={y} value={y}>{y}</option>
                              ))}
                            </select>
                          </div>
                        );
                      })()}
                      <button onClick={handleToggleAll} className="text-[10px] text-[#5E9BF5] font-bold flex items-center gap-1 hover:underline">
                          <RefreshCw size={10} /> {viewMode === 'month' ? 'Back To Event Today' : 'All Upcoming Events'}
                      </button>
                    </div>
                </div>

                {filteredEvents.length > 0 ? (
                  <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
                      {filteredEvents.map((item) => (
                          <EventCardList 
                              key={item.id_event || item.id}
                              item={item}
                              ratingValue={ratingMap[String(item.id_event || item.id)]}
                              onPress={() => navigate(`/events/${item.id_event || item.id}`)}
                          />
                      ))}
                  </div>
                ) : (
                    <div className="flex flex-col items-center justify-center h-full bg-gray-50 rounded-[32px] border border-dashed border-gray-200 py-12">
                        <p className="text-gray-500 font-bold mb-1 text-sm">
                          {viewMode === 'month' ? 'No have events in this month.' : 'no events in this month.'}
                        </p>
                        <button onClick={handleToggleAll} className="mt-2 px-4 py-1.5 bg-[#5E9BF5] text-white rounded-full font-bold text-xs">
                          {viewMode === 'month' ? 'Go back to today event' : 'Tampilkan Semua'}
                        </button>
                    </div>
                )}
              </>
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
