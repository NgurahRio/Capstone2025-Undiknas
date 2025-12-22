import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api';
import PlaceCard from '../cards/PlaceCard';

export default function TravelStyle() {
  const navigate = useNavigate();
  
  // State Data
  const [categories, setCategories] = useState([]);
  const [destinations, setDestinations] = useState([]);
  const [filteredDestinations, setFilteredDestinations] = useState([]);
  
  // State UI
  const [activeCategory, setActiveCategory] = useState(null); // Menyimpan ID Kategori yang aktif
  const [loading, setLoading] = useState(true);

  // 1. FETCH CATEGORIES & DESTINATIONS
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);

        // A. Ambil Categories
        const resCat = await api.get('/categories');
        const catData = Array.isArray(resCat.data) ? resCat.data : (resCat.data.data || []);
        
        // B. Ambil All Destinations
        const resDest = await api.get('/destinations');
        const destData = Array.isArray(resDest.data) ? resDest.data : (resDest.data.data || []);

        setCategories(catData);
        setDestinations(destData);

        // Set Default Active Category (Ambil yang pertama, misal: Adventure/Culture)
        if (catData.length > 0) {
            setActiveCategory(catData[0].id_categories || catData[0].id);
        }

      } catch (err) {
        console.error("Gagal load data Travel Style:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // 2. FILTER LOGIC (Setiap kali activeCategory atau destinations berubah)
  useEffect(() => {
    if (!activeCategory || destinations.length === 0) return;

    // Filter destinasi yang punya categoryId sama dengan activeCategory
    // PENTING: Pastikan backend mengirim field 'categoryId' atau 'category_id' di object destination
    // Jika struktur DB Anda pakai 'subcategoryId', sesuaikan logika ini.
    
    const filtered = destinations.filter(item => {
        // Cek variasi penulisan field dari Backend Go/SQL
        const itemCatId = item.categoryId || item.category_id || item.roleId; // Sesuaikan dengan JSON backend
        
        // Konversi ke string untuk perbandingan aman
        return String(itemCatId) === String(activeCategory);
    });

    setFilteredDestinations(filtered);

  }, [activeCategory, destinations]);


  if (loading) return <div className="h-[300px] w-full bg-gray-100 rounded-[32px] animate-pulse"></div>;
  if (categories.length === 0) return null;

  return (
    <div className="flex flex-col gap-8 w-full">
      
      {/* --- HEADER: JUDUL & MENU KATEGORI --- */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
        
        {/* Judul */}
        <div className="flex items-center gap-4">
            <div className="w-1.5 h-8 bg-[#5E9BF5] rounded-full"></div>
            <h2 className="text-4xl font-bold text-gray-900">Travel Style</h2>
        </div>

        {/* Menu Tab / Pills (Horizontal Scroll di Mobile) */}
        <div className="flex gap-3 overflow-x-auto pb-2 hide-scrollbar">
            {categories.map((cat) => {
                const isActive = (cat.id_categories || cat.id) === activeCategory;
                return (
                    <button
                        key={cat.id_categories || cat.id}
                        onClick={() => setActiveCategory(cat.id_categories || cat.id)}
                        className={`
                            px-6 py-3 rounded-full text-sm font-bold whitespace-nowrap transition-all duration-300 border
                            ${isActive 
                                ? 'bg-[#5E9BF5] text-white border-[#5E9BF5] shadow-lg shadow-blue-200' 
                                : 'bg-white text-gray-500 border-gray-200 hover:border-[#5E9BF5] hover:text-[#5E9BF5]'}
                        `}
                    >
                        {cat.name}
                    </button>
                );
            })}
        </div>
      </div>

      {/* --- RESULT GRID (MUNCUL DI BAWAH MENU) --- */}
      <div className="w-full min-h-[300px]">
          {filteredDestinations.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 animate-fade-in">
                  {filteredDestinations.slice(0, 4).map((item) => {
                      // Helper Image (Sama seperti sebelumnya)
                      let img = item.Image || (Array.isArray(item.images) ? item.images[0] : null);
                      if (!img) img = 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';

                      return (
                          <PlaceCard 
                              key={item.ID || item.id_destination}
                              title={item.NameDestination || item.namedestination || item.title}
                              subtitle={item.Location || item.location}
                              img={img}
                              rating="4.8"
                              onPress={() => navigate(`/destination/${item.ID || item.id_destination}`)}
                          />
                      );
                  })}
              </div>
          ) : (
              // Tampilan Kosong Jika Tidak Ada Destinasi di Kategori Ini
              <div className="flex flex-col items-center justify-center h-[300px] bg-gray-50 rounded-[32px] border border-dashed border-gray-200">
                  <p className="text-gray-400 font-medium">No destinations found for this category.</p>
              </div>
          )}
      </div>

    </div>
  );
}