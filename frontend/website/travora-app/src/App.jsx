import React, { useState, useRef, useEffect } from 'react';
import { 
  MapPin, MessageCircle, Search, ArrowLeft, ArrowRight, Star, 
  Compass, Palette, Utensils, Camera, Square, User, ShoppingBag, 
  Check, Heart, Users, Trash2, ChevronDown, Edit, Lock, LogOut, 
  ChevronLeft, ChevronRight, Theater 
} from 'lucide-react';

// --- DATA ---
const GALLERY_IMAGES = [
  'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=1200&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=1200&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=1200&auto=format&fit=crop',
];

// --- APP COMPONENT ---
export default function App() {
  const [activeTab, setActiveTab] = useState('home');
  const [currentPage, setCurrentPage] = useState('main'); 
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  
  const eventRef = useRef(null);

  const handleTabPress = (tabName) => {
    setActiveTab(tabName);
    if (tabName === 'home') {
      setCurrentPage('main');
      setIsSearching(false);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } else if (tabName === 'event') {
      setCurrentPage('main');
      setIsSearching(false);
      setTimeout(() => eventRef.current?.scrollIntoView({ behavior: 'smooth', block: 'center' }), 100);
    } else {
      setCurrentPage(tabName);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchQuery) setIsSearching(true);
  };

  const renderContent = () => {
    if (currentPage === 'destination') return <DestinationPage onBack={() => { setCurrentPage('main'); window.scrollTo(0,0); }} />;
    if (currentPage === 'bookmark') return <BookmarkPage isLoggedIn={isLoggedIn} onToggleLogin={() => setIsLoggedIn(!isLoggedIn)} onNavigate={() => setCurrentPage('destination')} />;
    if (currentPage === 'profile') return <ProfilePage isLoggedIn={isLoggedIn} onToggleLogin={() => setIsLoggedIn(!isLoggedIn)} />;

    return (
      <div className="flex flex-col gap-24 pb-20">
        <HeroSection searchQuery={searchQuery} setSearchQuery={setSearchQuery} onSearch={handleSearch} />
        
        {isSearching ? (
          <SearchResultsSection query={searchQuery} onHomeTap={() => { setIsSearching(false); setSearchQuery(""); }} onNavigate={() => setCurrentPage('destination')} />
        ) : (
          <div className="max-w-7xl mx-auto w-full px-6 flex flex-col gap-24">
            <PopularPlacesSection onNavigate={() => setCurrentPage('destination')} />
            <ExploreUbudSection onNavigate={() => setCurrentPage('destination')} />
            <TravelStyleSection onNavigate={() => setCurrentPage('destination')} />
            <TopRatedSection onNavigate={() => setCurrentPage('destination')} />
            <div ref={eventRef}><TodaysEventSection onNavigate={() => setCurrentPage('destination')} /></div>
            <TravoraChatSection />
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="min-h-screen bg-[#FAFAFA] font-poppins text-gray-800">
      {/* NAVBAR */}
      <nav className="fixed top-0 left-0 right-0 h-[90px] bg-white/95 backdrop-blur-md z-50 border-b border-gray-100 flex items-center justify-center">
        <div className="max-w-7xl w-full px-6 flex items-center justify-between">
          <div className="flex items-center gap-2 cursor-pointer hover:opacity-80 transition" onClick={() => handleTabPress('home')}>
            <MapPin className="text-[#5E9BF5]" size={28} fill="#5E9BF5" color="white" />
            <span className="text-2xl font-bold text-[#5E9BF5] tracking-tight">Travora</span>
          </div>

          <div className="hidden lg:flex items-center gap-12">
            {['home', 'event', 'bookmark', 'profile'].map((tab) => (
              <button 
                key={tab}
                onClick={() => handleTabPress(tab)}
                className={`text-base capitalize transition-all duration-300 ${activeTab === tab ? 'font-bold text-black border-b-2 border-black pb-1' : 'font-medium text-gray-400 hover:text-[#5E9BF5]'}`}
              >
                {tab}
              </button>
            ))}
          </div>

          <div className="flex items-center gap-4">
            <button className="bg-[#576D85] text-white px-5 py-2.5 rounded-xl flex items-center gap-2 hover:bg-[#4a5e73] transition shadow-md shadow-gray-200">
              <MessageCircle size={18} /> <span className="text-sm font-semibold">Chat</span>
            </button>
            {(!isLoggedIn || (currentPage !== 'profile' && currentPage !== 'bookmark')) && (
              <button 
                onClick={() => setIsLoggedIn(!isLoggedIn)}
                className="bg-[#82B1FF] text-white px-6 py-2.5 rounded-xl font-bold hover:bg-[#6fa5ff] transition shadow-md shadow-blue-100 text-sm"
              >
                {isLoggedIn ? 'Log Out' : 'Log In'}
              </button>
            )}
          </div>
        </div>
      </nav>

      <div className="h-[90px]"></div>
      <main className="animate-fade-in">{renderContent()}</main>
      <Footer onScrollTop={() => window.scrollTo({ top: 0, behavior: 'smooth' })} />
    </div>
  );
}

// --- SECTIONS (REFINED) ---

const HeroSection = ({ searchQuery, setSearchQuery, onSearch }) => (
  <div className="relative h-[650px] w-full flex items-center justify-center overflow-hidden">
    <div className="absolute inset-0 bg-black">
      <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80" className="w-full h-full object-cover opacity-80" alt="Hero" />
      <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"></div>
    </div>
    
    <div className="relative z-10 w-full max-w-7xl px-6 flex flex-col justify-center h-full">
      <div className="fade-in-up" style={{ animationDelay: '0.1s' }}>
        <div className="flex items-center gap-3 mb-6 text-white/90 bg-white/10 w-fit px-4 py-2 rounded-full backdrop-blur-sm border border-white/20">
          <Compass size={18} /> 
          <span className="font-medium text-sm tracking-wide">Let's discover the beauty of Bali</span>
        </div>
        
        <h1 className="text-6xl lg:text-7xl font-bold text-white leading-[1.1] mb-6 drop-shadow-lg">
          Evening! <br /> <span className="text-[#82B1FF]">Ready to explore?</span>
        </h1>
        <h2 className="text-3xl lg:text-4xl font-bold text-white/90 mb-12">The Best Ubud Experience</h2>

        <form onSubmit={onSearch} className="bg-white p-2 rounded-2xl shadow-2xl flex items-center max-w-xl w-full transform hover:scale-[1.01] transition duration-300">
          <div className="pl-4 text-gray-400"><Search size={24} /></div>
          <input 
            type="text" 
            className="flex-1 px-4 py-3 outline-none text-gray-700 text-lg placeholder-gray-400 bg-transparent"
            placeholder="Where do you want to go?"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          <button type="submit" className="bg-[#576D85] text-white w-14 h-14 rounded-xl flex items-center justify-center hover:bg-[#4a5e73] transition shadow-lg">
            <ArrowRight size={24} />
          </button>
        </form>
      </div>
    </div>
  </div>
);

const SearchResultsSection = ({ query, onHomeTap, onNavigate }) => (
  <div className="max-w-7xl mx-auto w-full px-6 py-10 min-h-[600px]">
    <div className="flex items-center gap-3 text-lg font-medium mb-6 text-gray-500">
      <span onClick={onHomeTap} className="text-[#82B1FF] cursor-pointer hover:underline">Home</span> 
      <ChevronRight size={16} /> 
      <span className="text-gray-900">{query}</span>
    </div>
    
    <div className="flex items-end gap-4 mb-10 border-b border-gray-200 pb-6">
      <h2 className="text-4xl font-bold text-gray-900">{query || "Search Result"}</h2>
      <span className="text-xl text-gray-500 mb-1.5 font-medium">4 Result Found</span>
    </div>

    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
      <StyleCard title="Monkey Forest Ubud" desc="Protected forest." img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={onNavigate} />
      <StyleCard title="Ulun Danu Beratan" desc="Iconic temple." img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={onNavigate} />
      <StyleCard title="Campuhan Ridge" desc="Scenic trek." img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={onNavigate} />
      <StyleCard title="Tanah Lot" desc="Ancient shrine." img="https://images.unsplash.com/photo-1537996194471-e657df975ab4" onPress={onNavigate} />
    </div>
  </div>
);

const PopularPlacesSection = ({ onNavigate }) => {
  const scrollRef = useRef(null);
  const scroll = (offset) => scrollRef.current?.scrollBy({ left: offset, behavior: 'smooth' });

  return (
    <div className="flex flex-col lg:flex-row gap-16 items-center">
      {/* Kolom Kiri: Teks */}
      <div className="lg:w-1/3 space-y-6">
        <h2 className="text-5xl font-bold leading-tight text-gray-900">Populer Place <br /> <span className="text-[#5E9BF5]">Now</span></h2>
        <p className="text-gray-500 text-lg leading-relaxed">Discover the most popular travel spots in Bali right now. Don't miss out on these gems.</p>
      </div>
      
      {/* Kolom Kanan: Slider dengan Tombol di Kiri & Kanan */}
      <div className="lg:w-2/3 w-full flex items-center gap-6 relative">
        
        {/* Tombol Kiri */}
        <button 
          onClick={() => scroll(-320)} 
          className="w-14 h-14 rounded-full border-2 border-[#5E9BF5] text-[#5E9BF5] bg-white flex items-center justify-center hover:bg-blue-50 transition shadow-lg flex-shrink-0 z-10"
        >
          <ArrowLeft size={24} />
        </button>

        {/* Scroll Container */}
        <div ref={scrollRef} className="flex gap-6 overflow-x-auto hide-scrollbar py-6 px-2 snap-x w-full scroll-smooth">
          <PlaceCard title="Monkey Forest" subtitle="Protected forest." rating="4.9" tag="Adventure" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={onNavigate} />
          <PlaceCard title="Ulun Danu" subtitle="Iconic lake temple." rating="4.9" tag="Culture" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={onNavigate} />
          <PlaceCard title="Campuhan" subtitle="Scenic trek." rating="4.8" tag="Nature" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={onNavigate} />
          <PlaceCard title="Tanah Lot" subtitle="Ancient shrine." rating="4.7" tag="Culture" img="https://images.unsplash.com/photo-1537996194471-e657df975ab4" onPress={onNavigate} />
          <PlaceCard title="Tegalalang" subtitle="Rice terrace." rating="4.8" tag="Nature" img="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f" onPress={onNavigate} />
        </div>

        {/* Tombol Kanan */}
        <button 
          onClick={() => scroll(320)} 
          className="w-14 h-14 rounded-full bg-[#5E9BF5] border-2 border-[#5E9BF5] text-white flex items-center justify-center hover:bg-[#4a90e2] hover:border-[#4a90e2] transition shadow-lg flex-shrink-0 z-10"
        >
          <ArrowRight size={24} />
        </button>

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
        <ChatBubble text="Berikut 5 wisata yang terpopuler : Monkey Forest, Campuhan Ridge Walk..." isUser={false} />
      </div>
      <div className="p-6 border-t bg-white flex items-center gap-4">
        <input type="text" placeholder="Ketik pertanyaanmu disini..." className="flex-1 bg-gray-100 px-6 py-4 rounded-xl outline-none text-base focus:ring-2 focus:ring-[#5E9BF5]/50 transition" />
        <button className="text-[#5E9BF5] font-bold text-sm uppercase">Kirim</button>
      </div>
    </div>
  </div>
);

// ==========================================
// HALAMAN DETAIL (Destination, Bookmark, Profile)
// ==========================================

const DestinationPage = ({ onBack }) => {
  const [imgIndex, setImgIndex] = useState(0);
  const nextImage = () => setImgIndex((prev) => (prev === GALLERY_IMAGES.length - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? GALLERY_IMAGES.length - 1 : prev - 1));

  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Hero Image Full Width */}
      <div className="h-[500px] relative w-full group">
        <img src="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200" className="w-full h-full object-cover brightness-[0.6]" alt="Dest Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-6xl font-bold text-white tracking-tight">Destination</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-16">
        <div className="flex items-center gap-3 mb-6 text-xl font-medium text-gray-500">
          <span className="text-[#82B1FF] cursor-pointer hover:underline" onClick={onBack}>Home</span> 
          <ChevronRight size={20} /> 
          <span className="text-gray-900 font-semibold">Destination</span>
        </div>
        <div className="h-[1px] bg-gray-200 w-full mb-12"></div>

        {/* Gallery Slider */}
        <div className="relative w-full h-[600px] rounded-[40px] overflow-hidden mb-12 shadow-2xl group">
          <img src={GALLERY_IMAGES[imgIndex]} className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
          <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent pointer-events-none"></div>
          
          <div className="absolute bottom-10 left-0 right-0 flex justify-center gap-8">
             <button onClick={prevImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition duration-300">
               <ArrowLeft size={20} /> Back
             </button>
             <button onClick={nextImage} className="bg-white/20 backdrop-blur-md border border-white/30 text-white px-6 py-3 rounded-full flex items-center gap-3 hover:bg-white hover:text-black transition duration-300">
               Next <ArrowRight size={20} />
             </button>
          </div>
        </div>

        <div className="flex flex-col lg:flex-row gap-20">
          {/* Left Content */}
          <div className="lg:w-2/3 space-y-12">
            <div>
              <div className="flex justify-between items-start mb-6">
                <h1 className="text-5xl font-bold text-gray-900">Monkey Forest Ubud</h1>
                <Heart size={40} className="text-gray-300 cursor-pointer hover:fill-[#EF685B] hover:text-[#EF685B] transition" />
              </div>
              <div className="flex items-center text-gray-500 text-lg gap-2">
                <MapPin size={24} className="text-[#5E9BF5]" />
                <span>JL. Monkey Forest, Ubud, Gianyar, Bali</span>
              </div>
            </div>

            <p className="text-gray-600 text-xl leading-relaxed font-light">
              Discover the sacred Monkey Forest in Ubud, where hundreds of playful monkeys live freely among ancient temples and lush jungle.
            </p>

            <div className="flex gap-4">
              <TagBadge text="Adventure" color="#5E9BF5" />
              <TagBadge text="Spiritual" color="#82B1FF" />
            </div>

            <div className="space-y-6">
              <h3 className="text-3xl font-bold text-gray-900">Facilities</h3>
              <div className="grid grid-cols-5 gap-4 bg-gray-50 p-8 rounded-3xl border border-gray-100">
                <IconCol icon={<Camera size={32} />} label="Photo" />
                <IconCol icon={<Square size={32} />} label="Parking" />
                <IconCol icon={<User size={32} />} label="Guide" />
                <IconCol icon={<ShoppingBag size={32} />} label="Shop" />
                <IconCol icon={<Utensils size={32} />} label="Food" />
              </div>
            </div>

            <div className="space-y-6">
              <h3 className="text-3xl font-bold text-gray-900">Available Ticket</h3>
              <div className="flex gap-4 overflow-x-auto pb-4">
                <TicketBtn label="Solo Trip" icon={<User size={20} />} active />
                <TicketBtn label="Romantic" icon={<Heart size={20} />} />
                <TicketBtn label="Group" icon={<Users size={20} />} />
              </div>
              
              <div className="flex gap-4">
                <button className="bg-[#EF685B] text-white px-8 py-4 rounded-2xl font-bold hover:bg-opacity-90 shadow-lg shadow-red-100 transition">SOS</button>
                <button className="bg-[#82B1FF] text-white flex-1 py-4 rounded-2xl font-bold hover:bg-opacity-90 shadow-lg shadow-blue-100 transition">Safety Guidelines</button>
              </div>

              <div className="border border-gray-200 rounded-3xl p-10 shadow-lg bg-white relative overflow-hidden">
                <div className="absolute top-0 right-0 bg-[#EBC136] text-white px-4 py-2 rounded-bl-2xl font-bold text-xs">BEST VALUE</div>
                <h4 className="text-2xl font-bold mb-6 text-gray-900">Solo Trip Package</h4>
                <p className="text-gray-500 font-semibold mb-4 text-sm uppercase tracking-wide">Includes:</p>
                <ul className="space-y-4 mb-8 text-gray-600 text-base">
                  <CheckRow text="Entrance fee" />
                  <CheckRow text="Traditional Balinese attire" />
                  <CheckRow text="Free Parking Access" />
                </ul>
                <div className="my-6 border-t border-gray-100"></div>
                <div className="flex justify-between items-center">
                  <p className="text-4xl font-bold text-[#EBC136]">IDR. 80.000</p>
                  <button className="bg-[#5E9BF5] text-white px-8 py-3 rounded-xl font-bold hover:opacity-90 transition">Book Now</button>
                </div>
              </div>
            </div>
          </div>

          <div className="lg:w-1/3 flex flex-col gap-10">
            {/* Map Iframe */}
            <div className="bg-white p-4 rounded-[32px] shadow-xl border border-gray-100">
              <div className="w-full h-[300px] rounded-2xl overflow-hidden bg-gray-100 relative group">
                <iframe 
                  width="100%" height="100%" frameBorder="0" scrolling="no" marginHeight="0" marginWidth="0" 
                  src="https://www.openstreetmap.org/export/embed.html?bbox=115.25919%2C-8.52314%2C115.26719%2C-8.51514&amp;layer=mapnik&amp;marker=-8.51914%2C115.26319"
                  title="Map" className="absolute inset-0 grayscale group-hover:grayscale-0 transition duration-500"
                ></iframe>
              </div>
              <button className="w-full bg-gray-100 text-gray-800 font-bold py-4 mt-4 rounded-xl hover:bg-gray-200 transition text-lg flex justify-center items-center gap-2">
                <MapPin size={20} /> View on Google Maps
              </button>
            </div>

            {/* Reviews */}
            <div className="bg-white p-8 rounded-[32px] shadow-xl border border-gray-100 text-center">
              <h3 className="text-3xl font-bold mb-2 text-gray-900">Reviews</h3>
              <div className="text-7xl font-bold text-[#EBC136] mb-2 tracking-tighter">4.9</div>
              <div className="flex justify-center gap-1 text-[#EBC136] mb-4">
                {[...Array(5)].map((_, i) => <Star key={i} size={24} fill="#EBC136" stroke="none" />)}
              </div>
              <p className="text-gray-400 text-sm mb-8 font-medium">Based on 5 verified reviews</p>
              <div className="border-t border-gray-100 mb-8"></div>
              <div className="text-left space-y-6 mb-8">
                <ReviewItem name="Riyo Sumedang" text="Sangat rekomendasi, tempatnya sejuk!" />
                <ReviewItem name="Nielsun" text="Tempat indah, monyetnya lucu." />
              </div>
              <button className="w-full border-2 border-[#82B1FF] text-[#82B1FF] font-bold py-3 rounded-xl hover:bg-[#82B1FF] hover:text-white transition">Write a Review</button>
            </div>
          </div>
        </div>

        <div className="h-24"></div>
        
        {/* All Destination */}
        <div className="flex items-center gap-4 mb-12">
          <div className="w-2 h-10 bg-black rounded-full"></div>
          <h2 className="text-4xl font-bold text-black">All Destination</h2>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <RecCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" />
          <RecCard title="Jungle Trek" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" />
        </div>
      </div>
    </div>
  );
};

const BookmarkPage = ({ isLoggedIn, onToggleLogin, onNavigate }) => {
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
};

const ProfilePage = ({ isLoggedIn, onToggleLogin }) => {
  return (
    <div className="w-full animate-fade-in pb-20">
      <div className="h-[450px] relative w-full">
        <img src="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=1200" className="w-full h-full object-cover brightness-50" alt="Profile Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-6xl font-bold text-white">Profile</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <h2 className="text-[#82B1FF] text-xl font-bold mb-4 uppercase tracking-wide">Account Settings</h2>
        <div className="h-[1px] bg-gray-200 w-full mb-16"></div>

        {!isLoggedIn ? (
          <div className="text-center py-24 bg-white rounded-[40px] shadow-lg border border-gray-100">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <User size={40} className="text-gray-400" />
            </div>
            <h1 className="text-4xl font-bold mb-4 text-gray-900">Guest User</h1>
            <button onClick={onToggleLogin} className="bg-[#82B1FF] text-white px-12 py-4 rounded-full font-bold text-xl hover:bg-[#6fa5ff] transition shadow-lg shadow-blue-200">
              Login / Sign up
            </button>
          </div>
        ) : (
          <div className="flex flex-col lg:flex-row gap-20">
            <div className="lg:w-1/3">
              <div className="w-32 h-32 bg-gray-200 rounded-full mb-6 overflow-hidden mx-auto lg:mx-0 shadow-inner">
                <img src="https://i.pravatar.cc/300" alt="Avatar" className="w-full h-full object-cover" />
              </div>
              <h1 className="text-5xl font-bold text-black mb-2 text-center lg:text-left">Riyo Sumedang</h1>
              <p className="text-xl text-gray-500 mb-2 font-light text-center lg:text-left">riyookkkkkk@gmail.com</p>
              <div className="bg-green-100 text-green-700 px-4 py-1 rounded-full text-sm font-bold w-fit mx-auto lg:mx-0 mt-4">Verified Member</div>
            </div>

            <div className="lg:w-2/3 flex flex-col gap-6">
              <ProfileButton icon={<Edit size={24} />} text="Edit Profile Name" sub="Change your display name" />
              <ProfileButton icon={<Lock size={24} />} text="Change Password" sub="Update your security credentials" />
              <ProfileButton icon={<MessageCircle size={24} />} text="Support" sub="Get help with your bookings" />
              
              <div className="h-4"></div>
              
              <button onClick={onToggleLogin} className="bg-[#EF685B] text-white rounded-2xl py-5 px-8 flex items-center justify-center gap-3 hover:bg-opacity-90 transition shadow-lg shadow-red-100 transform hover:-translate-y-1 w-full lg:w-fit">
                <span className="font-bold text-xl">Log out</span>
                <LogOut size={24} />
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

const Footer = ({ onScrollTop }) => (
  <footer className="bg-white py-16 px-6 lg:px-20 border-t border-gray-100 mt-20">
    <div className="max-w-7xl mx-auto flex flex-col">
      <div className="flex justify-between items-center w-full mb-10 relative">
        <div className="absolute left-1/2 -translate-x-1/2 flex items-center gap-3 cursor-pointer group" onClick={onScrollTop}>
          <MapPin size={40} className="text-[#5E9BF5] group-hover:scale-110 transition" fill="#5E9BF5" color="white" />
          <span className="text-4xl font-bold text-[#5E9BF5]">Travora</span>
        </div>
        <div></div>
        <button onClick={onScrollTop} className="w-16 h-16 bg-[#82B1FF] rounded-full flex items-center justify-center text-white hover:bg-[#6fa5ff] transition shadow-xl hover:-translate-y-2">
          <ArrowRight size={32} className="-rotate-90" />
        </button>
      </div>
      <div className="w-full h-[1px] bg-gray-100 mb-8"></div>
      <div className="flex justify-between items-center text-sm text-gray-400">
        <div className="flex gap-6">
          <span>Terms</span>
          <span>Privacy</span>
          <span>Cookies</span>
        </div>
        <p>Copyright © 2025 • Travora.</p>
      </div>
    </div>
  </footer>
);

// --- HELPER COMPONENTS (ATOMS) ---

const NavButton = ({ icon, filled, onClick }) => (
  <button onClick={onClick} className={`w-14 h-14 rounded-full border-2 border-[#5E9BF5] text-[#5E9BF5] flex items-center justify-center transition hover:scale-105 ${filled ? 'bg-[#5E9BF5] text-white' : 'bg-transparent hover:bg-blue-50'}`}>
    {icon}
  </button>
);

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

const ChatBubble = ({ text, isUser }) => (
  <div className={`p-5 rounded-2xl max-w-[85%] text-base shadow-sm mb-4 leading-relaxed ${isUser ? 'bg-[#82B1FF] text-white ml-auto rounded-br-sm' : 'bg-white text-gray-700 mr-auto rounded-bl-sm border border-gray-100'}`}>
    {text}
  </div>
);

const TagButton = ({ title, icon, active }) => (
  <button className={`flex items-center px-8 py-4 rounded-2xl font-semibold mr-4 whitespace-nowrap transition-all duration-300 ${active ? 'bg-[#82B1FF] text-white shadow-lg shadow-blue-200 transform scale-105' : 'bg-white text-gray-600 border border-gray-100 hover:bg-gray-50'}`}>
    {icon && <span className="mr-3">{icon}</span>}
    {title}
  </button>
);

const TagBadge = ({ text, color }) => (
  <span className="text-white px-6 py-2.5 rounded-xl font-bold text-sm shadow-md" style={{ backgroundColor: color }}>{text}</span>
);

const IconCol = ({ icon, label }) => (
  <div className="flex flex-col items-center gap-3 text-gray-800 hover:-translate-y-1 transition duration-300 cursor-pointer p-2 rounded-xl hover:bg-white">
    <div className="text-gray-800">{icon}</div>
    <p className="text-sm font-semibold text-gray-500">{label}</p>
  </div>
);

const TicketBtn = ({ label, icon, active }) => (
  <button className={`flex items-center gap-3 px-8 py-5 rounded-2xl font-bold whitespace-nowrap border-2 transition-all ${active ? 'border-[#82B1FF] bg-white text-black shadow-lg transform -translate-y-1' : 'border-gray-100 text-gray-400 hover:border-[#82B1FF] bg-white'}`}>
    <span className={active ? 'text-[#82B1FF]' : 'text-gray-300'}>{icon}</span> {label}
  </button>
);

const CheckRow = ({ text }) => <li className="flex items-center gap-4"><div className="bg-[#82B1FF] rounded-full p-1.5 shadow-sm"><Check size={14} className="text-white" strokeWidth={4} /></div> {text}</li>;

const ReviewItem = ({ name, text }) => (
  <div className="text-left text-sm border-b border-gray-50 pb-6 last:border-0 last:pb-0">
    <div className="flex justify-between font-bold mb-3 text-gray-900 text-lg"><span>{name}</span><span className="text-gray-400 font-medium text-xs bg-gray-50 px-2 py-1 rounded">1 hari lalu</span></div>
    <div className="flex gap-1 mb-3">{[...Array(5)].map((_, i) => <Star key={i} size={16} fill="#EBC136" stroke="none" />)}</div>
    <p className="text-gray-600 font-normal leading-relaxed text-base">{text}</p>
  </div>
);

const ProfileButton = ({ icon, text, sub }) => (
  <button className="bg-white border border-gray-100 shadow-sm rounded-2xl py-6 px-8 flex items-center text-left hover:shadow-xl transition w-full transform hover:-translate-y-1 group">
    <span className="text-gray-400 mr-6 group-hover:text-[#5E9BF5] transition">{icon}</span>
    <div>
      <span className="font-bold text-xl text-gray-900 block">{text}</span>
      <span className="text-sm text-gray-400 font-light">{sub}</span>
    </div>
    <div className="ml-auto text-gray-300"><ChevronRight /></div>
  </button>
);

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

// --- CALENDAR WIDGET ---
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