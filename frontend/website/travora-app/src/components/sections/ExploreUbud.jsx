import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { MapPin } from 'lucide-react';
import { api } from '../../api';

export default function ExploreUbud() {
  const navigate = useNavigate();
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await api.get('/destinations');
        // Handle struktur data Go: array langsung atau { data: [] }
        const allData = Array.isArray(res.data) ? res.data : (res.data.data || []);

        // 1. Prioritas: Cari yang ada kata "Ubud"
        let ubudData = allData.filter(item => 
            (item.location && item.location.toLowerCase().includes('ubud')) ||
            (item.namedestination && item.namedestination.toLowerCase().includes('ubud'))
        );

        // 2. Jika data Ubud kurang dari 4, ambil sisa dari data lain di database (biar layout penuh)
        if (ubudData.length < 4) {
            const otherData = allData.filter(item => !ubudData.includes(item));
            ubudData = [...ubudData, ...otherData];
        }

        // 3. Ambil 4 item pertama (Murni dari DB)
        setItems(ubudData.slice(0, 4));

      } catch (err) {
        console.error("Error fetching data:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // FUNGSI PROSES GAMBAR DARI SQL (Murni, Tanpa Placeholder)
  const processImage = (item) => {
    if (!item) return "";

  
    let raw = Array.isArray(item.images) && item.images.length > 0 ? item.images[0] : null;


    if (!raw) raw = item.imagedata || item.Image || item.image;

    if (!raw) return "";

    try {
      if (typeof raw === 'string' && raw.trim().startsWith('[')) {
        const parsed = JSON.parse(raw);
        if (Array.isArray(parsed) && parsed.length > 0) {
          raw = parsed[0];
        }
      }
    } catch (e) {
      console.log("JSON Parse error for image, using raw string");
    }

    if (raw && !raw.startsWith('http') && !raw.startsWith('data:')) {
      return `data:image/jpeg;base64,${raw}`;
    }

    return raw;
  };

  if (loading) return <div className="h-[500px] w-full bg-gray-100 rounded-[40px] animate-pulse my-10"></div>;
  
  // Jika database benar-benar kosong (0 data), sembunyikan section
  if (items.length === 0) return null;

  // Destructuring item (bisa undefined jika DB total < 4)
  const [item1, item2, item3, item4] = items;

  // COMPONENT CARD KECIL
  const UbudCard = ({ item, className }) => {
    // Jika item undefined (data DB kurang dari 4), render kotak kosong/transparan
    if (!item) return <div className={`bg-gray-100 ${className}`}></div>;

    const imgUrl = processImage(item);

    return (
        <div 
            onClick={() => navigate(`/destination/${item.id_destination || item.id || item.ID}`)}
            className={`relative overflow-hidden cursor-pointer group shadow-lg transition-all duration-300 ${className}`}
        >
            {/* GAMBAR */}
            {imgUrl ? (
                <img 
                    src={imgUrl} 
                    className="w-full h-full object-cover group-hover:scale-110 transition duration-700" 
                    alt={item.namedestination} 
                />
            ) : (
                // Jika imagedata di DB kosong stringnya
                <div className="w-full h-full bg-gray-200 flex items-center justify-center text-gray-400 text-xs">
                    No Image
                </div>
            )}

            {/* OVERLAY TIPIS */}
            <div className="absolute inset-0 bg-black/10 group-hover:bg-black/5 transition"></div>
        </div>
    );
  };

  return (
    <div className="bg-[#F2F7FB] -mx-6 lg:-mx-20 px-6 lg:px-20 py-24 rounded-[40px] mt-10">
      <div className="max-w-7xl mx-auto">
        <h2 className="text-4xl font-bold text-center mb-12 text-gray-900">Explore Ubud</h2>
        
        {/* LAYOUT FLEXBOX */}
        <div className="flex flex-col md:flex-row h-auto md:h-[500px] gap-6">
            
            {/* KIRI (BESAR) - Item 1 */}
            <div className="flex-1 rounded-3xl overflow-hidden">
                <UbudCard item={item1} className="w-full h-full" />
            </div>

            {/* TENGAH (TUMPUK 2) - Item 2 & 3 */}
            <div className="flex-[0.8] flex flex-col gap-6">
                <div className="flex-1 rounded-3xl overflow-hidden">
                    <UbudCard item={item2} className="w-full h-full" />
                </div>
                <div className="flex-1 rounded-3xl overflow-hidden">
                    <UbudCard item={item3} className="w-full h-full" />
                </div>
            </div>

            {/* KANAN (BESAR) - Item 4 */}
            <div className="flex-1 rounded-3xl overflow-hidden">
                <UbudCard item={item4} className="w-full h-full" />
            </div>

        </div>
      </div>
    </div>
  );
}
