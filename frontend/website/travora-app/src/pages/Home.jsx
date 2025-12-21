import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../api';
import Navbar from '../components/common/Navbar';
import HeroSection from '../components/sections/HeroSection';
import PlaceCard from '../components/cards/PlaceCard';
import PopularPlaces from '../components/sections/PopularPlaces';
import EventSection from '../components/sections/EventSection';
import ChatSection from '../components/sections/ChatSection';
import StyleCard from '../components/cards/StyleCard';

export default function Home() {
  const navigate = useNavigate();
  
  // State Pencarian
  const [isSearching, setIsSearching] = useState(false);
  const [searchResults, setSearchResults] = useState([]);
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  // Fungsi yang dipanggil saat tombol search di Hero diklik
  const handleSearch = async (query) => {
    if (!query || query.trim() === "") {
        setIsSearching(false);
        return;
    }

    setSearchQuery(query);
    setIsSearching(true);
    setSearchLoading(true);

    try {
        // --- PERBAIKAN: HAPUS '/user' AGAR SESUAI BACKEND ---
        // Backend Route: r.GET("/destinations", ...)
        const res = await api.get(`/destinations?search=${query}`);
        
        console.log("Hasil Search:", res.data);

        // Handle struktur data Go (bisa array langsung atau object { data: [] })
        const resultList = Array.isArray(res.data) ? res.data : (res.data.data || []);
        
        // Filter Manual (Opsional, jika backend belum handle ?search=query)
        const filtered = resultList.filter(item => {
             const title = item.NameDestination || item.namedestination || item.title || "";
             return title.toLowerCase().includes(query.toLowerCase());
        });

        setSearchResults(filtered);

    } catch (err) {
        console.error("Search failed", err);
        // Jika backend public, biasanya tidak return 401, tapi jaga-jaga
        if (err.response?.status === 401) {
            alert("Sesi habis, silakan login ulang.");
            navigate('/auth');
        }
    } finally {
        setSearchLoading(false);
    }
  };

  const clearSearch = () => {
    setIsSearching(false);
    setSearchQuery("");
    setSearchResults([]);
  };

  return (
    <div className="flex flex-col gap-24 pb-20 animate-fade-in">
      <HeroSection onSearch={handleSearch} />
      
      <div className="max-w-7xl mx-auto w-full px-6 flex flex-col gap-24">
        
        {/* LOGIKA TAMPILAN: SEARCH VS NORMAL HOME */}
        {isSearching ? (
              <div className="min-h-[400px]">
                  <div className="flex items-center gap-3 mb-8">
                      <button onClick={clearSearch} className="text-gray-400 hover:text-gray-600 font-bold">Home</button>
                      <span className="text-gray-300">/</span>
                      <span className="text-[#5E9BF5] font-bold">Search Results</span>
                  </div>

                  <h2 className="text-4xl font-bold text-gray-900 mb-2">Results for "{searchQuery}"</h2>
                  
                  {searchResults.length > 0 && (
                      <p className="text-gray-500 mb-10">{searchResults.length} destinations found</p>
                  )}

                  {searchLoading ? (
                      <div className="text-center py-20 text-gray-400 animate-pulse">Searching database...</div>
                  ) : searchResults.length === 0 ? (
                      <div className="text-center py-20 bg-gray-50 rounded-3xl border border-dashed border-gray-300 mt-8">
                          <p className="text-gray-500 font-bold text-xl">No results found for "{searchQuery}"</p>
                          <p className="text-gray-400">We couldn't find any destinations matching your search.</p>
                          <button onClick={clearSearch} className="mt-6 text-[#5E9BF5] font-bold underline hover:text-[#4a8cdb]">
                              Back to All Destinations
                          </button>
                      </div>
                  ) : (
                      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                          {searchResults.map((item) => (
                              <PlaceCard 
                                  key={item.ID || item.id}
                                  // Mapping Field Backend Golang (Biasanya Kapital)
                                  title={item.NameDestination || item.namedestination || item.title}
                                  subtitle={item.Location || item.location}
                                  img={item.Image || (Array.isArray(item.images) ? item.images[0] : null) || 'https://via.placeholder.com/300'}
                                  rating="4.8"
                                  onPress={() => navigate(`/destination/${item.ID || item.id}`)}
                              />
                          ))}
                      </div>
                  )}
              </div>
          ) : (
            // TAMPILAN HOME NORMAL
            <>
                <PopularPlaces />
                
                {/* Static Section: Explore Ubud */}
                <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px]">
                    <div className="max-w-7xl mx-auto">
                      <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Explore Ubud</h2>
                      <div className="h-[500px] flex gap-6">
                        <div className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg">
                            <img src="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Expl1"/>
                        </div>
                        <div className="flex-[0.8] flex flex-col gap-6">
                            <div className="flex-1 rounded-3xl overflow-hidden bg-gray-200"><img src="https://images.unsplash.com/photo-1554481923-a6918bd997bc" className="w-full h-full object-cover" alt="Expl2"/></div>
                            <div className="flex-1 rounded-3xl overflow-hidden bg-gray-200"><img src="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" className="w-full h-full object-cover" alt="Expl3"/></div>
                        </div>
                        <div className="flex-1 rounded-3xl overflow-hidden cursor-pointer group shadow-lg">
                            <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4" className="w-full h-full object-cover group-hover:scale-110 transition duration-700" alt="Expl4"/>
                        </div>
                      </div>
                    </div>
                </div>

                {/* Travel Style */}
                <div className="flex flex-col gap-10">
                    <div className="flex items-center gap-4">
                        <div className="w-2 h-10 bg-black rounded-full"></div>
                        <h2 className="text-4xl font-bold text-gray-900">Travel Style</h2>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                        <StyleCard title="Culture" desc="Heritage sites." img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2" onPress={() => navigate('/')} />
                        <StyleCard title="Nature" desc="Forest & Trek." img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62" onPress={() => navigate('/')} />
                        <StyleCard title="Culinary" desc="Best local food." img="https://images.unsplash.com/photo-1555400038-63f5ba517a47" onPress={() => navigate('/')} />
                        <StyleCard title="Art" desc="Museums & Art." img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1" onPress={() => navigate('/')} />
                    </div>
                </div>

                <div id="events-section">
                    <EventSection />
                </div>

                <ChatSection />
            </>
        )}
      </div>
    </div>
  );
}