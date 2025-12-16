import React from 'react';
import { useNavigate } from 'react-router-dom';
import Navbar from '../components/common/Navbar'; 
import Footer from '../components/common/Footer';

import HeroSection from '../components/sections/HeroSection';
import PopularPlaces from '../components/sections/PopularPlaces';
import EventSection from '../components/sections/EventSection';
import ChatSection from '../components/sections/ChatSection';
import StyleCard from '../components/cards/StyleCard';

export default function Home() {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col gap-24 pb-20 animate-fade-in">
      <HeroSection />
      
      <div className="max-w-7xl mx-auto w-full px-6 flex flex-col gap-24">
        
        {/* DATABASE INTEGRATED SECTION */}
        <PopularPlaces />
        
        {/* STATIC SECTIONS (Placeholder Data untuk mempertahankan tampilan) */}
        
        {/* Explore Ubud Section */}
        <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px]">
           <div className="max-w-7xl mx-auto">
             <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Explore Ubud</h2>
             <div className="h-[500px] flex gap-6">
                <div className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg">
                    <img src="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" />
                </div>
                <div className="flex-[0.8] flex flex-col gap-6">
                    <div className="flex-1 rounded-3xl overflow-hidden bg-gray-200"><img src="https://images.unsplash.com/photo-1554481923-a6918bd997bc" className="w-full h-full object-cover"/></div>
                    <div className="flex-1 rounded-3xl overflow-hidden bg-gray-200"><img src="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" className="w-full h-full object-cover"/></div>
                </div>
                <div className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg">
                    <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" />
                </div>
             </div>
           </div>
        </div>

        {/* Travel Style Section */}
        <div className="flex flex-col gap-10">
           <div className="flex items-center gap-4">
              <div className="w-2 h-10 bg-black rounded-full"></div>
              <h2 className="text-4xl font-bold text-gray-900">Travel Style</h2>
           </div>
           <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              <StyleCard title="Culture" desc="Heritage sites." img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={() => navigate('/destination')} />
              <StyleCard title="Nature" desc="Forest & Trek." img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={() => navigate('/destination')} />
              <StyleCard title="Culinary" desc="Best local food." img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={() => navigate('/destination')} />
              <StyleCard title="Art" desc="Museums & Art." img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" onPress={() => navigate('/destination')} />
           </div>
        </div>

        {/* Event Section */}
        <EventSection />

        {/* Chat Section */}
        <ChatSection />
        
      </div>
    </div>
  );
}