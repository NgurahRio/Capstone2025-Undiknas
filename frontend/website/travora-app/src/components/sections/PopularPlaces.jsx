import React, { useState, useEffect, useRef } from 'react';
import { ArrowLeft, ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api';
import PlaceCard from '../cards/PlaceCard';

export default function PopularPlaces() {
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);
  const scrollRef = useRef(null);
  const navigate = useNavigate();

  // Ambil Data
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Endpoint Go
        const res = await api.get('/user/destinations');
        console.log("Popular Places Data:", res.data); // Cek Console untuk lihat nama field asli

        const dataList = Array.isArray(res.data) ? res.data : (res.data.data || []);
        setDestinations(dataList);

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
    <div className="flex flex-col lg:flex-row gap-16 items-center animate-fade-in">
      <div className="lg:w-1/3 space-y-6 text-center lg:text-left">
        <h2 className="text-5xl font-bold leading-tight text-gray-900">
            Popular Place <br /> <span className="text-[#5E9BF5]">Now</span>
        </h2>
        <p className="text-gray-500 text-lg leading-relaxed">
            Discover the most popular travel spots in Bali right now directly from our database.
        </p>
      </div>
      
      <div className="lg:w-2/3 w-full flex items-center gap-6 relative group">
        <button onClick={() => scroll(-320)} className="hidden md:flex w-14 h-14 rounded-full border-2 border-[#5E9BF5] text-[#5E9BF5] bg-white items-center justify-center hover:bg-blue-50 transition shadow-lg flex-shrink-0 z-10 absolute -left-7 lg:static">
          <ArrowLeft size={24} />
        </button>

        <div ref={scrollRef} className="flex gap-6 overflow-x-auto hide-scrollbar py-6 px-2 snap-x w-full scroll-smooth">
          {loading ? (
             <div className="w-full text-center py-20 text-gray-400 animate-pulse">Loading database...</div>
          ) : destinations.length === 0 ? (
             <div className="w-full text-center py-20 border-2 border-dashed border-gray-200 rounded-3xl">
                <p className="text-gray-400 font-bold">No Data Found</p>
             </div>
          ) : (
             destinations.map((item) => {
                
                // === PERBAIKAN UTAMA DI SINI ===
                // Kita coba semua kemungkinan nama ID dari database/Go
                const finalId = item.id_destination || item.IdDestination || item.ID || item.id;
                
                return (
                    <PlaceCard 
                       key={finalId} // Gunakan ID yang sudah diperbaiki
                       
                       // Nama Field (Destination Name)
                       title={item.NameDestination || item.namedestination || item.name_destination || item.title}
                       
                       // Lokasi
                       subtitle={item.Location || item.location}
                       
                       // Gambar
                       img={item.Image || (Array.isArray(item.images) ? item.images[0] : null) || 'https://via.placeholder.com/300'}
                       
                       rating="4.8"
                       
                       // Link Navigasi (Pastikan finalId tidak undefined)
                       onPress={() => {
                           if (finalId) {
                               navigate(`/destination/${finalId}`);
                           } else {
                               console.error("ID Destinasi tidak ditemukan di objek ini:", item);
                               alert("Error: ID Destinasi tidak valid (Cek Console)");
                           }
                       }}
                    />
                );
            })
          )}
        </div>

        <button onClick={() => scroll(320)} className="hidden md:flex w-14 h-14 rounded-full bg-[#5E9BF5] border-2 border-[#5E9BF5] text-white items-center justify-center hover:bg-[#4a90e2] transition shadow-lg flex-shrink-0 z-10 absolute -right-7 lg:static">
          <ArrowRight size={24} />
        </button>
      </div>
    </div>
  );
}