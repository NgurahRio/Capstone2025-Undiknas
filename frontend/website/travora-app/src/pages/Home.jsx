import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../api';
import HeroSection from '../components/sections/HeroSection';
import PlaceCard from '../components/cards/PlaceCard';
import PopularPlaces from '../components/sections/PopularPlaces';
import ExploreUbud from '../components/sections/ExploreUbud';
import TravelStyle from '../components/sections/TravelStyle'; // <--- IMPORT INI
import EventSection from '../components/sections/EventSection';
import ChatSection from '../components/sections/ChatSection';

export default function Home() {
  const navigate = useNavigate();
  const [isSearching, setIsSearching] = useState(false);
  const [searchResults, setSearchResults] = useState([]);
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  const handleSearch = async (query) => {
    // ... (Logika search tetap sama, tidak berubah) ...
    if (!query || query.trim() === "") { setIsSearching(false); return; }
    setSearchQuery(query); setIsSearching(true); setSearchLoading(true);
    try {
        const res = await api.get(`/destinations`);
        const resultList = Array.isArray(res.data) ? res.data : (res.data.data || []);
        const filtered = resultList.filter(item => {
             const title = item.NameDestination || item.namedestination || item.title || "";
             return title.toLowerCase().includes(query.toLowerCase());
        });
        setSearchResults(filtered);
    } catch (err) { console.error(err); } finally { setSearchLoading(false); }
  };

  const clearSearch = () => { setIsSearching(false); setSearchQuery(""); setSearchResults([]); };

  return (
    <div className="flex flex-col gap-24 pb-20 animate-fade-in">
      <HeroSection onSearch={handleSearch} />
      
      <div className="max-w-7xl mx-auto w-full px-6 flex flex-col gap-24">
        
        {isSearching ? (
             /* TAMPILAN SEARCH RESULTS (Tetap sama) */
              <div className="min-h-[400px]">
                  {/* ... Kode search result sebelumnya ... */}
                  <div className="flex items-center gap-3 mb-8">
                       <button onClick={clearSearch} className="font-bold text-gray-400">Home</button>
                       <span>/</span> <span className="text-[#5E9BF5] font-bold">Search</span>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                      {searchResults.map(item => (
                          <PlaceCard key={item.id_destination} title={item.namedestination} subtitle={item.location} img={item.imagedata} onPress={() => navigate(`/destination/${item.id_destination}`)} />
                      ))}
                  </div>
              </div>
          ) : (
            // === TAMPILAN HOME NORMAL ===
            <>
                {/* 1. Popular Places */}
                <PopularPlaces />
                
                {/* 2. Explore Ubud */}
                <ExploreUbud />

                {/* 3. Travel Style (MENU TAB DYNAMIC) */}
                {/* GANTI STYLECARD MANUAL DENGAN COMPONENT INI */}
                <TravelStyle />

                {/* 4. Events */}
                <div id="events-section">
                    <EventSection />
                </div>

                {/* 5. Chat */}
                <ChatSection />
            </>
        )}
      </div>
    </div>
  );
}