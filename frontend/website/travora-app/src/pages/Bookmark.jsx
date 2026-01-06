import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Lock, MapPin, Trash2, Check, Star, CalendarDays, Clock3 } from 'lucide-react';
import PlaceCard from '../components/cards/PlaceCard';
import api from '../api';

export default function Bookmark() {
  const navigate = useNavigate();

  const [user, setUser] = useState(null);
  const [bookmarks, setBookmarks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [isBulkDeleting, setIsBulkDeleting] = useState(false);
  const [selectMode, setSelectMode] = useState(false);
  const [selectedIds, setSelectedIds] = useState(new Set());
  const [viewType, setViewType] = useState('all'); // all | destination | event

  const ratingLabel = (val) => {
    const num = Number(val);
    if (Number.isFinite(num) && num > 0) return num.toFixed(1);
    return 'New';
  };

  const formatPrice = (val) => {
    const num = Number(val);
    if (!Number.isFinite(num) || num <= 0) return '';
    return `IDR ${Math.round(num).toLocaleString('id-ID')}`;
  };

  const enrichDestinationsWithRating = async (list) => {
    return Promise.all(
      list.map(async (d) => {
        const id = d.id_destination || d.id || d.ID || d.destinationId;
        let calculatedRating = Number(d.rating);
        const hasRating = Number.isFinite(calculatedRating) && calculatedRating > 0;

        if (!hasRating && id) {
          try {
            const resRev = await api.get('/review', { params: { destinationId: id } });
            const reviews = resRev.data?.data || resRev.data;
            if (Array.isArray(reviews) && reviews.length > 0) {
              const total = reviews.reduce((acc, curr) => acc + Number(curr.rating || 0), 0);
              calculatedRating = total / reviews.length;
            }
          } catch (err) {
            console.warn('Gagal ambil rating destinasi:', err);
          }
        }

        return { ...d, calculatedRating };
      })
    );
  };

  const enrichEventsWithRating = async (list) => {
    return Promise.all(
      list.map(async (ev) => {
        const id = ev.id_event || ev.id || ev.eventId;
        let calculatedRating = Number(ev.rating || ev.calculatedRating);
        const hasRating = Number.isFinite(calculatedRating) && calculatedRating > 0;

        if (!hasRating && id) {
          try {
            const resRev = await api.get('/review', { params: { eventId: id } });
            const reviews = resRev.data?.data || resRev.data;
            if (Array.isArray(reviews) && reviews.length > 0) {
              const total = reviews.reduce((acc, curr) => acc + Number(curr.rating || 0), 0);
              calculatedRating = total / reviews.length;
            }
          } catch (err) {
            console.warn('Gagal ambil rating event:', err);
          }
        }

        return { ...ev, calculatedRating };
      })
    );
  };

  const pickImage = (item, fallbackField) => {
    if (!item) return '';
    let img = Array.isArray(item.images) && item.images.length > 0 ? item.images[0] : (item.imagedata || item.Image || item.image || item[fallbackField]);
    if (img && typeof img === 'string') {
      try {
        if (img.trim().startsWith('[')) {
          const parsed = JSON.parse(img);
          if (Array.isArray(parsed) && parsed.length > 0) img = parsed[0];
        }
      } catch (_) {}
      if (!img.startsWith('http') && !img.startsWith('data:')) {
        img = `data:image/jpeg;base64,${img}`;
      }
    }
    return img || '';
  };

  const EventBookmarkCard = ({ item, onPress }) => {
    const priceText = item.price || 'FREE ENTRY';
    const processImage = (img) => {
      const fallback = 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30';
      if (!img) return fallback;
      try {
        if (typeof img === 'string' && img.trim().startsWith('[')) {
          const p = JSON.parse(img);
          if (p.length > 0) img = p[0];
        }
      } catch (e) {}
      if (img && !img.startsWith('http') && !img.startsWith('data:')) return `data:image/jpeg;base64,${img}`;
      return img || fallback;
    };
    const imageSrc = processImage(item.img);

    return (
      <div
        onClick={onPress}
        className="group cursor-pointer bg-white rounded-[18px] border border-gray-100 shadow-md hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden hover:-translate-y-1 h-full"
      >
        <div className="relative h-[150px] w-full overflow-hidden">
          <img
            src={imageSrc}
            alt={item.title}
            className="w-full h-full object-cover group-hover:scale-110 transition duration-700"
          />
          <div className="absolute top-3 right-3 bg-white/90 rounded-full px-3 py-1 text-[11px] font-bold text-gray-800 shadow-sm flex items-center gap-1">
            <Star size={12} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
            <span>{ratingLabel(item.rating)}</span>
          </div>
        </div>

        <div className="p-4 flex flex-col gap-2 flex-1">
          <h3 className="text-base font-bold text-gray-900 leading-tight line-clamp-2 min-h-[40px]">
            {item.title || 'Event'}
          </h3>
          <div className="flex items-center gap-1.5 text-gray-500 text-[12px] font-medium min-h-[32px]">
            <MapPin size={12} className="text-[#5E9BF5] flex-shrink-0" />
            <span className="line-clamp-1">{item.location || 'Bali'}</span>
          </div>
          <div className="text-[12px] text-gray-700 space-y-1 leading-snug">
            <div className="flex items-start gap-1.5">
              <CalendarDays size={14} className="text-[#5E9BF5] mt-[1px]" />
              <span className="line-clamp-1 font-semibold text-gray-800">Tanggal belum tersedia</span>
            </div>
            <div className="flex items-start gap-1.5">
              <Clock3 size={14} className="text-[#5E9BF5] mt-[1px]" />
              <span className="line-clamp-1">Waktu belum tersedia</span>
            </div>
          </div>

          <div className="mt-auto flex justify-end">
            <span className="text-[11px] font-bold text-white bg-[#82B1FF] px-3 py-2 rounded-md shadow-sm">
              {priceText}
            </span>
          </div>
        </div>
      </div>
    );
  };

  useEffect(() => {
    const token = localStorage.getItem('travora_token');
    const storedUser = localStorage.getItem('travora_user');

    if (storedUser && token) {
      setUser(JSON.parse(storedUser));
    } else {
      localStorage.removeItem('travora_user');
      setUser(null);
    }

    if (!token) {
      setLoading(false);
      return;
    }

    const fetchBookmarks = async () => {
      try {
        setLoading(true);
        setError('');
        const res = await api.get('/user/favorite');
        const favorites = res.data?.favorites || [];
        const destinationsRaw = res.data?.destinations || [];
        let eventsRaw = res.data?.events || [];

        if (!Array.isArray(eventsRaw) || eventsRaw.length === 0) {
          try {
            const resEvents = await api.get('/events');
            eventsRaw = Array.isArray(resEvents.data) ? resEvents.data : resEvents.data?.data || [];
          } catch (err) {
            console.warn('Fallback fetch events gagal:', err);
            eventsRaw = [];
          }
        }

        const destinations = await enrichDestinationsWithRating(Array.isArray(destinationsRaw) ? destinationsRaw : []);
        const events = await enrichEventsWithRating(Array.isArray(eventsRaw) ? eventsRaw : []);

        const destMap = {};
        destinations.forEach((d) => {
          const id = d.id_destination || d.id || d.ID || d.destinationId;
          if (id) destMap[String(id)] = d;
        });

        const eventMap = {};
        events.forEach((ev) => {
          const id = ev.id_event || ev.id || ev.eventId;
          if (id) eventMap[String(id)] = ev;
        });

        const mapped = favorites
          .map((fav) => {
            const destId = fav.destinationId || fav.destination_id || fav.destinationID;
            const eventId = fav.eventId || fav.event_id || fav.eventID;

            if (destId) {
              const dest = destMap[String(destId)];
              if (!dest) return null;
              return {
                id: `${destId}`,
                rawId: destId,
                type: 'destination',
                title: dest.namedestination || dest.NameDestination || dest.name || 'Destination',
                location: dest.location,
                description: dest.description || dest.desc || dest.detail || dest.detail_destination,
                img: pickImage(dest),
                rating: ratingLabel(dest.calculatedRating || dest.rating),
              };
            }

            if (eventId) {
              const ev = eventMap[String(eventId)];
              if (!ev) return null;
              return {
                id: `${eventId}`,
                rawId: eventId,
                type: 'event',
                title: ev.nameevent || ev.name || 'Event',
                location: ev.location,
                img: pickImage(ev, 'image_event'),
                rating: ratingLabel(ev.calculatedRating || ev.rating),
                startDate: ev.start_date,
                endDate: ev.end_date,
                startTime: ev.start_time,
                endTime: ev.end_time,
                price: formatPrice(ev.price || ev.Price || ev.price_event || ev.eventPrice),
              };
            }
            return null;
          })
          .filter(Boolean);

        setBookmarks(mapped);
      } catch (e) {
        console.error("Error fetching bookmarks:", e);
        setError('Gagal memuat bookmark. Coba lagi nanti.');
      } finally {
        setLoading(false);
      }
    };

    fetchBookmarks();
  }, []);

  const handleRemoveAll = async () => {
    const targetItems = selectMode && selectedIds.size > 0
      ? bookmarks.filter((b) => selectedIds.has(`${b.type}:${b.id}`))
      : bookmarks;
    if (targetItems.length === 0) return;
    if (!window.confirm(selectMode ? "Hapus bookmark yang dipilih?" : "Hapus semua bookmark?")) return;

    setIsBulkDeleting(true);
    try {
      await Promise.allSettled(
        targetItems.map((item) => {
          const url = item.type === 'event'
            ? `/user/favorite/${item.rawId}?type=event`
            : `/user/favorite/${item.rawId}`;
          return api.delete(url).catch(() => null);
        })
      );
      const removeKeys = new Set(targetItems.map((item) => `${item.type}:${item.id}`));
      const remaining = bookmarks.filter((item) => !removeKeys.has(`${item.type}:${item.id}`));
      setBookmarks(remaining);
      setSelectedIds(new Set());
      if (selectMode && remaining.length === 0) setSelectMode(false);
    } catch (err) {
      console.error('Gagal hapus semua bookmark:', err);
      alert('Gagal menghapus semua bookmark. Coba lagi.');
    } finally {
      setIsBulkDeleting(false);
    }
  };

  const toggleSelectMode = () => {
    setSelectMode((prev) => {
      const next = !prev;
      if (!next) setSelectedIds(new Set());
      return next;
    });
  };

  const toggleSelect = (key) => {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  const isSelected = (key) => selectedIds.has(key);

  const filtered = bookmarks.filter((b) => {
    if (viewType === 'all') return true;
    return viewType === 'destination' ? b.type === 'destination' : b.type === 'event';
  });

  if (!user) {
    return (
        <div className="w-full min-h-screen pt-32 pb-20 animate-fade-in">
           <div className="max-w-2xl mx-auto text-center px-6">
                <div className="bg-white p-12 rounded-[40px] shadow-xl border border-gray-100">
                    <div className="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center mx-auto mb-6">
                        <Lock size={40} className="text-[#5E9BF5]" />
                    </div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-4">Access Restricted</h1>
                    <p className="text-gray-500 mb-8 text-lg">Please login to view your saved collection.</p>
                    <button onClick={() => navigate('/auth')} className="bg-[#82B1FF] text-white px-10 py-4 rounded-full font-bold hover:bg-[#6fa5ff] transition">
                        Login Now
                    </button>
                </div>
           </div>
        </div>
    );
  }

  if (loading) {
    return (
        <div className="min-h-screen pt-40 text-center">
            <p className="text-gray-400 text-lg animate-pulse">Loading your bookmarks...</p>
        </div>
    );
  }

  return (
    <div className="w-full animate-fade-in pb-20">
      <div className="h-[350px] relative w-full">
        <img src="/src/assets/gambar1.png" className="w-full h-full object-cover brightness-50" alt="Book Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
             <h1 className="text-5xl md:text-6xl font-bold text-white">My Bookmarks</h1>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-3">
              <h2 className="text-[#82B1FF] text-xl font-bold uppercase tracking-wide">Bookmark</h2>
              <span className="bg-gray-100 text-gray-600 px-4 py-1 rounded-full text-sm font-bold border border-gray-200">
                  {filtered.length} Items
              </span>
            </div>
        </div>
        {error && (
          <div className="mb-4 text-sm text-red-600 bg-red-50 border border-red-100 rounded-xl px-4 py-2">
            {error}
          </div>
        )}
        <div className="h-[1px] bg-gray-200 w-full mb-6"></div>

        <div className="flex flex-wrap items-center gap-3 mb-6">
          <button
            onClick={toggleSelectMode}
            className={`px-4 py-2 rounded-md text-sm font-semibold shadow-sm hover:border-[#5E9BF5] ${
              selectMode ? 'bg-[#5E9BF5] text-white' : 'bg-white border border-gray-200 text-gray-600'
            }`}
          >
            {selectMode ? 'Done' : 'Choose'}
          </button>
          <button
            onClick={handleRemoveAll}
            disabled={filtered.length === 0 || isBulkDeleting}
            className={`px-4 py-2 rounded-md text-sm font-bold text-white shadow-sm transition ${
              filtered.length === 0 || isBulkDeleting
                ? 'bg-gray-300 cursor-not-allowed'
                : 'bg-[#F96262] hover:bg-[#e74c4c]'
            }`}
          >
            {isBulkDeleting ? 'Deleting...' : selectMode && selectedIds.size > 0 ? 'Delete Selected' : 'Delete All'}
          </button>
          <div className="relative ml-auto">
            <select
              value={viewType}
              onChange={(e) => setViewType(e.target.value)}
              className="appearance-none px-6 py-3 rounded-xl text-base font-bold shadow-sm cursor-pointer transition bg-white text-[#1F4F8C] border border-gray-200 hover:border-[#5E9BF5] focus:border-[#5E9BF5] focus:ring-0 pr-14 min-w-[230px]"
              style={{
                appearance: 'none',
                WebkitAppearance: 'none',
                MozAppearance: 'none',
                backgroundImage:
                  "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='10' viewBox='0 0 16 10'%3E%3Cpath d='M2 2l6 6 6-6' stroke='%235E9BF5' stroke-width='2.2' fill='none' stroke-linecap='round'/%3E%3C/svg%3E\")",
                backgroundRepeat: 'no-repeat',
                backgroundPosition: 'right 12px center',
              }}
            >
              <option value="all">Show All</option>
              <option value="destination">Show Destinations</option>
              <option value="event">Show Events</option>
            </select>
          </div>
        </div>

        {filtered.length === 0 ? (
           <div className="text-center py-24 bg-gray-50 rounded-[40px] border border-dashed border-gray-300">
             <div className="bg-white w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 shadow-sm">
                <MapPin size={32} className="text-gray-300" />
             </div>
             <p className="text-2xl text-gray-800 font-bold mb-2">No bookmarks yet</p>
             <p className="text-gray-400 mb-8">Start exploring Bali and save your favorite spots!</p>
             <button onClick={() => navigate('/')} className="text-[#5E9BF5] font-bold border-b-2 border-[#5E9BF5] pb-1 hover:opacity-80">
                Go to Explore
             </button>
           </div>
        ) : (
           <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              {filtered.map((item) => {
                const key = `${item.type}:${item.id}`;
                const isEvent = item.type === 'event';
                const metaDate = '';
                const metaTime = '';
                const metaLocation = isEvent ? item.location : undefined;
                const priceLabel = isEvent ? item.price : undefined;
                return (
                  <div key={key} className="relative group hover:-translate-y-2 transition-transform duration-300">
                        {isEvent ? (
                          <EventBookmarkCard 
                            item={item} 
                            onPress={() => {
                              if (selectMode) {
                                toggleSelect(key);
                              } else {
                                navigate(`/events/${item.id}`);
                              }
                            }}
                          />
                        ) : (
                          <PlaceCard 
                            title={item.title} 
                            subtitle={undefined}
                            description={item.description}
                            img={item.img} 
                            rating={item.rating || "4.9"}
                            metaLocation={metaLocation}
                            metaDate={metaDate}
                            metaTime={metaTime}
                            priceLabel={priceLabel}
                            onPress={() => {
                              if (selectMode) {
                                toggleSelect(key);
                              } else {
                                navigate(`/destination/${item.id}`);
                              }
                            }} 
                          />
                        )}
                        {selectMode && (
                          <button
                            onClick={() => toggleSelect(key)}
                            className={`absolute top-3 left-3 w-7 h-7 rounded-full flex items-center justify-center border-2 transition ${isSelected(key)
                                ? 'bg-[#5E9BF5] border-[#5E9BF5] text-white'
                                : 'bg-white border-gray-200 text-gray-400'
                            }`}
                          >
                            {isSelected(key) && <Check size={14} />}
                          </button>
                        )}
                      
                  </div>
              )})}
           </div>
        )}
      </div>
    </div>
  );
}
