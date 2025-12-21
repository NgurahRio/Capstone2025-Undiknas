import React, { useEffect, useState } from 'react';
import { Calendar, MapPin, ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api';

export default function EventSection() {
  const navigate = useNavigate();
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        // Backend Route: r.GET("/events", ...)
        const res = await api.get('/events');
        
        const eventList = Array.isArray(res.data) ? res.data : (res.data.data || []);
        
        if (eventList.length > 0) {
            setEvents(eventList);
        } else {
            setEvents(dummyEvents); // Fallback ke dummy jika database kosong
        }
      } catch (err) {
        console.error("Gagal ambil event, pakai dummy:", err);
        setEvents(dummyEvents);
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

  if (loading) {
    return (
        <div className="py-10 text-center">
            <div className="w-12 h-12 border-4 border-gray-200 border-t-[#5E9BF5] rounded-full animate-spin mx-auto mb-4"></div>
            <p className="text-gray-400">Loading upcoming events...</p>
        </div>
    );
  }

  return (
    <div className="flex flex-col gap-10">
      <div className="flex items-center justify-between">
         <div className="flex items-center gap-4">
            <div className="w-2 h-10 bg-black rounded-full"></div>
            <h2 className="text-4xl font-bold text-gray-900">Upcoming Events</h2>
         </div>
         <button onClick={() => navigate('/events')} className="text-[#5E9BF5] font-bold flex items-center gap-2 hover:translate-x-1 transition">
            View All <ArrowRight size={20} />
         </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
         {events.slice(0, 3).map((item, index) => (
            <EventCard 
                key={index}
                // Mapping Field Backend Golang
                title={item.NameEvent || item.title}
                date={item.Date || item.date}
                location={item.Location || item.location}
                img={item.Image || item.img}
                price={item.Price || item.price}
                onPress={() => navigate(`/events/${item.ID || item.id}`)}
            />
         ))}
      </div>
    </div>
  );
}

const EventCard = ({ title, date, location, img, price, onPress }) => (
  <div onClick={onPress} className="group cursor-pointer bg-white rounded-[32px] border border-gray-100 shadow-sm hover:shadow-xl transition duration-300 overflow-hidden flex flex-col h-full">
    <div className="h-[200px] overflow-hidden relative">
        <img src={img || "https://via.placeholder.com/400x200"} className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
        <div className="absolute top-4 right-4 bg-white/90 backdrop-blur-sm px-4 py-1 rounded-full text-xs font-bold text-[#5E9BF5] uppercase tracking-wider">
            {price ? (price === "0" || price === 0 ? "Free" : `IDR ${parseInt(price).toLocaleString()}`) : "Coming Soon"}
        </div>
    </div>
    <div className="p-6 flex flex-col flex-1">
        <div className="flex items-center gap-2 text-[#5E9BF5] text-sm font-bold mb-3">
            <Calendar size={16} />
            <span>{date ? new Date(date).toLocaleDateString('id-ID') : 'TBA'}</span>
        </div>
        <h3 className="text-xl font-bold text-gray-900 mb-2 line-clamp-2 group-hover:text-[#5E9BF5] transition">{title}</h3>
        <div className="flex items-center gap-2 text-gray-400 text-sm mt-auto pt-4 border-t border-gray-100">
            <MapPin size={16} />
            <span className="truncate">{location}</span>
        </div>
    </div>
  </div>
);

const dummyEvents = [
    { id: 1, title: "Ubud Food Festival 2024", date: "2024-06-21", location: "Taman Kuliner, Ubud", img: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=600", price: 150000 },
    { id: 2, title: "Bali Spirit Festival", date: "2024-05-04", location: "Yoga Barn, Ubud", img: "https://images.unsplash.com/photo-1599447421405-0e32096d30fd?q=80&w=600", price: 2500000 },
    { id: 3, title: "Jazz Market by The Sea", date: "2024-08-14", location: "Taman Bhagawan, Nusa Dua", img: "https://images.unsplash.com/photo-1514525253440-b393452e8d03?q=80&w=600", price: 100000 }
];