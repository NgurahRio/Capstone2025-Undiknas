import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { api } from '../api'; // Pastikan path benar
import { ArrowLeft, ArrowRight, MapPin, Heart, Star, Camera, Square, User, ShoppingBag, Utensils, Check } from 'lucide-react';
import Navbar from '../components/common/Navbar'; // Import Navbar

export default function Destination() {
  const { id } = useParams(); // Ambil ID dari URL
  const navigate = useNavigate();
  
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [imgIndex, setImgIndex] = useState(0);

  useEffect(() => {
    const fetchDetail = async () => {
      try {
        const res = await api.get(`/destinations/${id}`);
        setData(res.data);
      } catch (err) {
        console.error("Gagal ambil detail:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchDetail();
  }, [id]);

  // Fungsi Slider Gambar
  const nextImage = () => setImgIndex((prev) => (prev === data?.images.length - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? data?.images.length - 1 : prev - 1));

  if (loading) return <div className="min-h-screen flex items-center justify-center">Loading Detail...</div>;
  if (!data) return <div className="min-h-screen flex items-center justify-center">Data Wisata Tidak Ditemukan.</div>;

  return (
    <div className="w-full animate-fade-in pb-20 bg-[#FAFAFA]">
      {/* Kita panggil Navbar manual disini jika tidak di App.jsx level atas, 
          tapi karena di App.jsx sudah ada Navbar global, bagian ini opsional. 
          Agar layout rapi, saya asumsikan Navbar global sudah ada. */}

      {/* Hero Image Full Width */}
      <div className="h-[500px] relative w-full group">
        <img src={data.images[0]} className="w-full h-full object-cover brightness-[0.6]" alt="Hero" />
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
        
        {/* Gallery Slider */}
        <div className="relative w-full h-[400px] md:h-[600px] rounded-[40px] overflow-hidden mb-12 shadow-2xl group bg-gray-200">
          <img src={data.images[imgIndex]} className="w-full h-full object-cover transition-transform duration-700" alt="Gallery" />
          
          {/* Tombol Navigasi Gallery hanya muncul jika gambar > 1 */}
          {data.images.length > 1 && (
              <div className="absolute bottom-10 left-0 right-0 flex justify-center gap-8">
                 <button onClick={prevImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition duration-300">
                   <ArrowLeft size={20} /> Back
                 </button>
                 <button onClick={nextImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition duration-300">
                   Next <ArrowRight size={20} />
                 </button>
              </div>
          )}
        </div>

        <div className="flex flex-col lg:flex-row gap-20">
          {/* Left Content */}
          <div className="lg:w-2/3 space-y-12">
            <div>
              <div className="flex justify-between items-start mb-6">
                <h1 className="text-4xl md:text-5xl font-bold text-gray-900 leading-tight">{data.title}</h1>
                <Heart size={40} className="text-gray-300 cursor-pointer hover:fill-[#EF685B] hover:text-[#EF685B] transition flex-shrink-0" />
              </div>
              <div className="flex items-center text-gray-500 text-lg gap-2">
                <MapPin size={24} className="text-[#5E9BF5]" />
                <span>{data.location}</span>
              </div>
            </div>

            <p className="text-gray-600 text-xl leading-relaxed font-light whitespace-pre-line">
              {data.description || "Tidak ada deskripsi tersedia untuk tempat ini."}
            </p>

            {/* Fasilitas (Static Mockup - bisa didinamiskan nanti) */}
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

            {/* Ticket Info */}
            <div className="border border-gray-200 rounded-3xl p-10 shadow-lg bg-white relative overflow-hidden">
                <div className="absolute top-0 right-0 bg-[#EBC136] text-white px-4 py-2 rounded-bl-2xl font-bold text-xs">BEST VALUE</div>
                <h4 className="text-2xl font-bold mb-6 text-gray-900">Entrance Ticket</h4>
                <ul className="space-y-4 mb-8 text-gray-600 text-base">
                  <li className="flex items-center gap-4"><div className="bg-[#82B1FF] rounded-full p-1.5 shadow-sm"><Check size={14} className="text-white" strokeWidth={4} /></div> Access to all areas</li>
                  <li className="flex items-center gap-4"><div className="bg-[#82B1FF] rounded-full p-1.5 shadow-sm"><Check size={14} className="text-white" strokeWidth={4} /></div> Insurance included</li>
                </ul>
                <div className="my-6 border-t border-gray-100"></div>
                <div className="flex flex-col md:flex-row justify-between items-center gap-4">
                  <div>
                      <p className="text-sm text-gray-400">Starts form</p>
                      <p className="text-4xl font-bold text-[#EBC136]">IDR {data.price ? parseInt(data.price).toLocaleString('id-ID') : 'Free'}</p>
                  </div>
                  <button className="bg-[#5E9BF5] text-white px-8 py-4 w-full md:w-auto rounded-xl font-bold hover:opacity-90 transition shadow-lg shadow-blue-200">Book Now</button>
                </div>
            </div>
          </div>

          {/* Right Sidebar */}
          <div className="lg:w-1/3 flex flex-col gap-10">
            {/* Map Placeholder */}
            <div className="bg-white p-4 rounded-[32px] shadow-xl border border-gray-100">
              <div className="w-full h-[300px] rounded-2xl overflow-hidden bg-gray-200 relative group flex items-center justify-center">
                 <span className="text-gray-500 font-semibold flex items-center gap-2"><MapPin/> Map View</span>
                 {/* Anda bisa pasang iframe Google Maps sungguhan disini */}
              </div>
              <button className="w-full bg-gray-100 text-gray-800 font-bold py-4 mt-4 rounded-xl hover:bg-gray-200 transition text-lg flex justify-center items-center gap-2">
                <MapPin size={20} /> Open in Google Maps
              </button>
            </div>

            {/* Reviews */}
            <div className="bg-white p-8 rounded-[32px] shadow-xl border border-gray-100 text-center">
              <h3 className="text-3xl font-bold mb-2 text-gray-900">Reviews</h3>
              <div className="text-7xl font-bold text-[#EBC136] mb-2 tracking-tighter">4.8</div>
              <div className="flex justify-center gap-1 text-[#EBC136] mb-4">
                {[...Array(5)].map((_, i) => <Star key={i} size={24} fill="#EBC136" stroke="none" />)}
              </div>
              <p className="text-gray-400 text-sm mb-8 font-medium">Verified Reviews</p>
              <button className="w-full border-2 border-[#82B1FF] text-[#82B1FF] font-bold py-3 rounded-xl hover:bg-[#82B1FF] hover:text-white transition">Write a Review</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// Komponen Kecil Helper
const IconCol = ({ icon, label }) => (
  <div className="flex flex-col items-center gap-2 text-gray-800 hover:-translate-y-1 transition duration-300 cursor-pointer p-2 rounded-xl hover:bg-white">
    <div className="text-gray-800">{icon}</div>
    <p className="text-xs md:text-sm font-semibold text-gray-500">{label}</p>
  </div>
);