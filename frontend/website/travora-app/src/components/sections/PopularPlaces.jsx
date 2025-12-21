import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';
import { api } from '../../api'; // Pastikan path api benar
import PlaceCard from '../cards/PlaceCard';

export default function PopularPlaces() {
  const navigate = useNavigate();
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDestinations = async () => {
      try {
        // PANGGIL ENDPOINT GO: /destinations
        const res = await api.get('/destinations');
        
        // Handle struktur response Go (bisa array langsung atau obj {data: []})
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        
        // Ambil 4 - 8 data saja untuk ditampilkan di Home
        setDestinations(data.slice(0, 8));
      } catch (err) {
        console.error("Gagal ambil destinasi:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchDestinations();
  }, []);

  if (loading) {
    return (
      <div className="py-20 text-center animate-pulse">
        <div className="w-12 h-12 bg-gray-200 rounded-full mx-auto mb-4"></div>
        <p className="text-gray-400">Loading destinations...</p>
      </div>
    );
  }

  // Jika tidak ada data
  if (destinations.length === 0) return null;

  return (
    <div className="flex flex-col gap-10">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
           <div className="w-2 h-10 bg-black rounded-full"></div>
           <h2 className="text-4xl font-bold text-gray-900">Popular Destinations</h2>
        </div>
        <button 
            onClick={() => navigate('/explore')} // Atau halaman list lengkap
            className="text-[#5E9BF5] font-bold flex items-center gap-2 hover:translate-x-1 transition"
        >
           View All <ArrowRight size={20} />
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
         {destinations.map((item) => (
            <PlaceCard 
                key={item.ID || item.id}
                // Mapping Field dari Golang (NameDestination -> title)
                title={item.NameDestination || item.namedestination || item.title}
                subtitle={item.Location || item.location}
                // Handle Image (bisa string path atau array JSON)
                img={
                    item.Image 
                    || (Array.isArray(item.images) ? item.images[0] : null) 
                    || 'https://via.placeholder.com/400x300'
                }
                rating={item.Rating || "4.8"}
                onPress={() => navigate(`/destination/${item.ID || item.id}`)}
            />
         ))}
      </div>
    </div>
  );
}