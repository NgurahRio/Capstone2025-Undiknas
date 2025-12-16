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
  
  // State Bookmark
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [userId, setUserId] = useState(null);

  useEffect(() => {
    // 1. Ambil User ID dari LocalStorage
    const storedUser = localStorage.getItem('travora_user');
    let currentUserId = null;

    if (storedUser) {
        try {
            const parsed = JSON.parse(storedUser);
            // Ambil id_users (sesuai database SQL Anda)
            const theId = parsed.id_users || parsed.id; 
            
            if (theId) {
                setUserId(theId);
                currentUserId = theId;
                console.log("User detected for bookmark:", theId);
            }
        } catch (e) {
            console.error("Error parsing user data", e);
        }
    }

    // 2. Fetch Detail Wisata & Status Bookmark
    const fetchDetail = async () => {
      try {
        const res = await api.get(`/destinations/${id}`);
        setData(res.data);

        // Cek status bookmark jika user sudah login
        if (currentUserId) {
            try {
                const checkRes = await api.get(`/bookmarks/check/${currentUserId}/${id}`);
                console.log("Status Bookmark Awal:", checkRes.data.isBookmarked);
                setIsBookmarked(checkRes.data.isBookmarked);
            } catch (err) {
                console.error("Gagal cek status bookmark", err);
            }
        }
      } catch (err) {
        console.error("Gagal ambil detail:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchDetail();
  }, [id]);

  // Handle Klik Love
const handleBookmark = async () => {
    // 1. Cek apakah User ID ada?
    if (!userId) {
        alert("STOP: User ID tidak ditemukan. Anda belum login atau login expired.");
        navigate('/auth');
        return;
    }

    // Optimistic Update (Ubah warna dulu biar cepat)
    const oldState = isBookmarked;
    setIsBookmarked(!isBookmarked);

    try {
        // 3. Kirim Request
        console.log("Sending request to /bookmarks/toggle...");
        
        const response = await api.post('/bookmarks/toggle', {
            userId: userId,
            destinationId: id
        });

        // 4. Jika berhasil
        console.log("Response dari server:", response.data);
        // alert(`SUKSES: ${response.data.message}`); // Aktifkan jika ingin lihat popup sukses
        
    } catch (err) {
        // 5. Jika Gagal
        console.error("ERROR AXIOS:", err);
        setIsBookmarked(oldState); // Balikin warna
        
        // Cek detail error
        if (err.code === "ERR_NETWORK") {
            alert("GAGAL KONEKSI: Backend mati atau Port salah. Cek terminal 'node server.js'!");
        } else {
            alert(`GAGAL SAVE: ${err.response?.data?.message || err.message}`);
        }
    }
  };

  const nextImage = () => setImgIndex((prev) => (prev === (data?.images?.length || 1) - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? (data?.images?.length || 1) - 1 : prev - 1));

  if (loading) return <div className="min-h-screen flex items-center justify-center pt-20">Loading Destination...</div>;
  if (!data) return <div className="min-h-screen flex items-center justify-center pt-20">Destination Not Found.</div>;

  return (
    <div className="w-full animate-fade-in pb-20 bg-[#FAFAFA]">
      {/* Hero Slider */}
      <div className="h-[500px] relative w-full group">
        <img 
            src={data.images && data.images.length > 0 ? data.images[imgIndex] : 'https://via.placeholder.com/1200x500'} 
            className="w-full h-full object-cover brightness-[0.6] transition-all duration-500" 
            alt="Hero" 
        />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-4xl md:text-6xl font-bold text-white tracking-tight">Destination Detail</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-16">
        {/* Breadcrumb */}
        <div className="flex items-center gap-3 mb-6 text-xl font-medium text-gray-500">
          <span className="text-[#82B1FF] cursor-pointer hover:underline" onClick={() => navigate('/')}>Home</span> 
          <ArrowRight size={20} /> 
          <span className="text-gray-900 font-semibold">{data.title}</span>
        </div>

        {/* Gallery Preview */}
        <div className="relative w-full h-[400px] md:h-[600px] rounded-[40px] overflow-hidden mb-12 shadow-2xl group bg-gray-200">
          <img src={data.images[imgIndex]} className="w-full h-full object-cover transition-transform duration-700" alt="Gallery" />
          
          {data.images.length > 1 && (
              <div className="absolute bottom-10 left-0 right-0 flex justify-center gap-8">
                 <button onClick={prevImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition">
                   <ArrowLeft size={20} /> Back
                 </button>
                 <button onClick={nextImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition">
                   Next <ArrowRight size={20} />
                 </button>
              </div>
          )}
        </div>

        <div className="flex flex-col lg:flex-row gap-20">
          {/* Main Content */}
          <div className="lg:w-2/3 space-y-12">
            <div>
              <div className="flex justify-between items-start mb-6">
                <h1 className="text-4xl md:text-5xl font-bold text-gray-900 leading-tight">{data.title}</h1>
                
                {/* TOMBOL LOVE */}
                <button 
                    onClick={handleBookmark}
                    className="p-3 rounded-full hover:bg-gray-100 transition shadow-sm border border-gray-100 group"
                    title={isBookmarked ? "Remove from Bookmark" : "Add to Bookmark"}
                >
                    <Heart 
                        size={40} 
                        className={`transition duration-300 ${isBookmarked ? 'fill-[#EF685B] text-[#EF685B]' : 'text-gray-300 group-hover:text-[#EF685B]'}`} 
                    />
                </button>
              </div>
              <div className="flex items-center text-gray-500 text-lg gap-2">
                <MapPin size={24} className="text-[#5E9BF5]" />
                <span>{data.location}</span>
              </div>
            </div>

            <p className="text-gray-600 text-xl leading-relaxed font-light whitespace-pre-line">
              {data.description || "Deskripsi belum tersedia untuk tempat ini."}
            </p>

            {/* --- POSISI DITUKAR: Facilities DULUAN --- */}
            
            {/* Facilities */}
            <div className="space-y-6">
              <h3 className="text-3xl font-bold text-gray-900">Facilities</h3>
              <div className="grid grid-cols-5 gap-4 bg-gray-50 p-8 rounded-3xl border border-gray-100">
                <IconCol icon={<Camera size={28} />} label="Photo" />
                <IconCol icon={<Square size={28} />} label="Parking" />
                <IconCol icon={<User size={28} />} label="Guide" />
                <IconCol icon={<ShoppingBag size={28} />} label="Shop" />
                <IconCol icon={<Utensils size={28} />} label="Food" />
              </div>
            </div>

            {/* Entrance Ticket (Price Card) - Sekarang di Bawah Facilities */}
            <div className="border border-gray-200 rounded-3xl p-10 shadow-lg bg-white relative overflow-hidden">
                <div className="absolute top-0 right-0 bg-[#EBC136] text-white px-4 py-2 rounded-bl-2xl font-bold text-xs">BEST VALUE</div>
                <h4 className="text-2xl font-bold mb-6 text-gray-900">Entrance Ticket</h4>
                <div className="flex flex-col md:flex-row justify-between items-center gap-4">
                  <div>
                      <p className="text-sm text-gray-400">Estimate Price</p>
                      <p className="text-4xl font-bold text-[#EBC136]">
                        {data.price ? `IDR ${parseInt(data.price).toLocaleString('id-ID')}` : 'Free'}
                      </p>
                  </div>
                  <button className="bg-[#5E9BF5] text-white px-8 py-4 w-full md:w-auto rounded-xl font-bold hover:opacity-90 transition shadow-lg shadow-blue-200">Book Now</button>
                </div>
            </div>

          </div>

          {/* Right Sidebar (MAPS & REVIEWS) */}
          <div className="lg:w-1/3 flex flex-col gap-10">
            
            {/* MAP PLACEHOLDER */}
            <div className="bg-white p-4 rounded-[32px] shadow-xl border border-gray-100">
              <div className="w-full h-[300px] rounded-2xl overflow-hidden bg-gray-200 relative group">
                <iframe 
                  width="100%" 
                  height="100%" 
                  frameBorder="0" 
                  scrolling="no" 
                  // Menggunakan Embed generic Google Maps agar tidak blank
                  src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3944.209664687576!2d115.26066231478403!3d-8.514083993880314!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2dd23d739f22c9c3%3A0x54a38573d1f69208!2sUbud%2C%20Gianyar%20Regency%2C%20Bali!5e0!3m2!1sen!2sid!4v1645512345678!5m2!1sen!2sid"
                  title="Map" 
                  className="absolute inset-0 grayscale group-hover:grayscale-0 transition duration-500"
                ></iframe>
              </div>
              
              {/* Link yang BENAR ke Google Maps Search */}
              <a 
                href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(data.location)}`} 
                target="_blank" 
                rel="noreferrer"
                className="w-full bg-gray-100 text-gray-800 font-bold py-4 mt-4 rounded-xl hover:bg-gray-200 transition text-lg flex justify-center items-center gap-2"
              >
                <MapPin size={20} /> Open in Google Maps
              </a>
            </div>

            {/* Reviews */}
            <div className="bg-white p-8 rounded-[32px] shadow-xl border border-gray-100 text-center">
              <h3 className="text-3xl font-bold mb-2 text-gray-900">Reviews</h3>
              <div className="text-7xl font-bold text-[#EBC136] mb-2 tracking-tighter">4.9</div>
              <div className="flex justify-center gap-1 text-[#EBC136] mb-4">
                {[...Array(5)].map((_, i) => <Star key={i} size={24} fill="#EBC136" stroke="none" />)}
              </div>
              <p className="text-gray-400 text-sm mb-8 font-medium">Based on verified visitors</p>
              <button className="w-full border-2 border-[#82B1FF] text-[#82B1FF] font-bold py-3 rounded-xl hover:bg-[#82B1FF] hover:text-white transition">Write a Review</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

const IconCol = ({ icon, label }) => (
  <div className="flex flex-col items-center gap-2 text-gray-800 hover:-translate-y-1 transition duration-300 cursor-pointer p-2 rounded-xl hover:bg-white">
    <div className="text-gray-800">{icon}</div>
    <p className="text-xs md:text-sm font-semibold text-gray-500">{label}</p>
  </div>
);