import React, { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight, MapPin, Star } from 'lucide-react';
import { api } from '../../api';

export default function PopularPlaces() {
  const navigate = useNavigate();
  const sliderRef = useRef(null);
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDestinations = async () => {
      try {
        const res = await api.get('/destinations');
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        setDestinations(data);
      } catch (err) {
        console.error("Error:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchDestinations();
  }, []);

  const scroll = (direction) => {
    if (sliderRef.current) {
      const { current } = sliderRef;
      const scrollAmount = 270;
      if (direction === 'left') {
        current.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
      } else {
        current.scrollBy({ left: scrollAmount, behavior: 'smooth' });
      }
    }
  };

  // --- FIX: Logic Gambar agar tidak return "" ---
  const processImage = (item) => {
    let raw = item?.imagedata || item?.Image;
    
    // Fallback Image (Wajib ada biar tidak src="")
    const fallback = "https://images.unsplash.com/photo-1544644181-1484b3fdfc62";

    if (!raw) return fallback;

    try {
      if (typeof raw === 'string' && raw.trim().startsWith('[')) {
        const parsed = JSON.parse(raw);
        if (Array.isArray(parsed) && parsed.length > 0) raw = parsed[0];
      }
    } catch (e) {}

    if (raw && !raw.startsWith('http') && !raw.startsWith('data:')) {
      return `data:image/jpeg;base64,${raw}`;
    }
    
    // Jika masih kosong setelah proses, return fallback
    return raw || fallback;
  };

  if (loading) return <div className="h-[360px] bg-gray-100 rounded-[32px] animate-pulse"></div>;

  return (
    <div className="flex flex-col lg:flex-row gap-6 items-center w-full py-8">
      
      <div className="lg:w-1/4 min-w-[260px] flex flex-col gap-4 pr-2">
         <div>
            <h2 className="text-4xl font-extrabold text-gray-900 leading-tight uppercase mb-3">
              Popular <br/> Place Now
            </h2>
            <p className="text-gray-500 text-sm leading-relaxed">
              Discover the most popular travel spots in Bali right now.
            </p>
         </div>
      </div>

      <div className="lg:w-3/4 w-full flex items-center gap-5">
        <button 
            onClick={() => scroll('left')}
            className="flex-shrink-0 w-14 h-14 rounded-full border border-gray-300 bg-white flex items-center justify-center text-gray-600 hover:bg-[#5E9BF5] hover:text-white hover:border-[#5E9BF5] transition duration-300 active:scale-95 shadow-sm"
        >
            <ArrowLeft size={24} />
        </button>

        <div 
            ref={sliderRef}
            className="flex-1 flex gap-5 overflow-x-auto py-4 px-2 hide-scrollbar snap-x snap-mandatory scroll-smooth"
            style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
            {destinations.length > 0 ? destinations.map((item) => {
                const imageUrl = processImage(item);
                const title = item.namedestination || item.name || "Destination";
                const location = item.location || "Bali";

                return (
                    <div 
                        key={item.id_destination || item.ID}
                        onClick={() => navigate(`/destination/${item.id_destination || item.ID}`)}
                        className="w-[250px] min-w-[250px] h-[360px] relative rounded-[32px] overflow-hidden cursor-pointer snap-start shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-2 group flex-shrink-0"
                    >
                        <img 
                            src={imageUrl} 
                            className="w-full h-full object-cover group-hover:scale-110 transition duration-700 ease-in-out" 
                            alt={title} 
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-90"></div>
                        <div className="absolute top-4 right-4 bg-white/20 backdrop-blur-md border border-white/20 px-3 py-1 rounded-full flex items-center gap-1 shadow-sm">
                            <Star size={12} fill="#FFD700" stroke="none" />
                            <span className="text-white font-bold text-xs">4.8</span>
                        </div>
                        <div className="absolute bottom-6 left-6 right-6 text-white z-10">
                            <h3 className="text-xl font-bold mb-2 leading-tight line-clamp-2 group-hover:text-[#82B1FF] transition-colors">
                                {title}
                            </h3>
                            <div className="flex items-center gap-2 text-gray-300 text-xs font-medium">
                                <MapPin size={16} className="text-[#5E9BF5]" />
                                <span className="truncate">{location}</span>
                            </div>
                        </div>
                    </div>
                );
            }) : (
                <div className="w-full text-center py-10 text-gray-400">Belum ada data destinasi.</div>
            )}
        </div>

        <button 
            onClick={() => scroll('right')}
            className="flex-shrink-0 w-14 h-14 rounded-full bg-[#1F2937] text-white flex items-center justify-center shadow-lg hover:bg-[#5E9BF5] transition duration-300 active:scale-95"
        >
            <ArrowRight size={24} />
        </button>
      </div>
    </div>
  );
}