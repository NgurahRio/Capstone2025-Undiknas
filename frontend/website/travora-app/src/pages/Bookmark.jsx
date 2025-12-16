import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Lock, MapPin } from 'lucide-react';
import { api } from '../api';
import PlaceCard from '../components/cards/PlaceCard'; 

export default function Bookmark() {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [bookmarks, setBookmarks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // 1. Cek apakah ada data user di LocalStorage
    const storedUser = localStorage.getItem('travora_user');
    
    if (!storedUser) {
        setLoading(false);
        return; 
    }

    const parsedUser = JSON.parse(storedUser);
    setUser(parsedUser);

    // Ambil ID yang benar (id_users)
    const userId = parsedUser.id_users || parsedUser.id;

    if (!userId) {
        console.error("ID User tidak ditemukan di data login");
        setLoading(false);
        return;
    }

    // 2. Ambil data bookmark dari backend
    const fetchBookmarks = async () => {
        try {
            console.log("Mengambil bookmark untuk User ID:", userId);
            const res = await api.get(`/bookmarks/${userId}`);
            console.log("Data Bookmark diterima:", res.data); // Cek console browser
            setBookmarks(res.data);
        } catch (err) {
            console.error("Gagal load bookmark", err);
        } finally {
            setLoading(false);
        }
    };
    fetchBookmarks();
  }, []);

  // --- RENDER ---

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
                    <button onClick={() => navigate('/auth')} className="bg-[#82B1FF] text-white px-10 py-4 rounded-full font-bold hover:bg-[#6fa5ff] transition shadow-lg shadow-blue-200">
                        Login Now
                    </button>
                </div>
           </div>
        </div>
    );
  }

  // 2. Loading State
  if (loading) {
    return (
        <div className="min-h-screen pt-40 text-center">
            <p className="text-gray-400 text-lg animate-pulse">Fetching your collection...</p>
        </div>
    );
  }

  // 3. Tampilan Utama
  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Header Image */}
      <div className="h-[400px] relative w-full">
        <img src="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200" className="w-full h-full object-cover brightness-50" alt="Book Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-5xl md:text-6xl font-bold text-white">My Bookmarks</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <div className="flex items-center justify-between mb-8">
            <h2 className="text-[#82B1FF] text-xl font-bold uppercase tracking-wide">Saved Destinations</h2>
            <span className="bg-gray-100 text-gray-600 px-4 py-1 rounded-full text-sm font-bold border border-gray-200">
                {bookmarks.length} Items
            </span>
        </div>
        <div className="h-[1px] bg-gray-200 w-full mb-12"></div>

        {/* Jika Bookmark Kosong */}
        {bookmarks.length === 0 ? (
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
           /* Jika Ada Data */
           <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              {bookmarks.map((item) => (
                  <PlaceCard 
                    key={item.id} 
                    title={item.title} 
                    subtitle={item.location}
                    img={item.img} 
                    rating="4.9"
                    onPress={() => navigate(`/destination/${item.id}`)} 
                  />
              ))}
           </div>
        )}
      </div>
    </div>
  );
}