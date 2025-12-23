import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Lock, MapPin, Trash2 } from 'lucide-react';
import PlaceCard from '../components/cards/PlaceCard'; 
import api from '../api';

export default function Bookmark() {
  const navigate = useNavigate();
  
  const [user, setUser] = useState(null);
  const [bookmarks, setBookmarks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  const pickImage = (dest) => {
    if (!dest) return '';
    let img = Array.isArray(dest.images) && dest.images.length > 0 ? dest.images[0] : (dest.imagedata || dest.Image || dest.image);
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

  useEffect(() => {
    const storedUser = localStorage.getItem('travora_user');
    const token = localStorage.getItem('travora_token');
    if (storedUser) setUser(JSON.parse(storedUser));

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
        const destinations = res.data?.destinations || [];
        const destMap = {};
        destinations.forEach((d) => {
          const id = d.id_destination || d.id || d.ID || d.destinationId;
          if (id) destMap[String(id)] = d;
        });

        const mapped = favorites
          .map((fav) => {
            const destId = fav.destinationId || fav.destination_id || fav.destinationID;
            const dest = destMap[String(destId)];
            if (!dest) return null;
            return {
              id: destId,
              title: dest.namedestination || dest.NameDestination || dest.name || 'Destination',
              location: dest.location,
              img: pickImage(dest),
              rating: dest.rating || '4.9',
            };
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

  // --- FUNGSI HAPUS ---
  const handleRemove = async (e, idToRemove) => {
    e.stopPropagation(); // Biar gak pindah halaman saat klik tong sampah

    if (window.confirm("Hapus dari bookmark?")) {
        try {
          await api.delete(`/user/favorite/${idToRemove}`);
        } catch (err) {
          console.warn("Gagal hapus di backend, tetap lanjut hapus di UI:", err);
        }
        const updatedBookmarks = bookmarks.filter(item => String(item.id) !== String(idToRemove));
        setBookmarks(updatedBookmarks);
    }
  };

  // --- RENDER TAMPILAN ---

  // 1. Belum Login
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

  // 2. Loading
  if (loading) {
    return (
        <div className="min-h-screen pt-40 text-center">
            <p className="text-gray-400 text-lg animate-pulse">Loading your bookmarks...</p>
        </div>
    );
  }

  // 3. Tampilan Utama (Sukses)
  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Header Image */}
      <div className="h-[350px] relative w-full">
        <img src="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200" className="w-full h-full object-cover brightness-50" alt="Book Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
             <h1 className="text-5xl md:text-6xl font-bold text-white">My Bookmarks</h1>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <div className="flex items-center justify-between mb-8">
            <h2 className="text-[#82B1FF] text-xl font-bold uppercase tracking-wide">Saved Destinations</h2>
            <span className="bg-gray-100 text-gray-600 px-4 py-1 rounded-full text-sm font-bold border border-gray-200">
                {bookmarks.length} Items
            </span>
        </div>
        {error && (
          <div className="mb-4 text-sm text-red-600 bg-red-50 border border-red-100 rounded-xl px-4 py-2">
            {error}
          </div>
        )}
        <div className="h-[1px] bg-gray-200 w-full mb-12"></div>

        {/* LOGIKA ISI KONTEN */}
        {bookmarks.length === 0 ? (
           // Tampilan Kosong
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
           // Tampilan Ada Data
           <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              {bookmarks.map((item) => (
                  <div key={item.id} className="relative group hover:-translate-y-2 transition-transform duration-300">
                      <PlaceCard 
                        title={item.title} 
                        subtitle={item.location}
                        img={item.img} 
                        rating={item.rating || "4.9"}
                        onPress={() => navigate(`/destination/${item.id}`)} 
                      />
                      
                      {/* TOMBOL DELETE (Hanya muncul saat hover) */}
                      <button 
                        onClick={(e) => handleRemove(e, item.id)}
                        className="absolute top-4 right-4 bg-white/90 p-2 rounded-full text-red-400 shadow-md opacity-0 group-hover:opacity-100 transition-opacity hover:bg-red-500 hover:text-white"
                        title="Remove"
                      >
                        <Trash2 size={18} />
                      </button>
                  </div>
              ))}
           </div>
        )}
      </div>
    </div>
  );
}
