import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { api } from '../api';
import { 
  MapPin, Bookmark, Star, Camera, Square, User, Users, ShoppingBag, Utensils, 
  ShieldAlert, CheckCircle, Info, Ticket, ChevronLeft, ChevronRight, Wifi, Car, Moon, Tag, Clock, FileText
} from 'lucide-react';

export default function Destination() {
  const { id } = useParams();
  const navigate = useNavigate();
  
  // --- STATE ---
  const [data, setData] = useState(null);
  const [packages, setPackages] = useState([]); // State untuk Package
  const [otherDest, setOtherDest] = useState([]);
  const [loading, setLoading] = useState(true);
  const [imgIndex, setImgIndex] = useState(0);
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [activeTab, setActiveTab] = useState('ticket');

  // State Review
  const [reviews, setReviews] = useState([]);
  const [userRating, setUserRating] = useState(0);
  const [userComment, setUserComment] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);

  // --- 1. HELPER IMAGE SCANNER ---
  const findAllImagesInObject = (obj) => {
      if (!obj) return [];
      const stringifiedData = JSON.stringify(obj);
      const regexBase64 = /\/9j\/[A-Za-z0-9+/=]+/g;
      const foundBase64 = stringifiedData.match(regexBase64);
      let results = [];
      if (foundBase64 && foundBase64.length > 0) {
          const base64Images = foundBase64.map(str => `data:image/jpeg;base64,${str}`);
          results = [...results, ...base64Images];
      }
      const regexUrl = /https?:\/\/[^"\s\\]+/g;
      const foundUrl = stringifiedData.match(regexUrl);
      if (foundUrl && foundUrl.length > 0) {
           results = [...results, ...foundUrl];
      }
      return [...new Set(results)];
  };

  const pickRandom = (arr, limit) => {
    const copy = [...arr];
    for (let i = copy.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [copy[i], copy[j]] = [copy[j], copy[i]];
    }
    return copy.slice(0, limit);
  };

  const parseList = (text) => {
    if (!text) return [];
    if (text.trim().startsWith('[')) { try { return JSON.parse(text); } catch(e) {} }
    return text.split(/\r?\n|,/).filter(item => item.trim() !== "");
  };

  // --- 2. FACILITY LOGIC (PURE DATABASE) ---
  const getFacilityIcon = (dbName) => {
      if (!dbName) return <CheckCircle size={24}/>;
      const lower = dbName.toLowerCase();
      
      const iconMap = {
          'park': <Car size={24}/>,
          'toilet': <Info size={24}/>, 'wc': <Info size={24}/>,
          'musholla': <Moon size={24}/>, 'prayer': <Moon size={24}/>, 'masjid': <Moon size={24}/>,
          'resto': <Utensils size={24}/>, 'makan': <Utensils size={24}/>, 'food': <Utensils size={24}/>,
          'shop': <ShoppingBag size={24}/>, 'toko': <ShoppingBag size={24}/>, 'souvenir': <ShoppingBag size={24}/>,
          'photo': <Camera size={24}/>, 'foto': <Camera size={24}/>, 'spot': <Camera size={24}/>,
          'wifi': <Wifi size={24}/>, 'internet': <Wifi size={24}/>,
          'guide': <Users size={24}/>, 'pemandu': <Users size={24}/>,
          'ticket': <Ticket size={24}/>, 'tiket': <Ticket size={24}/>
      };

      const match = Object.keys(iconMap).find(key => lower.includes(key));
      return match ? iconMap[match] : <CheckCircle size={24}/>;
  };

  const getFacilities = (sourceData) => {
    if (!sourceData) return [];
    // Prioritas: Ambil dari array facilities (Join Table)
    if (sourceData.facilities && Array.isArray(sourceData.facilities) && sourceData.facilities.length > 0) {
        return sourceData.facilities.map(fac => {
            const realName = fac.namefacility || fac.name_facility || fac.Name || fac.name || "Facility";
            const rawIcon = fac.icon || fac.Icon || "";
            let iconEl = null;
            if (rawIcon && typeof rawIcon === 'string') {
              const src = rawIcon.startsWith('http') || rawIcon.startsWith('data:')
                ? rawIcon
                : `data:image/png;base64,${rawIcon}`;
              iconEl = <img src={src} alt={realName} className="w-6 h-6 object-contain" />;
            } else {
              iconEl = getFacilityIcon(realName);
            }
            return { name: realName, icon: iconEl };
        });
    }
    return [];
  };

  const averageRating = () => {
      if (!reviews || reviews.length === 0) return 0;
      const total = reviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0), 0);
      return (total / reviews.length).toFixed(1);
  };

  const formatRating = (val) => {
    const num = parseFloat(val);
    return Number.isFinite(num) && num > 0 ? num.toFixed(1) : 'New';
  };

  const getReviewerName = (rev) => rev.user?.username || rev.User?.username || rev.username || "Traveler";
  const getReviewerAvatar = (rev) => {
    const img = rev.user?.image || rev.User?.image || "";
    if (!img) return `https://ui-avatars.com/api/?name=${encodeURIComponent(getReviewerName(rev))}&background=5E9BF5&color=fff`;
    if (typeof img === 'string' && !img.startsWith('http') && !img.startsWith('data:')) {
      return `data:image/jpeg;base64,${img}`;
    }
    return img;
  };

  const cleanText = (text) => {
      if (!text || typeof text !== 'string') return text;
      return text.replace(/Ã¢â‚¬â„¢/g, "'").replace(/Ã¢â‚¬Å“/g, '"').replace(/Ã¢â‚¬/g, '"');
  };

  // --- FETCH DATA ---
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        
        // 1. GET DESTINATION DETAIL
        const resDetail = await api.get(`/destinations/${id}`);
        const destData = resDetail.data.data || resDetail.data; 
        const finalData = Array.isArray(destData) ? destData[0] : destData;
        if (!finalData) throw new Error("Data kosong");
        setData(finalData);

        // 2. GET PACKAGES (Sesuai Struktur Database Baru)
        try {
            const resPkg = await api.get(`/package`); // Ambil semua package dulu
            const pkgData = resPkg.data.data || resPkg.data;
            
            if (Array.isArray(pkgData)) {
                // Filter paket yang destination_id nya cocok dengan ID halaman ini
                // Menggunakan 'destination_id' (snake_case) sesuai request
                const relevantPackages = pkgData.filter(p => 
                    String(p.destination_id || p.destinationId) === String(id)
                );
                setPackages(relevantPackages);
            }
        } catch (pkgError) {
            console.log("Package data fetch error:", pkgError);
        }

        // 3. GET REVIEWS
        try {
            const resRev = await api.get(`/review`, { params: { destinationId: id } });
            const apiReviews = resRev.data.data || resRev.data;
            if (Array.isArray(apiReviews)) {
                setReviews(apiReviews.filter(r => String(r.destinationId || r.destination_id) === String(id)));
            }
        } catch (error) {
            console.warn("Review fetch error:", error);
        }

        const userStr = localStorage.getItem('travora_user'); 
        if (userStr) setCurrentUser(JSON.parse(userStr));

        // cek bookmark dari backend
        const token = localStorage.getItem('travora_token');
        if (token) {
          try {
            const favRes = await api.get('/user/favorite');
            const favs = favRes.data?.favorites || [];
            const found = favs.some((f) => String(f.destinationId || f.destination_id) === String(id));
            setIsBookmarked(found);
          } catch (favErr) {
            console.warn('Gagal cek favorite backend:', favErr);
          }
        } else {
          // fallback: local storage (mode lama)
          const savedBookmarks = JSON.parse(localStorage.getItem('travora_bookmarks') || '[]');
          setIsBookmarked(savedBookmarks.some(item => String(item.id) === String(id)));
        }

        // 6. DESTINATION LAIN (acak rekomendasi maks 8 + rating backend)
        try {
          const resAll = await api.get('/destinations');
          const all = Array.isArray(resAll.data) ? resAll.data : resAll.data.data || [];
          const filtered = all.filter((d) => String(d.id_destination || d.id || d.ID) !== String(id));

          const withRating = await Promise.all(
            filtered.map(async (dest) => {
              const destId = dest.id_destination || dest.id || dest.ID;
              let calculatedRating = 0;
              try {
                const resRev = await api.get('/review', { params: { destinationId: destId } });
                const reviews = resRev.data.data || resRev.data;
                if (Array.isArray(reviews) && reviews.length > 0) {
                  const total = reviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0), 0);
                  calculatedRating = total / reviews.length;
                }
              } catch (revErr) {
                console.warn('Gagal ambil rating rekomendasi:', revErr);
              }
              return { ...dest, calculatedRating };
            })
          );

          setOtherDest(pickRandom(withRating, 8));
        } catch (errAll) {
          console.warn('Gagal load destinasi lain:', errAll);
        }

      } catch (err) {
        console.error("Error:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  // --- ACTIONS ---
  const handleSubmitReview = async (e) => {
      e.preventDefault();
      if (!currentUser) { navigate('/auth'); return; }
      if (userRating === 0) return alert("Pilih bintang dulu.");
      
      setIsSubmitting(true);
      try { 
        await api.post('/user/review', { destinationId: parseInt(id), rating: parseInt(userRating), comment: userComment }); 
        // refresh reviews from backend
        const resRev = await api.get(`/review`, { params: { destinationId: id } });
        const apiReviews = resRev.data.data || resRev.data;
        if (Array.isArray(apiReviews)) {
            setReviews(apiReviews.filter(r => String(r.destinationId || r.destination_id) === String(id)));
        }
        setUserRating(0); 
        setUserComment(""); 
        alert("Review berhasil dikirim!");
      } catch (error) {
        console.error("Review submit error:", error);
        const msg = error?.response?.data?.error || "Gagal mengirim review.";
        alert(msg);
      } finally {
        setIsSubmitting(false);
      }
  };

  const handleBookmark = async () => {
    const token = localStorage.getItem('travora_token');
    if (!currentUser || !token) {
      navigate('/auth');
      return;
    }

    try {
      if (isBookmarked) {
        await api.delete(`/user/favorite/${id}`);
        setIsBookmarked(false);
      } else {
        await api.post('/user/favorite', { destinationId: Number(id) });
        setIsBookmarked(true);
      }
    } catch (err) {
      console.error('Bookmark action failed:', err?.response?.data || err);
      const msg = err?.response?.data?.error || 'Gagal memperbarui bookmark. Pastikan sudah login.';
      alert(msg);
    }
  };

  if (loading) return <div className="h-screen flex items-center justify-center font-bold text-gray-400">Loading...</div>;
  if (!data) return <div className="h-screen flex items-center justify-center">Data Not Found</div>;

  // --- VARS ---
  const placeholderImg = 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?auto=format&fit=crop&w=1600&q=80';
  const images = findAllImagesInObject(data);
  const displayImages = (() => {
    const filtered = images.filter(
      (img) => typeof img === 'string' && (img.startsWith('http') || img.startsWith('data:'))
    );
    return filtered.length > 0 ? filtered : [placeholderImg];
  })();
  const title = cleanText(data.namedestination || data.NameDestination);
  const location = cleanText(data.location);
  const description = cleanText(data.description);
  const operational = cleanText(data.operational);
  const mapsLink = data.maps;
  const doList = parseList(data.do).map(cleanText);
  const dontList = parseList(data.dont).map(cleanText);
  const safety = cleanText(data.safety);
  const facilities = getFacilities(data);

  const currentImg = displayImages[imgIndex] || placeholderImg;
  const nextImage = () => setImgIndex((prev) => (prev === displayImages.length - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? displayImages.length - 1 : prev - 1));

  return (
    <div className="w-full pb-20 bg-white min-h-screen font-sans text-[#1F2937]">
      
      {/* HEADER */}
      <div className="w-full h-[350px] relative flex items-center justify-center bg-gray-900 overflow-hidden">
          {currentImg ? <img src={currentImg} alt="Banner" className="absolute inset-0 w-full h-full object-cover opacity-60 blur-sm scale-105" /> : <div className="absolute inset-0 bg-gray-800 opacity-90"></div>}
          <div className="absolute inset-0 bg-gradient-to-b from-black/60 to-transparent"></div>
          <div className="relative z-10 text-center"><h1 className="text-5xl md:text-6xl font-normal text-white tracking-wide"><span className="font-light opacity-80">|</span> Destination</h1></div>
      </div>

      {/* SLIDER */}
      <div className="max-w-6xl mx-auto w-full px-6 lg:px-8 py-10">
          <div className="flex items-center gap-2 mb-6 text-base text-gray-500 font-medium">
            <span className="text-[#5E9BF5] cursor-pointer hover:underline" onClick={() => navigate('/')}>Home</span>
            <span className="text-gray-300">›</span>
            <span className="text-gray-700">Destination</span>
          </div>
          <div className="w-full h-[400px] md:h-[550px] rounded-[40px] overflow-hidden relative shadow-2xl mb-6 group bg-gray-100 border border-gray-200">
              <img src={currentImg} className="w-full h-full object-cover transition-transform duration-700 hover:scale-105" alt={title} onError={(e)=>{e.currentTarget.src=placeholderImg;}} />

              {displayImages.length > 1 && (
                <>
                  <button onClick={prevImage} className="absolute left-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full bg-white/85 backdrop-blur border border-gray-200 shadow-md flex items-center justify-center text-gray-600 hover:bg-white hover:text-[#5E9BF5] transition">
                    <ChevronLeft size={24} />
                  </button>
                  <button onClick={nextImage} className="absolute right-4 top-1/2 -translate-y-1/2 w-12 h-12 rounded-full bg-white/85 backdrop-blur border border-gray-200 shadow-md flex items-center justify-center text-gray-600 hover:bg-white hover:text-[#5E9BF5] transition">
                    <ChevronRight size={24} />
                  </button>

                </>
              )}
          </div>
      </div>

      {/* DETAIL */}
      <div className="max-w-7xl mx-auto w-full px-6 lg:px-10 py-10 border-t border-gray-100 mt-8">
        <div className="flex flex-col lg:flex-row gap-12">
            <div className="lg:w-2/3 space-y-10">
                <div className="flex justify-between items-start">
                    <div><h2 className="text-4xl font-extrabold text-gray-900 mb-2">{title}</h2><div className="flex items-center gap-2 text-gray-500 text-lg"><MapPin size={22} className="text-gray-800" /><span>{location}</span></div></div>
                    <button onClick={handleBookmark} className="mt-1">
                      <Bookmark
                        size={40}
                        className={`transition duration-300 drop-shadow-sm ${
                          isBookmarked
                            ? 'fill-[#5E9BF5] text-[#5E9BF5]'
                            : 'text-gray-300 hover:text-[#5E9BF5]'
                        }`}
                      />
                    </button>
                </div>
                <p className="text-gray-600 text-lg leading-relaxed text-justify whitespace-pre-line">{description || "No description available."}</p>
                
                {/* FACILITIES */}
                <div>
                    <h3 className="text-2xl font-bold text-gray-900 mb-6">Facilities</h3>
                    {facilities.length > 0 ? (
                        <div className="flex flex-wrap gap-8">{facilities.map((fac, idx) => (<div key={idx} className="flex flex-col items-center gap-2 group cursor-default"><div className="p-4 bg-white border border-gray-200 rounded-2xl group-hover:border-[#5E9BF5] group-hover:text-[#5E9BF5] transition duration-300 shadow-sm text-gray-600">{fac.icon}</div><span className="text-sm font-medium text-gray-500">{fac.name}</span></div>))}</div>
                    ) : <p className="text-gray-400 italic">No facilities information available in database.</p>}
                </div>

                {/* TABS INFO */}
                <div className="mt-4">
                    <h3 className="text-2xl font-bold text-gray-900 mb-6">Info & Guide</h3>
                    <div className="flex flex-wrap gap-4 mb-6">
                        {['ticket', 'dodont', 'safety'].map((tab) => (
                            <button key={tab} onClick={() => setActiveTab(tab)} className={`px-8 py-3 rounded-xl font-bold transition flex items-center gap-2 shadow-sm ${activeTab === tab ? 'bg-[#5E9BF5] text-white' : 'bg-white border border-gray-200 text-gray-500 hover:bg-gray-50'}`}>
                                {tab === 'ticket' && <Ticket size={18}/>}{tab === 'dodont' && <CheckCircle size={18}/>}{tab === 'safety' && <ShieldAlert size={18}/>}{tab === 'ticket' ? 'Ticket / Packages' : tab === 'dodont' ? "Do & Don't" : 'Safety'}
                            </button>
                        ))}
                    </div>
                    
                    <div className="bg-white border border-gray-100 rounded-3xl p-8 shadow-xl">
                        {/* TAB TICKET: TAMPILKAN PACKAGE DARI DATABASE */}
                        {activeTab === 'ticket' && (
                            <div className="animate-fade-in space-y-6">
                                {packages.length > 0 ? (
                                    packages.map((pkg) => (
                                        <div key={pkg.id_package} className="border-b border-gray-100 pb-6 last:border-0 last:pb-0">
                                            <div className="flex items-center gap-3 mb-2">
                                                {/* Menggunakan nama subpackage */}
                                                <Tag className="text-[#5E9BF5]" size={24}/>
                                                <h4 className="text-xl font-bold text-gray-900">{pkg.subpackage || pkg.sub_package}</h4>
                                            </div>
                                            {/* Menggunakan data deskripsi */}
                                            <div className="flex gap-3">
                                                <FileText className="text-gray-400 mt-1 flex-shrink-0" size={20} />
                                                <div className="text-gray-600 text-sm leading-relaxed whitespace-pre-line">
                                                    {pkg.data || "No details available."}
                                                </div>
                                            </div>
                                        </div>
                                    ))
                                ) : (
                                    // FALLBACK: JIKA TIDAK ADA PACKAGE, TAMPILKAN JAM BUKA
                                    <div>
                                        <div className="flex items-center gap-3 mb-2 text-gray-900">
                                            <Clock className="text-[#5E9BF5]" size={24}/>
                                            <h4 className="text-xl font-bold">Operational Hours</h4>
                                        </div>
                                        <div className="ml-9 text-xl font-medium text-gray-700">
                                            {operational || "Contact for Info"}
                                        </div>
                                        <p className="ml-9 text-sm text-gray-400 mt-2">
                                            Package information is currently unavailable for this destination.
                                        </p>
                                    </div>
                                )}
                            </div>
                        )}

                        {activeTab === 'dodont' && (
                            <div className="animate-fade-in grid md:grid-cols-2 gap-8"><div><h5 className="font-bold text-green-600 mb-3">Do's</h5><ul className="list-disc pl-4 text-sm text-gray-600 space-y-2">{doList.length > 0 ? doList.map((l,i)=><li key={i}>{l}</li>) : <li>Respect nature</li>}</ul></div><div><h5 className="font-bold text-red-600 mb-3">Don'ts</h5><ul className="list-disc pl-4 text-sm text-gray-600 space-y-2">{dontList.length > 0 ? dontList.map((l,i)=><li key={i}>{l}</li>) : <li>Do not litter</li>}</ul></div></div>
                        )}
                        {activeTab === 'safety' && (
                            <div className="animate-fade-in"><h4 className="font-bold text-gray-900 mb-2">Safety Guidelines</h4><p className="text-gray-600">{safety || "Always follow the instructions of the local guide and staff."}</p></div>
                        )}
                    </div>
                </div>
            </div>

            <div className="lg:w-1/3 flex flex-col gap-8">
                {/* MAPS */}
                <div className="bg-white p-4 rounded-[32px] shadow-lg border border-gray-100">
                    <div className="w-full h-[250px] bg-gray-200 rounded-2xl overflow-hidden relative group">
                        {mapsLink && mapsLink.includes('<iframe') ? (
                            <div dangerouslySetInnerHTML={{ __html: mapsLink.replace(/width="\d+"/g, 'width="100%"').replace(/height="\d+"/g, 'height="100%"') }} className="w-full h-full" />
                        ) : (
                            <iframe title="Map Location" width="100%" height="100%" style={{ border: 0 }} loading="lazy" allowFullScreen src={`https://maps.google.com/maps?q=${encodeURIComponent(location || title)}&t=&z=13&ie=UTF8&iwloc=&output=embed`}></iframe>
                        )}
                    </div>
                    <a href={mapsLink && !mapsLink.includes('<iframe') ? mapsLink : `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(location || title)}`} target="_blank" rel="noreferrer" className="w-full mt-4 bg-gray-100 hover:bg-[#EBC136] hover:text-white text-gray-700 font-bold py-3 rounded-xl flex justify-center items-center gap-2 transition duration-300"><MapPin size={18} /> Open in Google Maps</a>
                </div>

                {/* REVIEWS */}
                <div className="bg-white p-6 rounded-[32px] shadow-xl border border-gray-100 text-center">
                    <h3 className="text-2xl font-bold text-gray-900 mb-1">Reviews</h3>
                    <div className="text-5xl font-extrabold text-[#EBC136] mb-2">{averageRating()}</div>
                    <div className="flex justify-center gap-1 mb-2">{[1,2,3,4,5].map(i => <Star key={i} size={20} fill={i <= Math.round(parseFloat(averageRating())) ? "#EBC136" : "#E5E7EB"} stroke="none" />)}</div>
                    <p className="text-xs text-gray-400 mb-6">Based on {reviews.length} reviews</p>

                    {currentUser ? (
                        <form onSubmit={handleSubmitReview} className="mb-6 text-left border-t pt-4 border-gray-100">
                            <div className="flex gap-2 mb-3 justify-center">{[1,2,3,4,5].map((star) => (<Star key={star} size={28} className={`cursor-pointer transition hover:scale-110 ${star <= userRating ? 'fill-[#EBC136] text-[#EBC136]' : 'text-gray-300'}`} onClick={() => setUserRating(star)} />))}</div>
                            <textarea className="w-full border rounded-xl p-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#5E9BF5] resize-none bg-gray-50" rows="2" placeholder="Write a review..." value={userComment} onChange={(e) => setUserComment(e.target.value)}></textarea>
                            <button type="submit" disabled={isSubmitting} className="w-full mt-2 bg-[#5E9BF5] text-white py-2 rounded-xl font-bold hover:bg-[#4a90e2] flex justify-center items-center gap-2 transition">{isSubmitting ? 'Sending...' : 'Kirim'}</button>
                        </form>
                    ) : ( <div className="mb-6 bg-blue-50 p-3 rounded-xl text-sm text-blue-600 cursor-pointer hover:underline" onClick={() => navigate('/auth')}>Login to write a review</div> )}

                    <div className="text-left space-y-4 max-h-[300px] overflow-y-auto pr-1 custom-scrollbar">
                        {reviews.length > 0 ? reviews.map((rev) => (
                            <div key={rev.id_review} className="border-b border-gray-50 pb-3 last:border-0 flex gap-3">
                                <div className="w-10 h-10 rounded-full overflow-hidden bg-gray-200 flex-shrink-0">
                                    <img src={getReviewerAvatar(rev)} alt={getReviewerName(rev)} className="w-full h-full object-cover" />
                                </div>
                                <div className="flex-1">
                                    <div className="flex justify-between mb-1">
                                        <h5 className="font-bold text-gray-900 text-sm">{getReviewerName(rev)}</h5>
                                        <span className="text-[10px] text-gray-400">{rev.created_at ? new Date(rev.created_at).toLocaleDateString() : "Just now"}</span>
                                    </div>
                                    <div className="flex gap-0.5 mb-1">{[...Array(5)].map((_, i) => <Star key={i} size={10} fill={i < rev.rating ? "#EBC136" : "#E5E7EB"} stroke="none"/>)}</div>
                                    <p className="text-xs text-gray-500 line-clamp-2">{cleanText(rev.comment)}</p>
                                </div>
                            </div>
                        )) : <p className="text-xs text-gray-400 italic text-center py-4">No reviews yet.</p>}
                    </div>
                </div>
            </div>
        </div>
      </div>

      {/* ALL DESTINATION */}
      {otherDest.length > 0 && (
        <div className="max-w-7xl mx-auto w-full px-6 lg:px-10 py-10">
          <h3 className="text-2xl font-bold text-gray-900 mb-6">Destination Recommendations</h3>
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {otherDest.map((item) => {
              const imgs = findAllImagesInObject(item);
              const img = imgs[0] || placeholderImg;
              const rating = formatRating(item.rating || item.calculatedRating);
              const tag = (item.subcategory && item.subcategory[0]?.namesubcategories) || item.category || 'Recommended';
              const desc = item.description || 'Discover this amazing destination.';
              return (
                <div
                  key={item.id_destination || item.id || item.ID}
                  onClick={() => navigate(`/destination/${item.id_destination || item.id || item.ID}`)}
                  className="rounded-[18px] overflow-hidden shadow-md border border-gray-100 bg-white hover:-translate-y-1 transition cursor-pointer flex flex-col"
                >
                  <div className="h-36 w-full overflow-hidden">
                    <img src={img} alt={item.namedestination} className="w-full h-full object-cover" />
                  </div>
                  <div className="p-4 flex flex-col gap-2 flex-1">
                    <div className="flex items-center justify-between text-sm font-semibold text-gray-700">
                      <div className="flex items-center gap-2">
                        <Star size={16} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
                        <span>{rating}</span>
                      </div>
                      <span className="text-[11px] font-semibold text-[#2f5aa5] bg-[#E9F2FF] px-3 py-1 rounded-full">
                        {tag}
                      </span>
                    </div>
                    <h4 className="font-bold text-gray-900 text-base leading-tight line-clamp-2">{item.namedestination || item.NameDestination}</h4>
                    <p className="text-sm text-gray-500 leading-snug line-clamp-2">{desc}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}


