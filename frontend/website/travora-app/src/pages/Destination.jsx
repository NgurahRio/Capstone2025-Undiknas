import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { api } from '../api';
import { 
  ArrowLeft, ArrowRight, MapPin, Heart, Star, 
  Camera, Square, User, ShoppingBag, Utensils, 
  Clock, ShieldAlert, CheckCircle, XCircle, Info, Ticket, Send, ChevronLeft, ChevronRight 
} from 'lucide-react';

export default function Destination() {
  const { id } = useParams();
  const navigate = useNavigate();
  
  // --- STATE ---
  const [data, setData] = useState(null);
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

  // --- 1. HELPER IMAGE ---
  const getImageArray = (sourceData) => {
      const target = sourceData || data;
      if (!target) return ['https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80'];
      
      let raw = target.imagedata || target.Image || target.image;
      if (typeof raw === 'string' && (raw.startsWith('[') || raw.startsWith('{'))) {
          try {
              const parsed = JSON.parse(raw);
              return Array.isArray(parsed) && parsed.length > 0 ? parsed : [raw];
          } catch(e) { return [raw]; }
      }
      return [raw || 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80']; 
  };

  const parseList = (text) => {
    if (!text) return [];
    if (text.trim().startsWith('[')) { try { return JSON.parse(text); } catch(e) {} }
    return text.split(/\r?\n|,/).filter(item => item.trim() !== "");
  };

  const getFacilities = (idsString) => {
    if (!idsString) return [];
    const ids = String(idsString).split(',').map(s => s.trim());
    const facilityDict = {
        '1': { name: 'Parking', icon: <Square size={24}/> },
        '2': { name: 'Toilet', icon: <Info size={24}/> },
        '3': { name: 'Musholla', icon: <User size={24}/> },
        '4': { name: 'Resto', icon: <Utensils size={24}/> },
        '5': { name: 'Shop', icon: <ShoppingBag size={24}/> },
        '11': { name: 'Photo Spot', icon: <Camera size={24}/> },
        '12': { name: 'WiFi', icon: <Info size={24}/> },
        '13': { name: 'Guide', icon: <User size={24}/> },
        '14': { name: 'Ticket', icon: <Ticket size={24}/> },
    };
    return ids.map(id => facilityDict[id] || { name: 'Facility', icon: <Info size={24}/> });
  };

  // --- 2. HELPER RATING ---
  const averageRating = () => {
      if (!reviews || reviews.length === 0) return 0;
      const total = reviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0), 0);
      const avg = total / reviews.length;
      return avg % 1 === 0 ? avg : avg.toFixed(1);
  };

  // --- 3. FETCH DATA (UPDATED) ---
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        
        // A. DESTINASI (Route: /destinations/:id)
        const resDetail = await api.get(`/destinations/${id}`);
        const destData = resDetail.data.data || resDetail.data; 
        const finalData = Array.isArray(destData) ? destData[0] : destData;
        if (!finalData) throw new Error("Data kosong");
        setData(finalData);

        // B. REVIEW (FIXED: Route /review dengan query param)
        try {
            // Karena route Backend adalah r.GET("/review"), kita kirim param
            const resRev = await api.get(`/review`, {
                params: { destination_id: id } // Akan menjadi /review?destination_id=26
            });
            const revData = resRev.data.data || resRev.data;
            
            // Filter manual di frontend (jaga-jaga jika backend return semua data)
            const filteredReviews = Array.isArray(revData) 
                ? revData.filter(r => String(r.destinationId || r.destination_id) === String(id))
                : [];
                
            setReviews(filteredReviews);
        } catch (error) {
            console.log("Review belum ada atau API error:", error);
            setReviews([]); 
        }

        // C. CEK LOGIN (Key: 'travora_user')
        const userStr = localStorage.getItem('travora_user');
        if (userStr) setCurrentUser(JSON.parse(userStr));

        // D. BOOKMARK
        const savedBookmarks = JSON.parse(localStorage.getItem('travora_bookmarks') || '[]');
        const isSaved = savedBookmarks.some(item => String(item.id) === String(id));
        setIsBookmarked(isSaved);

      } catch (err) {
        console.error("Error fetching data:", err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  // --- 4. SUBMIT REVIEW (FIXED: Route /user/review) ---
  const handleSubmitReview = async (e) => {
      e.preventDefault();
      
      if (!currentUser) {
          alert("Silakan Login untuk memberi review.");
          navigate('/auth'); // Redirect ke halaman Auth
          return;
      }
      if (userRating === 0) return alert("Pilih bintang 1-5.");

      setIsSubmitting(true);
      try {
          // Payload menyesuaikan struktur tabel
          const payload = {
              destinationId: parseInt(id),
              userId: parseInt(currentUser.id || currentUser.id_user || currentUser.user_id),
              rating: parseInt(userRating),
              comment: userComment
          };

          // POST ke Route Backend yang benar: /user/review
          // (Token otomatis di-handle oleh axios interceptor jika sudah disetup)
          await api.post('/user/review', payload);
          
          // Update UI Langsung
          const newReview = {
              id_review: Date.now(), 
              username: currentUser.username || currentUser.name || "Anda",
              rating: userRating,
              comment: userComment,
              created_at: new Date().toISOString()
          };
          setReviews([newReview, ...reviews]);
          setUserRating(0); setUserComment("");
          alert("Review terkirim!");

      } catch (error) {
          console.error("Gagal kirim review:", error);
          // Fallback pesan error jika response dari Go tersedia
          const msg = error.response?.data?.error || "Gagal mengirim review. Pastikan Anda sudah login.";
          alert(msg);
      } finally {
          setIsSubmitting(false);
      }
  };

  const handleBookmark = () => {
    const savedBookmarks = JSON.parse(localStorage.getItem('travora_bookmarks') || '[]');
    if (isBookmarked) {
        const newBookmarks = savedBookmarks.filter(item => String(item.id) !== String(id));
        localStorage.setItem('travora_bookmarks', JSON.stringify(newBookmarks));
        setIsBookmarked(false);
    } else {
        const imgs = getImageArray(data);
        savedBookmarks.push({
            id: String(id),
            title: data.namedestination,
            location: data.location,
            img: imgs[0],
            rating: averageRating() || "New"
        });
        localStorage.setItem('travora_bookmarks', JSON.stringify(savedBookmarks));
        setIsBookmarked(true);
    }
  };

  if (loading) return <div className="h-screen flex items-center justify-center"><div className="animate-pulse font-bold text-gray-400">Loading...</div></div>;
  if (!data) return <div className="h-screen flex items-center justify-center">Data Not Found</div>;

  const images = getImageArray(data);
  const title = data.namedestination || data.NameDestination;
  const location = data.location;
  const description = data.description;
  const operational = data.operational;
  const mapsLink = data.maps;
  const doList = parseList(data.do);
  const dontList = parseList(data.dont);
  const safety = data.safety;
  const facilities = getFacilities(data.facilityId);
  const price = data.price;

  const currentImg = images[imgIndex] && !images[imgIndex].startsWith('http') && !images[imgIndex].startsWith('data:') 
      ? `data:image/jpeg;base64,${images[imgIndex]}` : (images[imgIndex] || 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd?auto=format&fit=crop&w=1200&q=80');
  const nextImage = () => setImgIndex((prev) => (prev === images.length - 1 ? 0 : prev + 1));
  const prevImage = () => setImgIndex((prev) => (prev === 0 ? images.length - 1 : prev - 1));

  return (
    <div className="w-full pb-20 bg-white min-h-screen font-sans text-[#1F2937]">
      
      {/* HEADER BANNER */}
      <div className="w-full h-[350px] relative flex items-center justify-center bg-gray-900 overflow-hidden">
          <img src="https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1920&q=80" alt="Banner" className="absolute inset-0 w-full h-full object-cover opacity-60" />
          <div className="relative z-10 text-center"><h1 className="text-5xl md:text-6xl font-normal text-white tracking-wide"><span className="font-light opacity-80">|</span> Destination</h1></div>
      </div>

      {/* MAIN SLIDER */}
      <div className="max-w-6xl mx-auto w-full px-6 lg:px-8 py-10">
          <div className="flex items-center gap-2 mb-6 text-base text-gray-500 font-medium">
              <span className="text-[#5E9BF5] cursor-pointer hover:underline" onClick={() => navigate('/')}>Home</span><span className="text-gray-300">›</span><span className="text-gray-700">Destination</span>
          </div>
          <div className="w-full h-[400px] md:h-[550px] rounded-[40px] overflow-hidden relative shadow-2xl mb-8 group">
              <img src={currentImg} className="w-full h-full object-cover transition-transform duration-700 hover:scale-105" alt={title} />
          </div>
          <div className="flex justify-center items-center gap-12 text-gray-500 font-medium text-lg">
              <button onClick={prevImage} className="flex items-center gap-3 hover:text-[#5E9BF5] transition group disabled:opacity-50" disabled={images.length <= 1}>
                  <div className="w-10 h-10 rounded-full border-2 border-gray-300 flex items-center justify-center group-hover:border-[#5E9BF5] transition"><ChevronLeft size={24} className="group-hover:text-[#5E9BF5]" /></div> Back
              </button>
              <button onClick={nextImage} className="flex items-center gap-3 hover:text-[#5E9BF5] transition group disabled:opacity-50" disabled={images.length <= 1}>
                  Next <div className="w-10 h-10 rounded-full border-2 border-gray-300 flex items-center justify-center group-hover:border-[#5E9BF5] transition"><ChevronRight size={24} className="group-hover:text-[#5E9BF5]" /></div>
              </button>
          </div>
      </div>

      {/* DETAIL CONTENT */}
      <div className="max-w-7xl mx-auto w-full px-6 lg:px-10 py-10 border-t border-gray-100 mt-8">
        <div className="flex flex-col lg:flex-row gap-12">
            
            <div className="lg:w-2/3 space-y-10">
                <div className="flex justify-between items-start">
                    <div>
                        <h2 className="text-4xl font-extrabold text-gray-900 mb-2">{title}</h2>
                        <div className="flex items-center gap-2 text-gray-500 text-lg"><MapPin size={22} className="text-gray-800" /><span>{location}</span></div>
                    </div>
                    <button onClick={handleBookmark} className="mt-1"><Heart size={40} className={`transition duration-300 drop-shadow-sm ${isBookmarked ? 'fill-[#5E9BF5] text-[#5E9BF5]' : 'text-gray-300 hover:text-[#5E9BF5]'}`} /></button>
                </div>
                <p className="text-gray-600 text-lg leading-relaxed text-justify whitespace-pre-line">{description || "No description available."}</p>
                <div>
                    <h3 className="text-2xl font-bold text-gray-900 mb-6">Facilities</h3>
                    {facilities.length > 0 ? (
                        <div className="flex flex-wrap gap-8">
                            {facilities.map((fac, idx) => (
                                <div key={idx} className="flex flex-col items-center gap-2 group"><div className="p-4 bg-white border border-gray-200 rounded-2xl group-hover:border-[#5E9BF5] transition duration-300 shadow-sm"><div className="text-gray-800">{fac.icon}</div></div><span className="text-sm font-medium text-gray-500">{fac.name}</span></div>
                            ))}
                        </div>
                    ) : <p className="text-gray-400">Facilities info not available.</p>}
                </div>
                <div className="mt-4">
                    <h3 className="text-2xl font-bold text-gray-900 mb-6">Available Ticket</h3>
                    <div className="flex flex-wrap gap-4 mb-6">
                        {['ticket', 'dodont', 'safety'].map((tab) => (
                            <button key={tab} onClick={() => setActiveTab(tab)} className={`px-8 py-3 rounded-xl font-bold transition flex items-center gap-2 shadow-sm ${activeTab === tab ? 'bg-[#5E9BF5] text-white' : 'bg-white border border-gray-200 text-gray-500 hover:bg-gray-50'}`}>
                                {tab === 'ticket' && <Ticket size={18}/>}{tab === 'dodont' && <CheckCircle size={18}/>}{tab === 'safety' && <ShieldAlert size={18}/>}{tab === 'ticket' ? 'Ticket Info' : tab === 'dodont' ? "Do & Don't" : 'Safety'}
                            </button>
                        ))}
                    </div>
                    <div className="bg-white border border-gray-100 rounded-3xl p-8 shadow-xl">
                        {activeTab === 'ticket' && (
                            <div className="animate-fade-in"><h4 className="text-xl font-bold mb-1">Solo Trip</h4><p className="text-sm text-gray-400 mb-4 uppercase tracking-wider">Includes:</p><ul className="space-y-3 mb-8"><li className="flex gap-3 text-gray-600"><CheckCircle size={20} className="text-[#82B1FF]"/> Entrance fee included</li><li className="flex gap-3 text-gray-600"><CheckCircle size={20} className="text-[#82B1FF]"/> Access to all areas</li></ul><div className="text-3xl font-extrabold text-[#EBC136]">{price ? `IDR ${parseInt(price).toLocaleString('id-ID')}` : 'IDR 80.000'}</div></div>
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
                    <div className="w-full h-[200px] bg-gray-200 rounded-2xl overflow-hidden relative group">
                        {mapsLink && mapsLink.includes('<iframe') ? (
                            <div dangerouslySetInnerHTML={{ __html: mapsLink.replace(/width="\d+"/g, 'width="100%"').replace(/height="\d+"/g, 'height="100%"') }} className="w-full h-full" />
                        ) : (
                            <div onClick={() => window.open(mapsLink || `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(title + " " + location)}`, '_blank')} className="w-full h-full cursor-pointer relative">
                                <img src="https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?auto=format&fit=crop&w=600&q=80" className="w-full h-full object-cover opacity-60 group-hover:scale-110 transition duration-700" alt="Map Location" />
                                <div className="absolute inset-0 flex flex-col items-center justify-center bg-black/10 group-hover:bg-black/20 transition"><div className="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-lg animate-bounce"><MapPin size={24} className="text-[#5E9BF5]" /></div><span className="text-white text-xs font-bold mt-2 shadow-sm drop-shadow-md">Click to view map</span></div>
                            </div>
                        )}
                    </div>
                    <a href={mapsLink && !mapsLink.includes('<iframe') ? mapsLink : `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(title + " " + location)}`} target="_blank" rel="noreferrer" className="w-full mt-4 bg-gray-100 hover:bg-[#EBC136] hover:text-white text-gray-700 font-bold py-3 rounded-xl flex justify-center items-center gap-2 transition duration-300"><MapPin size={18} /> View on Google Maps</a>
                </div>

                {/* REVIEWS CARD */}
                <div className="bg-white p-6 rounded-[32px] shadow-xl border border-gray-100 text-center">
                    <h3 className="text-2xl font-bold text-gray-900 mb-1">Reviews</h3>
                    <div className="text-5xl font-extrabold text-[#EBC136] mb-2">{averageRating()}</div>
                    <div className="flex justify-center gap-1 mb-2">
                        {[1,2,3,4,5].map(i => <Star key={i} size={20} fill={i <= Math.round(parseFloat(averageRating())) ? "#EBC136" : "#E5E7EB"} stroke="none" />)}
                    </div>
                    <p className="text-xs text-gray-400 mb-6">Based on {reviews.length} reviews</p>

                    {currentUser ? (
                        <form onSubmit={handleSubmitReview} className="mb-6 text-left border-t pt-4 border-gray-100">
                            <label className="text-xs font-bold text-gray-500 mb-2 block">Rate & Review:</label>
                            <div className="flex gap-2 mb-3 justify-center">
                                {[1,2,3,4,5].map((star) => (
                                    <Star key={star} size={28} className={`cursor-pointer transition hover:scale-110 ${star <= userRating ? 'fill-[#EBC136] text-[#EBC136]' : 'text-gray-300'}`} onClick={() => setUserRating(star)} />
                                ))}
                            </div>
                            <textarea className="w-full border rounded-xl p-3 text-sm focus:outline-none focus:ring-2 focus:ring-[#5E9BF5] resize-none bg-gray-50" rows="2" placeholder="Write a review..." value={userComment} onChange={(e) => setUserComment(e.target.value)}></textarea>
                            <button type="submit" disabled={isSubmitting} className="w-full mt-2 bg-[#5E9BF5] text-white py-2 rounded-xl font-bold hover:bg-[#4a90e2] flex justify-center items-center gap-2 transition">
                                {isSubmitting ? 'Sending...' : 'Kirim'}
                            </button>
                        </form>
                    ) : (
                         <div className="mb-6 bg-blue-50 p-3 rounded-xl text-sm text-blue-600 cursor-pointer hover:underline" onClick={() => navigate('/auth')}>Login to write a review</div>
                    )}

                    <div className="text-left space-y-4 max-h-[300px] overflow-y-auto pr-1 custom-scrollbar">
                        {reviews.length > 0 ? reviews.map((rev) => (
                            <div key={rev.id_review} className="border-b border-gray-50 pb-3 last:border-0">
                                <div className="flex justify-between mb-1">
                                    <h5 className="font-bold text-gray-900 text-sm">{rev.username || "User"}</h5>
                                    <span className="text-[10px] text-gray-400">{new Date(rev.created_at).toLocaleDateString()}</span>
                                </div>
                                <div className="flex gap-0.5 mb-1">
                                    {[...Array(5)].map((_, i) => (
                                        <Star key={i} size={10} fill={i <= rev.rating ? "#EBC136" : "#E5E7EB"} stroke="none"/>
                                    ))}
                                </div>
                                <p className="text-xs text-gray-500 line-clamp-2">{rev.comment}</p>
                            </div>
                        )) : <p className="text-xs text-gray-400 italic text-center py-4">No reviews yet.</p>}
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>
  );
}