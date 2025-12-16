import React from 'react';
import { Lock, Trash2, ChevronDown } from 'lucide-react';

const RecCard = ({ title, img, onPress }) => (
  <div onClick={onPress} className="h-[350px] rounded-[32px] relative overflow-hidden group cursor-pointer shadow-xl hover:shadow-2xl transition-all duration-500">
    <img src={img} className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-90"></div>
    <div className="absolute bottom-8 left-8 right-8 text-white">
      <h3 className="font-bold text-3xl mb-2">{title}</h3>
      <p className="text-base italic text-gray-300 font-light mb-4">Explore the hidden beauty.</p>
      <span className="bg-white/20 backdrop-blur-md text-white text-xs font-bold px-4 py-2 rounded-lg border border-white/30">DISCOVER</span>
    </div>
    <span className="absolute top-6 right-6 bg-[#82B1FF] text-white text-[10px] font-bold px-4 py-2 rounded-full uppercase tracking-wider shadow-lg">Adventure</span>
  </div>
);

export default function Bookmark({ isLoggedIn, onToggleLogin, onNavigate }) {
  return (
    <div className="w-full animate-fade-in pb-20">
      <div className="h-[450px] relative w-full">
        <img src="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200" className="w-full h-full object-cover brightness-50" alt="Book Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-6xl font-bold text-white">Bookmark</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <h2 className="text-[#82B1FF] text-xl font-bold mb-4 uppercase tracking-wide">Your Collection</h2>
        <div className="h-[1px] bg-gray-200 w-full mb-16"></div>

        {!isLoggedIn ? (
          <div className="text-center py-24 bg-white rounded-[40px] shadow-lg border border-gray-100">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <Lock size={40} className="text-gray-400" />
            </div>
            <h1 className="text-4xl font-bold mb-4 text-gray-900">Please login first</h1>
            <p className="text-gray-500 mb-10 text-lg">You need to be logged in to view your bookmarks.</p>
            <button onClick={onToggleLogin} className="bg-[#82B1FF] text-white px-12 py-4 rounded-full font-bold text-xl hover:bg-[#6fa5ff] transition shadow-lg shadow-blue-200">
              Login / Sign up
            </button>
          </div>
        ) : (
          <div>
            <div className="flex flex-wrap items-center gap-4 mb-12 bg-white p-4 rounded-2xl shadow-sm border border-gray-100">
              <button className="bg-[#82B1FF] text-white font-bold px-8 py-3 rounded-xl hover:opacity-90 transition shadow-md">Choose</button>
              <button className="bg-white border border-gray-200 text-[#EF685B] font-bold px-8 py-3 rounded-xl flex items-center gap-2 hover:bg-red-50 transition">
                <Trash2 size={18} /> Delete All
              </button>
              <div className="ml-auto">
                <button className="text-gray-600 font-bold px-6 py-3 rounded-xl flex items-center gap-2 text-sm hover:bg-gray-50 transition">
                  Show Destinations <ChevronDown size={18} />
                </button>
              </div>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <RecCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={onNavigate} />
              <RecCard title="Sacred Monkey" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" onPress={onNavigate} />
              <RecCard title="Ubud Yoga" img="https://images.unsplash.com/photo-1598091383021-15ddea10925d" onPress={onNavigate} />
              <RecCard title="Local Culture" img="https://images.unsplash.com/photo-1516483638261-f4dbaf036963" onPress={onNavigate} />
            </div>
          </div>
        )}
      </div>
    </div>
  );
}