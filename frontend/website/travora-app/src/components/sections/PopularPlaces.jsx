import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api'; // Pastikan path ini benar
import PlaceCard from '../cards/PlaceCard';

export default function PopularPlaces() {
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);
  const scrollRef = useRef(null);
  const navigate = useNavigate();

  // Ambil Data dari Database
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await api.get('/destinations');
        if (Array.isArray(res.data)) {
            setDestinations(res.data);
        }
      } catch (err) {
        console.error("Error fetching popular places:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const scroll = (offset) => {
    scrollRef.current?.scrollBy({ left: offset, behavior: 'smooth' });
  };

  return (
    <div className="flex flex-col lg:flex-row gap-16 items-center">
      {/* Kolom Kiri: Teks */}
      <div className="lg:w-1/3 space-y-6 text-center lg:text-left">
        <h2 className="text-5xl font-bold leading-tight text-gray-900">
            Popular Place <br /> <span className="text-[#5E9BF5]">Now</span>
        </h2>
        <p className="text-gray-500 text-lg leading-relaxed">
            Discover the most popular travel spots in Bali right now directly from our database.
        </p>
      </div>
      
      {/* Kolom Kanan: Slider */}
      <div className="lg:w-2/3 w-full flex items-center gap-6 relative group">
        
        {/* Tombol Kiri */}
        <button onClick={() => scroll(-320)} className="hidden md:flex w-14 h-14 rounded-full border-2 border-[#5E9BF5] text-[#5E9BF5] bg-white items-center justify-center hover:bg-blue-50 transition shadow-lg flex-shrink-0 z-10 absolute -left-7 lg:static">
          <ArrowLeft size={24} />
        </button>

        {/* Container Scroll */}
        <div ref={scrollRef} className="flex gap-6 overflow-x-auto hide-scrollbar py-6 px-2 snap-x w-full scroll-smooth">
          {loading ? (
             <div className="w-full text-center py-20 text-gray-400">Loading database...</div>
          ) : destinations.length === 0 ? (
             <div className="w-full text-center py-20 text-gray-400">No data found in database.</div>
          ) : (
             destinations.map((item) => (
                <PlaceCard 
                    key={item.id}
                    title={item.title}
                    subtitle={item.location}
                    img={item.img}
                    rating="4.8" // Nanti bisa ambil dari DB kolom 'rating'
                    onPress={() => navigate('/destination')}
                />
             ))
          )}
        </div>

        {/* Tombol Kanan */}
        <button onClick={() => scroll(320)} className="hidden md:flex w-14 h-14 rounded-full bg-[#5E9BF5] border-2 border-[#5E9BF5] text-white items-center justify-center hover:bg-[#4a90e2] transition shadow-lg flex-shrink-0 z-10 absolute -right-7 lg:static">
          <ArrowRight size={24} />
        </button>
      </div>
    </div>
  );
}