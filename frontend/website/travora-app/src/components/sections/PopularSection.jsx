import React, { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight, MapPin, Star } from 'lucide-react';
import { api } from '../../api';

export default function PopularPlaces() {
  const navigate = useNavigate();
  const sliderRef = useRef(null);
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);

  // --- 1. FETCH DATA + HITUNG RATING ---
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);

        // A. Ambil Data Destinasi
        const res = await api.get('/destinations');
        const rawData = Array.isArray(res.data) ? res.data : (res.data.data || []);

        // B. Ambil Review secara Paralel
        const dataWithRating = await Promise.all(rawData.map(async (item) => {
            const destId = item.id_destination || item.id;
            let ratingValue = 0;
            try {
                const resRev = await api.get('/review', { params: { destinationId: destId } });
                const reviews = resRev.data.data || resRev.data;
                if (Array.isArray(reviews) && reviews.length > 0) {
                    const total = reviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0), 0);
                    ratingValue = total / reviews.length;
                }
            } catch (err) {}

            return { ...item, calculatedRating: ratingValue };
        }));

        const sorted = dataWithRating.sort((a, b) => (b.calculatedRating || 0) - (a.calculatedRating || 0));
        setDestinations(sorted);

      } catch (err) {
        console.error("Error loading popular places:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const scroll = (direction) => {
    if (sliderRef.current) {
      const { current } = sliderRef;
      const scrollAmount = 280;
      if (direction === 'left') {
        current.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
      } else {
        current.scrollBy({ left: scrollAmount, behavior: 'smooth' });
      }
    }
  };

  const processImage = (item) => {
    const fallback = "https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=600&q=80";
    
    // Prioritas: field "images" dari backend user/destination
    if (Array.isArray(item?.images) && item.images.length > 0) {
      const first = item.images[0];
      if (first && !first.startsWith('http') && !first.startsWith('data:')) {
        return `data:image/jpeg;base64,${first}`;
      }
      return first || fallback;
    }

    let raw = item?.imagedata || item?.Image || item?.image; 
    if (typeof raw === 'string' && (raw.startsWith('[') || raw.startsWith('{'))) {
        try {
            const parsed = JSON.parse(raw);
            if (Array.isArray(parsed) && parsed.length > 0) raw = parsed[0];
        } catch (e) {}
    }
    
    if (raw && !raw.startsWith('http') && !raw.startsWith('data:')) {
      return `data:image/jpeg;base64,${raw}`;
    }
    return raw || fallback;
  };

  const handleCardClick = (item) => {
      const validId = item.id_destination || item.id || item.ID;
      if (validId) {
          navigate(`/destination/${validId}`);
      }
  };

  if (loading) return (
      <div className="flex gap-4 overflow-hidden py-8">
          {[1,2,3,4].map(i => <div key={i} className="w-[250px] h-[360px] bg-gray-100 rounded-[32px] animate-pulse flex-shrink-0"></div>)}
      </div>
  );

  return (
    <div className="flex flex-col lg:flex-row gap-6 items-center w-full py-8 bg-[#EEF3FF] rounded-[28px] px-4 lg:px-8">
      
      {/* HEADER SECTION (TEKS DI KIRI) */}
      <div className="lg:w-1/4 min-w-[260px] flex flex-col gap-4 pr-2">
         <div>
            <h2 className="text-4xl font-extrabold text-gray-900 leading-tight uppercase mb-3">
              Popular <br/> <span className="text-[#5E9BF5]">Place Now</span>
            </h2>
            <p className="text-gray-500 text-sm leading-relaxed">
              Discover the most popular travel spots in Bali based on real traveler reviews.
            </p>
         </div>
      </div>

      {/* SLIDER SECTION (KANAN - DENGAN TOMBOL MENGAPIT) */}
      <div className="lg:w-3/4 w-full flex items-center gap-5">
        
        {/* TOMBOL KIRI */}
        <button 
            onClick={() => scroll('left')}
            className="flex-shrink-0 w-14 h-14 rounded-full border border-gray-300 bg-white flex items-center justify-center text-gray-600 hover:bg-[#5E9BF5] hover:text-white hover:border-[#5E9BF5] transition duration-300 active:scale-95 shadow-sm hidden md:flex"
        >
            <ArrowLeft size={24} />
        </button>

        {/* SLIDER CONTAINER */}
        <div 
            ref={sliderRef}
            className="flex-1 flex gap-5 overflow-x-auto py-4 px-2 hide-scrollbar snap-x snap-mandatory scroll-smooth"
            style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
            {destinations.length > 0 ? destinations.map((item, index) => {
                const imageUrl = processImage(item);
                const title = item.namedestination || item.NameDestination || "Unknown";
                const location = item.location || "Bali";
                const rating = item.calculatedRating > 0 ? item.calculatedRating.toFixed(1) : "New"; 
                const keyId = item.id_destination || index;

                return (
                    <div 
                        key={keyId}
                        onClick={() => handleCardClick(item)}
                        className="w-[260px] min-w-[260px] h-[380px] relative rounded-[32px] overflow-hidden cursor-pointer snap-start shadow-md hover:shadow-2xl transition-all duration-500 hover:-translate-y-2 group flex-shrink-0"
                    >
                        <img 
                            src={imageUrl} 
                            className="w-full h-full object-cover group-hover:scale-110 transition duration-700 ease-in-out" 
                            alt={title} 
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent opacity-80 group-hover:opacity-90 transition"></div>
                        
                        <div className="absolute top-4 right-4 bg-white/20 backdrop-blur-md border border-white/30 px-3 py-1.5 rounded-full flex items-center gap-1 shadow-sm">
                            <Star size={14} fill={rating !== "New" ? "#FFD700" : "#E5E7EB"} stroke="none" />
                            <span className="text-white font-bold text-xs">{rating}</span>
                        </div>

                        <div className="absolute bottom-6 left-6 right-6 text-white z-10 translate-y-2 group-hover:translate-y-0 transition duration-500">
                            <h3 className="text-2xl font-bold mb-1 leading-tight line-clamp-2 group-hover:text-[#82B1FF] transition-colors">
                                {title}
                            </h3>
                            <div className="flex items-center gap-2 text-gray-300 text-xs font-medium mb-3">
                                <MapPin size={14} className="text-[#5E9BF5]" />
                                <span className="truncate">{location}</span>
                            </div>
                            <div className="opacity-0 group-hover:opacity-100 transition duration-500 text-xs font-bold text-[#5E9BF5] flex items-center gap-1">
                                View Details <ArrowRight size={12}/>
                            </div>
                        </div>
                    </div>
                );
            }) : (
                <div className="w-full text-center py-10 text-gray-400">No destinations available.</div>
            )}
        </div>

        {/* TOMBOL KANAN */}
        <button 
            onClick={() => scroll('right')}
            className="flex-shrink-0 w-14 h-14 rounded-full bg-[#1F2937] text-white flex items-center justify-center shadow-lg hover:bg-[#5E9BF5] transition duration-300 active:scale-95 hidden md:flex"
        >
            <ArrowRight size={24} />
        </button>

      </div>
    </div>
  );
}
