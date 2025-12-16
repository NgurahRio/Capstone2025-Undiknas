import React, { useRef, useState } from 'react';
import { Search, Compass, ArrowRight, ArrowLeft, Theater, Palette, Utensils, MapPin, MessageCircle, ChevronLeft, ChevronRight, Star } from 'lucide-react';

// --- SUB COMPONENTS HOME ---

const HeroSection = ({ onSearch }) => {
  const [searchQuery, setSearchQuery] = useState("");
  return (
    <div className="relative h-[650px] w-full flex items-center justify-center overflow-hidden">
      <div className="absolute inset-0 bg-black">
        <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80" className="w-full h-full object-cover opacity-80" alt="Hero" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>
      </div>
      <div className="relative z-10 w-full max-w-7xl px-6 flex flex-col justify-center h-full">
        <div className="animate-fade-in">
          <div className="flex items-center gap-3 mb-6 text-white/90 bg-white/10 w-fit px-4 py-2 rounded-full backdrop-blur-sm border border-white/20">
            <Compass size={18} /> 
            <span className="font-medium text-sm tracking-wide">Let's discover the beauty of Bali</span>
          </div>
          <h1 className="text-6xl lg:text-7xl font-bold text-white leading-[1.1] mb-6 drop-shadow-lg">
            Evening! <br /> <span className="text-[#82B1FF]">Ready to explore?</span>
          </h1>
          <h2 className="text-3xl lg:text-4xl font-bold text-white/90 mb-12">The Best Ubud Experience</h2>
          <form onSubmit={(e) => { e.preventDefault(); onSearch(searchQuery); }} className="bg-white p-2 rounded-2xl shadow-2xl flex items-center max-w-xl w-full transform hover:scale-[1.01] transition duration-300">
            <div className="pl-4 text-gray-400"><Search size={24} /></div>
            <input type="text" className="flex-1 px-4 py-3 outline-none text-gray-700 text-lg placeholder-gray-400 bg-transparent" placeholder="Where do you want to go?" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} />
            <button type="submit" className="bg-[#576D85] text-white w-14 h-14 rounded-xl flex items-center justify-center hover:bg-[#4a5e73] transition shadow-lg"><ArrowRight size={24} /></button>
          </form>
        </div>
      </div>
    </div>
  );
};

const PlaceCard = ({ title, subtitle, rating, tag, img, onPress }) => (
  <div onClick={onPress} className="min-w-[280px] h-[400px] rounded-[32px] relative overflow-hidden group cursor-pointer snap-start shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-2">
    <img src={img} className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
    <div className="absolute top-6 left-6 bg-white px-4 py-2 rounded-2xl flex items-center gap-2 text-sm font-bold shadow-md">
      <Star size={16} fill="orange" stroke="none" /> {rating}
    </div>
    <div className="absolute bottom-8 left-8 right-8 text-white">
      <h3 className="font-bold text-2xl mb-2 leading-tight">{title}</h3>
      <p className="text-sm text-gray-300 mb-4 font-light leading-snug line-clamp-2">{subtitle}</p>
      <span className="bg-[#5E9BF5] text-white text-[10px] font-bold px-4 py-1.5 rounded-full uppercase tracking-wider shadow-sm shadow-blue-900/50">{tag}</span>
    </div>
  </div>
);

const PopularPlacesSection = ({ onNavigate }) => {
  const scrollRef = useRef(null);
  const scroll = (offset) => scrollRef.current?.scrollBy({ left: offset, behavior: 'smooth' });
  return (
    <div className="flex flex-col lg:flex-row gap-16 items-center">
      <div className="lg:w-1/3 space-y-6">
        <h2 className="text-5xl font-bold leading-tight text-gray-900">Populer Place <br /> <span className="text-[#5E9BF5]">Now</span></h2>
        <p className="text-gray-500 text-lg leading-relaxed">Discover the most popular travel spots in Bali right now.</p>
      </div>
      <div className="lg:w-2/3 w-full flex items-center gap-6 relative">
        <button onClick={() => scroll(-320)} className="w-14 h-14 rounded-full border-2 border-[#5E9BF5] text-[#5E9BF5] bg-white flex items-center justify-center hover:bg-blue-50 transition shadow-lg flex-shrink-0 z-10"><ArrowLeft size={24} /></button>
        <div ref={scrollRef} className="flex gap-6 overflow-x-auto hide-scrollbar py-6 px-2 snap-x w-full scroll-smooth">
          <PlaceCard title="Monkey Forest" subtitle="Protected forest." rating="4.9" tag="Adventure" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={onNavigate} />
          <PlaceCard title="Ulun Danu" subtitle="Iconic lake temple." rating="4.9" tag="Culture" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={onNavigate} />
          <PlaceCard title="Campuhan" subtitle="Scenic trek." rating="4.8" tag="Nature" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={onNavigate} />
          <PlaceCard title="Tanah Lot" subtitle="Ancient shrine." rating="4.7" tag="Culture" img="https://images.unsplash.com/photo-1537996194471-e657df975ab4" onPress={onNavigate} />
        </div>
        <button onClick={() => scroll(320)} className="w-14 h-14 rounded-full bg-[#5E9BF5] border-2 border-[#5E9BF5] text-white flex items-center justify-center hover:bg-[#4a90e2] hover:border-[#4a90e2] transition shadow-lg flex-shrink-0 z-10"><ArrowRight size={24} /></button>
      </div>
    </div>
  );
};

const ExploreUbudSection = ({ onNavigate }) => (
  <div className="bg-[#F2F7FB] -mx-6 lg:-mx-40 px-6 lg:px-40 py-24 rounded-[40px]">
    <div className="max-w-7xl mx-auto">
      <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Explore Ubud</h2>
      <div className="h-[500px] flex gap-6">
        <div onClick={onNavigate} className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg hover:shadow-2xl transition-all duration-300">
          <img src="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=800" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Ex1"/>
        </div>
        <div className="flex-[0.8] flex flex-col gap-6">
          <div onClick={onNavigate} className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg hover:shadow-2xl transition-all duration-300">
            <img src="https://images.unsplash.com/photo-1554481923-a6918bd997bc?q=80&w=800" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Ex2"/>
          </div>
          <div onClick={onNavigate} className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg hover:shadow-2xl transition-all duration-300">
            <img src="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=800" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Ex3"/>
          </div>
        </div>
        <div onClick={onNavigate} className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg hover:shadow-2xl transition-all duration-300">
          <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=800" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Ex4"/>
        </div>
      </div>
    </div>
  </div>
);

const TagButton = ({ title, icon, active }) => (
  <button className={`flex items-center px-8 py-4 rounded-2xl font-semibold mr-4 whitespace-nowrap transition-all duration-300 ${active ? 'bg-[#82B1FF] text-white shadow-lg shadow-blue-200 transform scale-105' : 'bg-white text-gray-600 border border-gray-100 hover:bg-gray-50'}`}>
    {icon && <span className="mr-3">{icon}</span>}
    {title}
  </button>
);

const StyleCard = ({ title, desc, img, onPress }) => (
  <div onClick={onPress} className="bg-white rounded-[32px] shadow-lg overflow-hidden border border-gray-100 cursor-pointer hover:shadow-2xl hover:-translate-y-2 transition-all duration-300 group">
    <div className="h-56 overflow-hidden">
      <img src={img} className="h-full w-full object-cover group-hover:scale-110 transition duration-700" alt={title} />
    </div>
    <div className="p-8">
      <h4 className="font-bold text-xl text-gray-900 mb-2">{title}</h4>
      <p className="text-sm text-gray-500 mb-8 font-light line-clamp-2">{desc}</p>
      <div className="flex justify-end">
        <span className="text-[11px] bg-[#82B1FF] text-white px-4 py-2 rounded-lg font-bold uppercase tracking-widest group-hover:bg-[#5E9BF5] transition shadow-md shadow-blue-100">LEARN MORE</span>
      </div>
    </div>
  </div>
);

const TravelStyleSection = ({ onNavigate }) => (
  <div className="flex flex-col gap-10">
    <div className="flex justify-between items-end">
      <div className="flex items-center gap-4">
        <div className="w-2 h-10 bg-black rounded-full"></div>
        <h2 className="text-4xl font-bold text-gray-900">Travel Style</h2>
      </div>
      <button className="bg-[#82B1FF] text-white px-8 py-3 rounded-full font-bold text-sm hover:bg-[#6fa5ff] transition shadow-lg shadow-blue-100">View More</button>
    </div>
    <div className="flex gap-4 overflow-x-auto hide-scrollbar pb-2">
      <TagButton title="Culture" icon={<Theater size={18} />} active />
      <TagButton title="Adventure" icon={<Compass size={18} />} />
      <TagButton title="Art" icon={<Palette size={18} />} />
      <TagButton title="Food" icon={<Utensils size={18} />} />
    </div>
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
      <StyleCard title="Monkey Forest" desc="Protected forest." img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={onNavigate} />
      <StyleCard title="Sacred Monkey" desc="Ancient temple." img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" onPress={onNavigate} />
      <StyleCard title="Ubud Yoga" desc="Inner peace." img="https://images.unsplash.com/photo-1598091383021-15ddea10925d" onPress={onNavigate} />
      <StyleCard title="Local Culture" desc="Daily life." img="https://images.unsplash.com/photo-1516483638261-f4dbaf036963" onPress={onNavigate} />
    </div>
  </div>
);

const TopRatedSection = ({ onNavigate }) => (
  <div className="bg-white">
    <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-10 gap-6">
      <div className="flex items-center gap-4">
        <div className="w-2 h-10 bg-black rounded-full"></div>
        <h2 className="text-4xl font-bold text-gray-900">Top-Rated Experiences</h2>
      </div>
      <div className="flex gap-8 font-bold text-xl text-gray-400 bg-gray-50 px-6 py-2 rounded-full">
        <span className="text-black border-b-2 border-black cursor-pointer pb-1">All</span>
        <span className="cursor-pointer hover:text-black transition">Adventure</span>
        <span className="cursor-pointer hover:text-black transition">Culture</span>
      </div>
    </div>
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
      <StyleCard title="Monkey Forest" desc="Protected forest." img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={onNavigate} />
      <StyleCard title="Ulun Danu" desc="Iconic temple." img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={onNavigate} />
      <StyleCard title="Campuhan" desc="Scenic trek." img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={onNavigate} />
      <StyleCard title="Tanah Lot" desc="Ancient shrine." img="https://images.unsplash.com/photo-1537996194471-e657df975ab4" onPress={onNavigate} />
    </div>
  </div>
);

const EventCard = ({ title, loc, img, onPress }) => (
  <div onClick={onPress} className="bg-white border border-gray-100 rounded-[32px] overflow-hidden shadow-md cursor-pointer hover:shadow-xl transition-all duration-300 hover:-translate-y-1 flex flex-col group h-full">
    <div className="h-48 overflow-hidden relative">
      <img src={img} className="h-full w-full object-cover group-hover:scale-105 transition duration-500" alt={title} />
      <div className="absolute inset-0 bg-black/10 group-hover:bg-transparent transition"></div>
    </div>
    <div className="p-8 flex flex-col flex-1">
      <h4 className="font-bold text-2xl text-gray-900 mb-2">{title}</h4>
      <div className="flex items-center gap-2 text-sm text-[#5E9BF5] mb-4 font-semibold">
        <MapPin size={16} /> {loc}
      </div>
      <p className="text-sm text-gray-400 italic mb-6 flex-1">Experience the beauty of traditional performance.</p>
      <div className="flex justify-end mt-auto">
        <span className="bg-[#82B1FF] text-white text-[10px] font-bold px-4 py-2 rounded-xl uppercase tracking-widest shadow-md">FREE ACCESS</span>
      </div>
    </div>
  </div>
);

const CalendarWidget = () => {
  const [currentDate, setCurrentDate] = useState(new Date(2025, 4, 1));
  const [selectedDay, setSelectedDay] = useState(27);
  const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  const daysInMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0).getDate();
  const firstDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1).getDay();
  
  const renderDays = () => {
    let days = [];
    for (let i = 0; i < firstDay; i++) days.push(<div key={`empty-${i}`} className="w-10 h-10"></div>);
    for (let i = 1; i <= daysInMonth; i++) {
      const isSelected = i === selectedDay;
      days.push(
        <button key={i} onClick={() => setSelectedDay(i)} className={`w-10 h-10 flex items-center justify-center rounded-full text-base font-medium transition-all duration-300 ${isSelected ? 'bg-[#82B1FF] text-white shadow-lg shadow-blue-200 scale-110 font-bold' : 'text-gray-700 hover:bg-gray-100'}`}>
          {i}
        </button>
      );
    }
    return days;
  };

  return (
    <div className="select-none">
      <div className="flex justify-between items-center mb-8 px-4">
        <button onClick={() => setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1))} className="text-gray-400 hover:text-black transition p-2 hover:bg-gray-100 rounded-full"><ChevronLeft size={24} /></button>
        <h3 className="font-bold text-xl text-gray-900">{monthNames[currentDate.getMonth()]} {currentDate.getFullYear()}</h3>
        <button onClick={() => setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1))} className="text-gray-900 hover:text-black transition p-2 hover:bg-gray-100 rounded-full"><ChevronRight size={24} /></button>
      </div>
      <div className="grid grid-cols-7 text-center mb-6">{['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map(d => <span key={d} className="text-xs font-bold text-gray-400 uppercase tracking-widest">{d}</span>)}</div>
      <div className="grid grid-cols-7 gap-y-4 justify-items-center">{renderDays()}</div>
    </div>
  );
};

const TodaysEventSection = ({ onNavigate }) => (
  <div>
    <div className="flex items-center gap-4 mb-3">
      <div className="w-2 h-10 bg-black rounded-full"></div>
      <h2 className="text-4xl font-bold text-gray-900">Today's Event</h2>
    </div>
    <p className="text-lg text-gray-500 mb-12 pl-6">Events available today, on the 27th.</p>
    <div className="flex flex-col lg:flex-row gap-12">
      <div className="flex-1 grid grid-cols-1 md:grid-cols-2 gap-8 content-start">
        <EventCard title="Legong Dance" loc="Ubud Palace" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" onPress={onNavigate} />
        <EventCard title="Kecak Fire" loc="Pura Dalem" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={onNavigate} />
      </div>
      <div className="lg:w-[400px] bg-white rounded-[32px] shadow-xl border border-gray-100 p-8 h-fit">
        <CalendarWidget />
      </div>
    </div>
  </div>
);

const ChatBubble = ({ text, isUser }) => (
  <div className={`p-5 rounded-2xl max-w-[85%] text-base shadow-sm mb-4 leading-relaxed ${isUser ? 'bg-[#82B1FF] text-white ml-auto rounded-br-sm' : 'bg-white text-gray-700 mr-auto rounded-bl-sm border border-gray-100'}`}>
    {text}
  </div>
);

const TravoraChatSection = () => (
  <div className="bg-[#F2F7FB] -mx-6 lg:-mx-40 px-6 lg:px-40 py-24 rounded-[40px] flex flex-col lg:flex-row gap-16 items-center">
    <div className="lg:w-1/2 space-y-8">
      <h2 className="text-5xl font-bold text-gray-900 leading-tight">Need quick answers?</h2>
      <p className="text-xl text-gray-600 leading-relaxed font-light">Meet Travora’s smart WhatsApp assistant — your travel buddy for instant answers and recommendations.</p>
      <button className="bg-[#64829F] text-white px-10 py-5 rounded-2xl flex items-center gap-4 font-bold text-xl hover:bg-[#526a86] transition shadow-xl shadow-gray-300">
        <MessageCircle size={28} /> Start Chat
      </button>
    </div>
    <div className="lg:w-1/2 w-full bg-white rounded-[32px] shadow-2xl overflow-hidden border border-gray-100 flex flex-col h-[500px]">
      <div className="bg-[#64829F] p-6 flex items-center gap-4 text-white">
        <div className="bg-white/20 p-2 rounded-full"><MessageCircle size={28} /></div>
        <span className="font-bold text-2xl">Travora Assistant</span>
      </div>
      <div className="flex-1 p-8 overflow-y-auto space-y-6 bg-gray-50/50">
        <ChatBubble text="Halo! Saya Asisten Chat. Mau cari apa hari ini?" isUser={false} />
        <ChatBubble text="Wisata yang terpopuler di ubud" isUser={true} />
        <ChatBubble text="Berikut 5 wisata yang terpopuler : Monkey Forest..." isUser={false} />
      </div>
      <div className="p-6 border-t bg-white flex items-center gap-4">
        <input type="text" placeholder="Ketik pertanyaanmu disini..." className="flex-1 bg-gray-100 px-6 py-4 rounded-xl outline-none text-base focus:ring-2 focus:ring-[#5E9BF5]/50 transition" />
        <button className="text-[#5E9BF5] font-bold text-sm uppercase">Kirim</button>
      </div>
    </div>
  </div>
);

// --- MAIN PAGE EXPORT ---
export default function Home({ onNavigate }) {
  const [searchQuery, setSearchQuery] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const eventRef = useRef(null);

  const handleSearch = (query) => {
    if(query) setIsSearching(true);
  };

  return (
    <div className="flex flex-col gap-24 pb-20">
      <HeroSection searchQuery={searchQuery} setSearchQuery={setSearchQuery} onSearch={handleSearch} />
      
      {isSearching ? (
        <SearchResultsSection query={searchQuery} onHomeTap={() => { setIsSearching(false); setSearchQuery(""); }} onNavigate={onNavigate} />
      ) : (
        <div className="max-w-7xl mx-auto w-full px-6 flex flex-col gap-24">
          <PopularPlacesSection onNavigate={onNavigate} />
          <ExploreUbudSection onNavigate={onNavigate} />
          <TravelStyleSection onNavigate={onNavigate} />
          <TopRatedSection onNavigate={onNavigate} />
          <div ref={eventRef}><TodaysEventSection onNavigate={onNavigate} /></div>
          <TravoraChatSection />
        </div>
      )}
    </div>
  );
}