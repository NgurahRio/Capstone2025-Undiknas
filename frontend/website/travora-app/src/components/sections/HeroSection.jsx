import React from 'react';
import { Compass, Search, ArrowRight } from 'lucide-react';

export default function HeroSection() {
  return (
    <div className="relative h-[650px] w-full flex items-center justify-center overflow-hidden">
      <div className="absolute inset-0 bg-black">
        <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80" className="w-full h-full object-cover opacity-80" alt="Hero" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>
      </div>
      
      <div className="relative z-10 w-full max-w-7xl px-6 flex flex-col justify-center h-full">
        <div className="animate-fade-in-up">
          <div className="flex items-center gap-3 mb-6 text-white/90 bg-white/10 w-fit px-4 py-2 rounded-full backdrop-blur-sm border border-white/20">
            <Compass size={18} /> 
            <span className="font-medium text-sm tracking-wide">Let's discover the beauty of Bali</span>
          </div>
          
          <h1 className="text-6xl lg:text-7xl font-bold text-white leading-[1.1] mb-6 drop-shadow-lg">
            Evening! <br /> <span className="text-[#82B1FF]">Ready to explore?</span>
          </h1>
          <h2 className="text-3xl lg:text-4xl font-bold text-white/90 mb-12">The Best Ubud Experience</h2>

          <div className="bg-white p-2 rounded-2xl shadow-2xl flex items-center max-w-xl w-full transform hover:scale-[1.01] transition duration-300">
            <div className="pl-4 text-gray-400"><Search size={24} /></div>
            <input 
              type="text" 
              className="flex-1 px-4 py-3 outline-none text-gray-700 text-lg placeholder-gray-400 bg-transparent"
              placeholder="Where do you want to go?"
            />
            <button className="bg-[#576D85] text-white w-14 h-14 rounded-xl flex items-center justify-center hover:bg-[#4a5e73] transition shadow-lg">
              <ArrowRight size={24} />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}