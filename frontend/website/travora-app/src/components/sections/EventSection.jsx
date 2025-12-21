import React, { useEffect, useState } from 'react';
import { Calendar, MapPin, ArrowRight, Tag } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api';

// --- KOMPONEN KARTU EVENT (Desain Baru & Interaktif) ---
const EventCard = ({ title, date, location, img, price, onPress }) => {
  // Fungsi Helper: Format Tanggal agar cantik (Contoh: 12 Aug 2024)
  const formatDate = (dateString) => {
    if (!dateString) return "Coming Soon";
    try {
      const options = { day: 'numeric', month: 'short', year: 'numeric' };
      return new Date(dateString).toLocaleDateString('en-GB', options);
    } catch (e) {
      return dateString;
    }
  };

  return (
    <div 
      onClick={onPress} 
      className="group cursor-pointer bg-white rounded-[32px] border border-gray-100 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 flex flex-col h-full overflow-hidden"
    >
      {/* BAGIAN ATAS: GAMBAR & HARGA */}
      <div className="h-[240px] overflow-hidden relative">
        <img 
            src={img || "https://via.placeholder.com/400x300"} 
            className="w-full h-full object-cover group-hover:scale-110 transition duration-700" 
            alt={title} 
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-60"></div>
        
        {/* Badge Harga */}
        <div className="absolute top-4 right-4 bg-white/95 backdrop-blur-md px-4 py-1.5 rounded-full flex items-center gap-1 shadow-md">
            <Tag size={14} className="text-[#5E9BF5]" />
            <span className="text-xs font-bold text-[#5E9BF5] uppercase tracking-wider">
                {price && parseInt(price) > 0 ? `IDR ${parseInt(price).toLocaleString('id-ID')}` : "FREE"}
            </span>
        </div>
      </div>

      {/* BAGIAN BAWAH: INFO */}
      <div className="p-8 flex flex-col flex-1 relative">
        {/* Tanggal (Highlight) */}
        <div className="absolute -top-6 left-8 bg-[#5E9BF5] text-white px-4 py-2 rounded-xl shadow-lg flex items-center gap-2 text-sm font-bold">
            <Calendar size={16} />
            <span>{formatDate(date)}</span>
        </div>

        <div className="mt-4">
            <h3 className="text-2xl font-bold text-gray-900 mb-2 leading-tight group-hover:text-[#5E9BF5] transition line-clamp-2">
                {title || "Untitled Event"}
            </h3>
            <div className="flex items-center gap-2 text-gray-500 text-sm font-medium">
                <MapPin size={18} className="text-gray-400" />
                <span className="truncate">{location || "Bali, Indonesia"}</span>
            </div>
        </div>
        
        {/* Tombol Panah Kecil di Bawah */}
        <div className="mt-auto pt-6 flex justify-end">
            <div className="w-10 h-10 rounded-full bg-gray-50 flex items-center justify-center text-gray-400 group-hover:bg-[#5E9BF5] group-hover:text-white transition duration-300">
                <ArrowRight size={20} className="-rotate-45 group-hover:rotate-0 transition duration-300" />
            </div>
        </div>
      </div>
    </div>
  );
};

// --- SECTION UTAMA ---
export default function EventSection() {
  const navigate = useNavigate();
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchEvents = async () => {
      try {
        const res = await api.get('/events');
        // Handle struktur data array atau object { data: [] }
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        setEvents(data);
      } catch (err) {
        console.error("Gagal ambil event:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchEvents();
  }, []);

  return (
    <div className="flex flex-col gap-10">
      <div className="flex items-center justify-between">
         <div className="flex items-center gap-4">
            <div className="w-2 h-10 bg-[#5E9BF5] rounded-full"></div>
            <h2 className="text-4xl font-bold text-gray-900">Upcoming Events</h2>
         </div>
         <button onClick={() => navigate('/events')} className="text-[#5E9BF5] font-bold flex items-center gap-2 hover:translate-x-1 transition">
            See All Events <ArrowRight size={20} />
         </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
         {loading ? (
             // Skeleton Loading
             [1,2,3].map(i => <div key={i} className="h-[450px] bg-gray-100 rounded-[32px] animate-pulse"></div>)
         ) : events.length > 0 ? (
             events.slice(0, 3).map((item) => (
                <EventCard 
                    key={item.ID || item.id}
                    // Mapping Data Backend -> Props Component
                    title={item.NameEvent || item.name_event || item.title}
                    date={item.Date || item.date}
                    location={item.Location || item.location}
                    price={item.Price || item.price}
                    img={item.Image || item.image}
                    onPress={() => navigate(`/events/${item.ID || item.id}`)} // Pastikan ada route detail event jika mau diklik
                />
             ))
         ) : (
             // Tampilan jika data kosong (Opsional: Bisa dihapus jika ingin hidden)
             <div className="col-span-3 text-center py-10 bg-gray-50 rounded-[32px] border border-dashed border-gray-300">
                <p className="text-gray-400 font-bold">No upcoming events found.</p>
             </div>
         )}
      </div>
    </div>
  );
}