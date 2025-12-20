import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { api } from '../api';
import { ArrowLeft, ArrowRight, MapPin, Heart, Star, Camera, Square, User, ShoppingBag, Utensils } from 'lucide-react';

export default function Destination() {
  const { id } = useParams();
  const navigate = useNavigate();
  
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [imgIndex, setImgIndex] = useState(0);
  const [isBookmarked, setIsBookmarked] = useState(false);

  useEffect(() => {
    // 1. CEK TOKEN (WAJIB ADA)
    const token = localStorage.getItem('travora_token');
    
    if (!token) {
        // Jika tidak ada token, paksa user ke halaman Login
        alert("Akses Ditolak: Anda harus Login untuk melihat detail wisata.");
        navigate('/auth');
        return;
    }

    const fetchData = async () => {
      try {
        setLoading(true);

        // 2. AMBIL DETAIL DESTINASI (Endpoint ini butuh Token)
        // Endpoint: /user/destinations/:id
        const resDetail = await api.get(`/user/destinations/${id}`);
        
        // Handle struktur data dari Go (bisa res.data atau res.data.data)
        const destData = resDetail.data.data || resDetail.data;
        setData(destData);

        // 3. CEK STATUS BOOKMARK (Ambil semua favorite, cari ID ini)
        try {
            const resFav = await api.get('/user/favorite');
            const favList = Array.isArray(resFav.data) ? resFav.data : (resFav.data.data || []);
            
            // Cek apakah ID wisata ini ada di daftar favorite user
            // Kita pakai "==" agar aman (string vs number)
            const found = favList.some(item => 
                (item.ID || item.id_destination || item.id) == id
            );
            setIsBookmarked(found);

        } catch (err) {
            console.error("Gagal cek status bookmark:", err);
        }

      } catch (err) {
        console.error("Gagal ambil data wisata:", err);
        
        // Jika Error 401/403 (Unauthorized/Forbidden) -> Token Expired/Salah Role
        if (err.response && (err.response.status === 401 || err.response.status === 403)) {
            localStorage.removeItem('travora_token'); // Hapus token rusak
            alert("Sesi Login Berakhir atau Anda tidak memiliki akses. Silakan login ulang.");
            navigate('/auth');
        }
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [id, navigate]);

  // --- HANDLE TOMBOL LOVE ---
  const handleBookmark = async () => {
    // UI Update Duluan (Optimistic)
    const oldState = isBookmarked;
    setIsBookmarked(!isBookmarked);

    try {
        if (oldState === true) {
            // HAPUS (DELETE)
            await api.delete(`/user/favorite/${id}`);
            console.log("Bookmark dihapus");
        } else {
            // TAMBAH (POST)
            await api.post('/user/favorite', {
                destination_id: parseInt(id) // Pastikan dikirim sebagai angka
            });
            console.log("Bookmark ditambahkan");
        }
    } catch (err) {
        // Jika gagal, kembalikan warna tombol
        setIsBookmarked(oldState);
        console.error("Gagal Bookmark:", err);
        alert(`Gagal menyimpan: ${err.response?.data?.error || "Server Error"}`);
    }
  };

  // Logic Slider Gambar
  const nextImage = () => setImgIndex((prev) => (prev === (getImageArray().length || 1) - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? (getImageArray().length || 1) - 1 : prev - 1));

  // Helper Gambar Aman (Biar gak error kalau gambar kosong)
  const getImageArray = () => {
      if (!data) return [];
      if (Array.isArray(data.images)) return data.images;
      if (typeof data.Image === 'string') return [data.Image];
      return ['https://via.placeholder.com/1200x500'];
  };

  const images = getImageArray();

  // --- TAMPILAN LOADING ---
  if (loading) return (
    <div className="min-h-screen flex items-center justify-center pt-20 bg-gray-50">
        <div className="text-center animate-pulse">
            <div className="w-16 h-16 bg-gray-300 rounded-full mx-auto mb-4"></div>
            <p className="text-gray-400 font-bold">Memuat Data Wisata...</p>
        </div>
    </div>
  );

  // --- TAMPILAN JIKA DATA KOSONG / ERROR ---
  if (!data) return <div className="min-h-screen pt-40 text-center">Data tidak ditemukan.</div>;

  // Fallback nama field (Jaga-jaga beda penulisan di Backend Go)
  const title = data.NameDestination || data.namedestination || data.title;
  const location = data.Location || data.location;
  const description = data.Description || data.description;
  const price = data.Price || data.price;

  return (
    <div className="w-full animate-fade-in pb-20 bg-[#FAFAFA]">
      {/* Hero Image */}
      <div className="h-[500px] relative w-full group">
        <img 
            src={images[imgIndex] || 'https://via.placeholder.com/1200x500'} 
            className="w-full h-full object-cover brightness-[0.6] transition-all duration-500" 
            alt="Hero" 
        />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 text-center md:text-left">
            <h1 className="text-4xl md:text-6xl font-bold text-white tracking-tight drop-shadow-lg">
                {title}
            </h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-16">
        {/* Breadcrumb */}
        <div className="flex items-center gap-3 mb-8 text-lg font-medium text-gray-500">
          <span className="text-[#82B1FF] cursor-pointer hover:underline" onClick={() => navigate('/profile')}>Dashboard</span> 
          <ArrowRight size={20} /> 
          <span className="text-gray-900 font-semibold truncate">{title}</span>
        </div>

        {/* Gallery Slider */}
        <div className="relative w-full h-[400px] md:h-[600px] rounded-[40px] overflow-hidden mb-12 shadow-2xl group bg-gray-200">
          <img src={images[imgIndex]} className="w-full h-full object-cover" alt="Gallery" />
          
          {images.length > 1 && (
              <div className="absolute bottom-10 left-0 right-0 flex justify-center gap-8">
                 <button onClick={prevImage} className="bg-white/20 backdrop-blur-md px-6 py-3 rounded-full text-white hover:bg-white hover:text-black transition flex items-center gap-2">
                    <ArrowLeft size={18} /> Prev
                 </button>
                 <button onClick={nextImage} className="bg-white/20 backdrop-blur-md px-6 py-3 rounded-full text-white hover:bg-white hover:text-black transition flex items-center gap-2">
                    Next <ArrowRight size={18} />
                 </button>
              </div>
          )}
        </div>

        <div className="flex flex-col lg:flex-row gap-20">
          {/* KONTEN KIRI */}
          <div className="lg:w-2/3 space-y-12">
            
            {/* Header + Love Button */}
            <div className="flex justify-between items-start">
                <div>
                    <h1 className="text-3xl md:text-5xl font-bold text-gray-900 mb-4">{title}</h1>
                    <div className="flex items-center text-gray-500 text-lg gap-2">
                        <MapPin size={24} className="text-[#5E9BF5]" />
                        <span>{location}</span>
                    </div>
                </div>
                
                <button 
                    onClick={handleBookmark}
                    className="p-4 rounded-full bg-white shadow-lg border border-gray-100 hover:scale-110 transition active:scale-95 group"
                    title={isBookmarked ? "Hapus dari Favorit" : "Simpan ke Favorit"}
                >
                    <Heart 
                        size={32} 
                        className={`transition duration-300 ${isBookmarked ? 'fill-[#EF685B] text-[#EF685B]' : 'text-gray-300 group-hover:text-[#EF685B]'}`} 
                    />
                </button>
            </div>

            <p className="text-gray-600 text-xl leading-relaxed font-light whitespace-pre-line">
                {description || "Tidak ada deskripsi tersedia."}
            </p>
            
            {/* Fasilitas */}
            <div className="space-y-6">
                <h3 className="text-2xl font-bold text-gray-900">Facilities</h3>
                <div className="grid grid-cols-5 gap-4 bg-white p-8 rounded-3xl border border-gray-100 shadow-sm">
                    <IconCol icon={<Camera size={24} />} label="Photo" />
                    <IconCol icon={<Square size={24} />} label="Parking" />
                    <IconCol icon={<User size={24} />} label="Guide" />
                    <IconCol icon={<ShoppingBag size={24} />} label="Shop" />
                    <IconCol icon={<Utensils size={24} />} label="Food" />
                </div>
            </div>

            {/* Tiket Masuk */}
            <div className="border border-gray-200 rounded-3xl p-8 shadow-lg bg-white relative overflow-hidden flex flex-col md:flex-row justify-between items-center gap-6">
                <div className="absolute top-0 right-0 bg-[#EBC136] text-white px-4 py-1 rounded-bl-2xl font-bold text-xs uppercase">Best Value</div>
                <div>
                    <p className="text-sm text-gray-400 font-bold uppercase tracking-widest mb-1">Entrance Ticket</p>
                    <p className="text-4xl font-extrabold text-[#EBC136]">
                        {price ? `IDR ${parseInt(price).toLocaleString('id-ID')}` : 'Free'}
                    </p>
                </div>
                <button className="bg-[#5E9BF5] text-white px-10 py-4 rounded-2xl font-bold hover:bg-[#4a90e2] transition shadow-lg shadow-blue-200 w-full md:w-auto">
                    Book Now
                </button>
            </div>
          </div>

          {/* SIDEBAR KANAN */}
          <div className="lg:w-1/3 flex flex-col gap-8">
             {/* Maps */}
             <div className="bg-white p-4 rounded-[32px] shadow-xl border border-gray-100">
                <div className="w-full h-[250px] rounded-2xl bg-gray-200 relative overflow-hidden group">
                   <iframe 
                        width="100%" height="100%" 
                        src="https://maps.google.com/maps?q=Bali&t=&z=13&ie=UTF8&iwloc=&output=embed" 
                        className="grayscale group-hover:grayscale-0 transition duration-500 absolute inset-0" 
                        title="map"
                   ></iframe>
                </div>
                <a 
                    href={`https://www.google.com/maps/search/?api=1&query=$${encodeURIComponent(location)}`} 
                    target="_blank" 
                    rel="noreferrer"
                    className="w-full bg-gray-50 text-gray-800 font-bold py-4 mt-4 rounded-2xl flex justify-center items-center gap-2 hover:bg-[#EBC136] hover:text-white transition"
                >
                    <MapPin size={20} /> Open Google Maps
                </a>
             </div>

             {/* Review Score */}
             <div className="bg-white p-8 rounded-[32px] shadow-xl border border-gray-100 text-center">
                <h3 className="text-2xl font-bold mb-2 text-gray-900">User Reviews</h3>
                <div className="text-6xl font-extrabold text-[#EBC136] mb-2">4.9</div>
                <div className="flex justify-center mb-6 gap-1">
                    {[...Array(5)].map((_,i)=><Star key={i} size={20} fill="#EBC136" stroke="none"/>)}
                </div>
                <button className="w-full border-2 border-[#82B1FF] text-[#82B1FF] font-bold py-3 rounded-xl hover:bg-[#82B1FF] hover:text-white transition">
                    Write a Review
                </button>
             </div>
          </div>
        </div>
      </div>
    </div>
  );
}

const IconCol = ({ icon, label }) => (
  <div className="flex flex-col items-center gap-2 text-gray-400 hover:text-[#5E9BF5] transition duration-300 cursor-pointer p-2">
    <div className="p-3 bg-gray-50 rounded-full">{icon}</div>
    <p className="text-xs font-bold uppercase tracking-wide">{label}</p>
  </div>
);