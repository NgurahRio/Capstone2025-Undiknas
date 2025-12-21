import React, { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight, MapPin, Star } from 'lucide-react';
import { api } from '../../api';

export default function PopularPlaces() {
  const navigate = useNavigate();
  const sliderRef = useRef(null);
  const [destinations, setDestinations] = useState([]);
  const [loading, setLoading] = useState(true);

  // 1. FETCH DATA
  useEffect(() => {
    const fetchDestinations = async () => {
      try {
        const res = await api.get('/destinations');
        // Handle struktur response Go
        const data = Array.isArray(res.data) ? res.data : (res.data.data || []);
        setDestinations(data);
      } catch (err) {
        console.error("Gagal load destinasi:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchDestinations();
  }, []);

  // 2. FUNGSI SCROLL
  const scroll = (direction) => {
    if (sliderRef.current) {
      const { current } = sliderRef;
      const scrollAmount = 270; // 250px card + 20px gap
      if (direction === 'left') {
        current.scrollBy({ left: -scrollAmount, behavior: 'smooth' });
      } else {
        current.scrollBy({ left: scrollAmount, behavior: 'smooth' });
      }
    }
  };

  // 3. FUNGSI PROSES GAMBAR DARI DB (BASE64)
  const processImage = (item) => {
    // Ambil field dari database: 'imagedata'
    let raw = item.imagedata || item.Image;

    if (!raw) return ""; // Jangan return placeholder jika kosong

    try {
      // Cek apakah formatnya JSON Array string: '["/9j/4AAQ..."]'
      if (typeof raw === 'string' && raw.trim().startsWith('[')) {
        const parsed = JSON.parse(raw);
        if (Array.isArray(parsed) && parsed.length > 0) {
          raw = parsed[0]; // Ambil elemen pertama
        }
      }
    } catch (e) {
      console.log("Error parsing image JSON:", e);
    }

    // Jika string adalah Base64 (tidak ada http/https), tambahkan prefix
    if (raw && !raw.startsWith('http') && !raw.startsWith('data:')) {
      return `data:image/jpeg;base64,${raw}`;
    }

    return raw;
  };

  if (loading) return <div className="h-[360px] bg-gray-100 rounded-[32px] animate-pulse"></div>;

  return (
    <div className="flex flex-col lg:flex-row gap-6 items-center w-full py-8">
      
      {/* --- BAGIAN KIRI: JUDUL --- */}
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

      {/* --- BAGIAN KANAN: SLIDER DIAPIT TOMBOL --- */}
      <div className="lg:w-3/4 w-full flex items-center gap-5">
        
        {/* TOMBOL KIRI (STATIS) */}
        <button 
            onClick={() => scroll('left')}
            className="flex-shrink-0 w-14 h-14 rounded-full border border-gray-300 bg-white flex items-center justify-center text-gray-600 hover:bg-[#5E9BF5] hover:text-white hover:border-[#5E9BF5] transition duration-300 active:scale-95 shadow-sm"
        >
            <ArrowLeft size={24} />
        </button>

        {/* AREA SLIDER */}
        <div 
            ref={sliderRef}
            className="flex-1 flex gap-5 overflow-x-auto py-4 px-2 hide-scrollbar snap-x snap-mandatory scroll-smooth"
            style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
        >
            {destinations.length > 0 ? destinations.map((item) => {
                // Proses Data
                const imageUrl = processImage(item);
                const title = item.namedestination || item.name || "Unknown";
                const location = item.location || "Bali";

                return (
                    <div 
                        key={item.id_destination || item.ID}
                        onClick={() => navigate(`/destination/${item.id_destination || item.ID}`)}
                        // KUNCI LEBAR KARTU DI SINI:
                        // w-[250px] : Lebar fix
                        // min-w-[250px]: Tidak boleh menyusut
                        // flex-shrink-0: Mencegah kartu gepeng/melebar
                        className="w-[250px] min-w-[250px] h-[360px] relative rounded-[32px] overflow-hidden cursor-pointer snap-start shadow-md hover:shadow-xl transition-all duration-300 hover:-translate-y-2 group flex-shrink-0"
                    >
                        {/* GAMBAR */}
                        <img 
                            src={imageUrl} 
                            className="w-full h-full object-cover group-hover:scale-110 transition duration-700 ease-in-out" 
                            alt={title} 
                            // Error handling jika base64 corrupt
                            onError={(e) => { e.target.style.display = 'none'; }} 
                        />
                        
                        {/* GRADIENT OVERLAY (Hitam Pudar di Bawah) */}
                        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-90"></div>

                        {/* RATING */}
                        <div className="absolute top-4 right-4 bg-white/20 backdrop-blur-md border border-white/20 px-3 py-1 rounded-full flex items-center gap-1 shadow-sm">
                            <Star size={12} fill="#FFD700" stroke="none" />
                            <span className="text-white font-bold text-xs">4.8</span>
                        </div>

                        {/* TEXT INFO */}
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

        {/* TOMBOL KANAN (STATIS) */}
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