import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Calendar, Clock, MapPin, Star, CheckCircle, ShieldAlert, Bookmark } from 'lucide-react';
import { api } from '../api';

const processImage = (img) => {
  const fallback = 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30';
  if (!img) return fallback;
  try {
    if (typeof img === 'string' && img.trim().startsWith('[')) {
      const parsed = JSON.parse(img);
      if (parsed.length > 0) img = parsed[0];
    }
  } catch (e) {
    /* ignore */
  }
  if (img && !img.startsWith('http') && !img.startsWith('data:')) {
    return `data:image/jpeg;base64,${img}`;
  }
  return img || fallback;
};

const extractImages = (imgField) => {
  const fallback = ['https://images.unsplash.com/photo-1492684223066-81342ee5ff30'];
  if (!imgField) return fallback;
  if (Array.isArray(imgField)) return imgField.length ? imgField : fallback;
  if (typeof imgField === 'string') {
    try {
      const parsed = JSON.parse(imgField);
      if (Array.isArray(parsed) && parsed.length > 0) return parsed;
    } catch (_) {}
  }
  return [imgField];
};

const priceLabel = (price) => {
  if (price === undefined || price === null || parseFloat(price) <= 0) return 'FREE ENTRY';
  const val = parseFloat(price);
  return `IDR ${Math.round(val).toLocaleString('id-ID')}`;
};

const toDateString = (value) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;
  return date.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
};

const timeRange = (start, end) => {
  if (!start && !end) return '-';
  if (start && end) return `${start} - ${end}`;
  return start || end;
};

const formatDateRange = (start, end) => {
  if (!start) return '-';
  const format = (d) => new Date(d).toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' });
  return end && end !== start ? `${format(start)} - ${format(end)}` : format(start);
};

const formatRating = (val) => {
  const num = parseFloat(val);
  if (Number.isFinite(num) && num > 0) return num.toFixed(1);
  return 'New';
};

const extractBackendRating = (item) => {
  const candidates = [
    item?.calculatedRating,
    item?.calculated_rating,
    item?.avg_rating,
    item?.rating,
  ];
  for (const val of candidates) {
    const num = parseFloat(val);
    if (Number.isFinite(num)) return num;
  }
  return null;
};

const splitList = (text) => {
  if (!text) return [];
  return text
    .split(/[\n,;]+/)
    .map((item) => item.trim())
    .filter(Boolean);
};

export default function EventDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [event, setEvent] = useState(null);
  const [recommendations, setRecommendations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [reviews, setReviews] = useState([]);
  const [userRating, setUserRating] = useState(0);
  const [userComment, setUserComment] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [guideTab, setGuideTab] = useState('dodont');
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [imgIndex, setImgIndex] = useState(0);
  const doList = splitList(event?.do || '');
  const dontList = splitList(event?.dont || '');
  const safetyList = splitList(event?.safety || '');

  const currentEventReviews = useMemo(
    () => reviews.filter((r) => String(r.eventId || r.event_id) === String(id)),
    [reviews, id],
  );

  const eventRatingValue = useMemo(() => {
    if (currentEventReviews && currentEventReviews.length > 0) {
      const total = currentEventReviews.reduce((acc, curr) => acc + parseFloat(curr.rating || 0), 0);
      const avg = total / currentEventReviews.length;
      if (Number.isFinite(avg) && avg > 0) return avg;
    }
    const raw = extractBackendRating(event);
    return Number.isFinite(raw) ? raw : null;
  }, [event, currentEventReviews]);

  const { mapLink, mapEmbed, isRawEmbed } = useMemo(() => {
    if (!event) return { mapLink: '', mapEmbed: '', isRawEmbed: false };

    // Jika backend mengirim HTML iframe langsung, pakai apa adanya (disesuaikan width/height)
    if (typeof event.maps === 'string' && event.maps.includes('<iframe')) {
      const fixed = event.maps
        .replace(/width="\\d+"/g, 'width="100%"')
        .replace(/height="\\d+"/g, 'height="100%"');
      const query = encodeURIComponent(event.location || event.nameevent || 'Bali');
      return {
        mapLink: `https://www.google.com/maps/search/?api=1&query=${query}`,
        mapEmbed: fixed,
        isRawEmbed: true,
      };
    }

    const query = event.location || event.nameevent || 'Bali';
    const mapLink = event.maps && event.maps.trim()
      ? event.maps
      : `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`;
    const mapEmbed = `https://maps.google.com/maps?q=${encodeURIComponent(query)}&t=&z=13&ie=UTF8&iwloc=&output=embed`;

    return { mapLink, mapEmbed, isRawEmbed: false };
  }, [event]);

  const imageList = useMemo(
    () => extractImages(event?.image_event).map(processImage),
    [event?.image_event],
  );

  useEffect(() => {
    setImgIndex(0);
  }, [event?.image_event]);

  useEffect(() => {
    const fetchDetail = async () => {
      setLoading(true);
      setError('');
      try {
        const res = await api.get(`/events/${id}`);
        const detail = res.data?.data || res.data;
        setEvent(detail);
      } catch (err) {
        console.error(err);
        setError('Gagal memuat detail event.');
      } finally {
        setLoading(false);
      }
    };

    const fetchReviews = async () => {
      try {
        const res = await api.get('/review');
        const list = res.data?.data || res.data || [];
        setReviews(Array.isArray(list) ? list : []);
      } catch (err) {
        console.warn('Gagal ambil review event:', err);
      }
    };

    const fetchRecommendations = async () => {
      try {
        const res = await api.get('/events');
        const list = Array.isArray(res.data) ? res.data : res.data?.data || [];
        const filtered = list.filter((item) => `${item.id_event}` !== `${id}`).slice(0, 6);
        setRecommendations(filtered);
      } catch (err) {
        console.error(err);
      }
    };

    fetchDetail();
    fetchReviews();
    fetchRecommendations();
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, [id]);

  useEffect(() => {
    const checkBookmark = async () => {
      const token = localStorage.getItem('travora_token');
      if (!token) { setIsBookmarked(false); return; }
      try {
        const res = await api.get('/user/favorite');
        const favs = res.data?.favorites || [];
        const found = favs.some((f) => String(f.eventId || f.event_id) === String(id));
        setIsBookmarked(found);
      } catch (err) {
        console.warn('Gagal cek bookmark event:', err);
      }
    };
    checkBookmark();
  }, [id]);

  const averageRating = () => {
    if (!currentEventReviews || currentEventReviews.length === 0) {
      if (eventRatingValue && eventRatingValue > 0) return eventRatingValue.toFixed(1);
      return 'New';
    }
    const total = currentEventReviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0, 10), 0);
    const avg = total / currentEventReviews.length;
    return avg.toFixed(1);
  };

  const getRatingForEvent = (eventId) => {
    if (!eventId) return null;
    const filtered = reviews.filter((r) => String(r.eventId || r.event_id) === String(eventId));
    if (filtered.length > 0) {
      const total = filtered.reduce((acc, curr) => acc + parseFloat(curr.rating || 0), 0);
      const avg = total / filtered.length;
      if (Number.isFinite(avg) && avg > 0) return avg;
    }
    return null;
  };

  const handleSubmitReview = async () => {
    if (!userRating) return alert('Pilih rating dulu.');
    const token = localStorage.getItem('travora_token');
    if (!token) return alert('Silakan login terlebih dahulu.');

    try {
      setIsSubmitting(true);
      await api.post('/user/review', {
        eventId: parseInt(id, 10),
        rating: parseInt(userRating, 10),
        comment: userComment,
      });
      setUserRating(0);
      setUserComment('');
      // refresh seluruh review untuk kebutuhan rating per event
      const res = await api.get('/review');
      const list = res.data?.data || res.data || [];
      setReviews(Array.isArray(list) ? list : []);
    } catch (err) {
      console.error(err);
      alert('Gagal mengirim review.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleToggleBookmark = async () => {
    const token = localStorage.getItem('travora_token');
    if (!token) {
      return navigate('/auth');
    }
    try {
      if (isBookmarked) {
        await api.delete(`/user/favorite/${id}?type=event`);
        setIsBookmarked(false);
      } else {
        await api.post('/user/favorite', { eventId: Number(id) });
        setIsBookmarked(true);
      }
    } catch (err) {
      console.error('Bookmark toggle failed:', err?.response?.data || err);
      alert('Gagal memperbarui bookmark. Pastikan sudah login.');
    }
  };

  const getReviewerName = (rev) => rev.user?.username || rev.User?.username || rev.username || 'Traveler';
  const getReviewerAvatar = (rev) => {
    const img = rev.user?.image || rev.User?.image || '';
    if (!img) return `https://ui-avatars.com/api/?name=${encodeURIComponent(getReviewerName(rev))}&background=5E9BF5&color=fff`;
    if (typeof img === 'string' && !img.startsWith('http') && !img.startsWith('data:')) {
      return `data:image/jpeg;base64,${img}`;
    }
    return img;
  };

  const renderGuidelines = (title, items) => {
    if (!items.length) return null;
    return (
      <div className="bg-white border border-gray-100 rounded-2xl p-4 shadow-sm">
        <h4 className="font-semibold text-gray-900 mb-3">{title}</h4>
        <ul className="space-y-2 text-sm text-gray-600 list-disc list-inside">
          {items.map((item, idx) => (
            <li key={`${title}-${idx}`}>{item}</li>
          ))}
        </ul>
      </div>
    );
  };

  return (
    <div className="max-w-6xl w-full mx-auto px-6 py-12">
      <button
        onClick={() => navigate(-1)}
        className="mb-6 inline-flex items-center gap-2 text-sm font-semibold text-[#5E9BF5] hover:text-[#3b7cdb]"
      >
        <ArrowLeft size={16} /> Kembali
      </button>

      {loading ? (
        <div className="animate-pulse space-y-4">
          <div className="h-64 bg-gray-100 rounded-3xl" />
          <div className="h-10 bg-gray-100 rounded-xl" />
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {[1, 2, 3].map((i) => (
              <div key={i} className="h-24 bg-gray-100 rounded-2xl" />
            ))}
          </div>
        </div>
      ) : error ? (
        <div className="bg-red-50 text-red-700 font-semibold px-4 py-3 rounded-xl border border-red-100">
          {error}
        </div>
          ) : event ? (
        <>
          <div className="bg-white border border-gray-100 rounded-[28px] shadow-lg overflow-hidden">
            <div className="relative h-[320px] w-full overflow-hidden">
              <img
                src={imageList[imgIndex] || imageList[0]}
                alt={event.nameevent}
                className="w-full h-full object-cover transition duration-500"
              />
              {imageList.length > 1 && (
                <>
                  <button
                    onClick={() => setImgIndex((prev) => (prev === 0 ? imageList.length - 1 : prev - 1))}
                    className="absolute top-1/2 left-4 -translate-y-1/2 bg-white/85 hover:bg-white text-gray-700 rounded-full w-9 h-9 flex items-center justify-center shadow border"
                  >
                    ‹
                  </button>
                  <button
                    onClick={() => setImgIndex((prev) => (prev === imageList.length - 1 ? 0 : prev + 1))}
                    className="absolute top-1/2 right-4 -translate-y-1/2 bg-white/85 hover:bg-white text-gray-700 rounded-full w-9 h-9 flex items-center justify-center shadow border"
                  >
                    ›
                  </button>
                </>
              )}
            </div>

            <div className="p-6 md:p-8 flex flex-col md:flex-row gap-8">
              <div className="flex-1 space-y-5">
                <div className="space-y-2">
                  <div className="flex items-start justify-between gap-3">
                    <h1 className="text-3xl md:text-4xl font-bold text-gray-900 leading-tight">
                      {event.nameevent}
                    </h1>
                    <button
                      onClick={handleToggleBookmark}
                      aria-label={isBookmarked ? 'Remove bookmark' : 'Add bookmark'}
                      className="p-1"
                    >
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
                  <div className="inline-flex items-center gap-1.5 px-3 py-1 bg-[#FFF7E6] border border-[#F5C542]/40 rounded-full text-sm font-semibold text-gray-800">
                    <Star size={14} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
                    <span>{eventRatingValue && eventRatingValue > 0 ? eventRatingValue.toFixed(1) : 'New'}</span>
                  </div>
                  <div className="flex flex-col gap-2 text-base text-gray-900">
                    <div className="flex items-start gap-2">
                      <MapPin size={18} className="text-[#1F5FBF] mt-0.5" />
                      <span className="font-medium">{event.location || 'Lokasi belum tersedia'}</span>
                    </div>
                    <div className="flex flex-col gap-1">
                      <span className="inline-flex items-center gap-2">
                        <Calendar size={18} className="text-[#1F5FBF]" />
                        <span className="font-semibold">
                          {toDateString(event.start_date)}
                          {event.end_date && ` - ${toDateString(event.end_date)}`}
                        </span>
                      </span>
                      <span className="inline-flex items-center gap-2 font-medium">
                        <Clock size={18} className="text-[#1F5FBF]" />
                        {timeRange(event.start_time, event.end_time)}
                      </span>
                    </div>
                  </div>
                </div>

                <p className="text-gray-700 leading-relaxed text-sm md:text-base">
                  {event.description || 'Tidak ada deskripsi untuk event ini.'}
                </p>

                <div className="flex flex-wrap items-center gap-3">
                  <span className="text-sm font-semibold text-gray-500">Price</span>
                  <span className="px-4 py-2 bg-[#E8F1FF] text-[#1F5FBF] font-bold rounded-xl text-xs">
                    {priceLabel(event.price)}
                  </span>
                </div>

                <div className="bg-[#F9FBFF] border border-gray-100 rounded-2xl p-4 space-y-4">
                  <div className="flex flex-wrap gap-3">
                    {['dodont', 'safety'].map((tab) => {
                      const isActive = guideTab === tab;
                      return (
                        <button
                          key={tab}
                          onClick={() => setGuideTab(tab)}
                          className={`flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold border transition ${
                            isActive
                              ? 'bg-[#5E9BF5] text-white border-[#5E9BF5] shadow-sm'
                              : 'bg-white text-gray-600 border-gray-200 hover:border-[#5E9BF5]'
                          }`}
                        >
                          {tab === 'dodont' ? (
                            <CheckCircle size={16} className={isActive ? 'text-white' : 'text-[#5E9BF5]'} />
                          ) : (
                            <ShieldAlert size={16} className={isActive ? 'text-white' : 'text-[#5E9BF5]'} />
                          )}
                          {tab === 'dodont' ? "Do & Don't" : 'Safety'}
                        </button>
                      );
                    })}
                  </div>
                  {guideTab === 'dodont' ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div className="rounded-2xl border border-gray-100 bg-white p-4">
                        <h4 className="font-semibold text-gray-900 mb-3">Do</h4>
                        <ul className="space-y-2 text-sm text-gray-600 list-disc list-inside">
                          {doList.length > 0 ? doList.map((item, idx) => <li key={`do-${idx}`}>{item}</li>) : <li>Ikuti arahan panitia.</li>}
                        </ul>
                      </div>
                      <div className="rounded-2xl border border-gray-100 bg-white p-4">
                        <h4 className="font-semibold text-gray-900 mb-3">Don't</h4>
                        <ul className="space-y-2 text-sm text-gray-600 list-disc list-inside">
                          {dontList.length > 0 ? dontList.map((item, idx) => <li key={`dont-${idx}`}>{item}</li>) : <li>Jangan mengganggu jalannya acara.</li>}
                        </ul>
                      </div>
                    </div>
                  ) : (
                    <div className="rounded-2xl border border-gray-100 bg-white p-4">
                      <h4 className="font-semibold text-gray-900 mb-3">Safety</h4>
                      {safetyList.length > 0 ? (
                        <ul className="space-y-2 text-sm text-gray-600 list-disc list-inside">
                          {safetyList.map((item, idx) => <li key={`safety-${idx}`}>{item}</li>)}
                        </ul>
                      ) : (
                        <p className="text-sm text-gray-600">Ikuti prosedur keselamatan yang berlaku.</p>
                      )}
                    </div>
                  )}
                </div>
              </div>

              <div className="w-full md:w-[320px] flex flex-col gap-4">
                <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
                  <div className="px-4 pb-4 pt-4">
                    <div className="rounded-[20px] overflow-hidden border border-gray-200 shadow-inner bg-white">
                      {mapEmbed ? (
                        isRawEmbed ? (
                          <div
                            className="w-full h-64"
                            dangerouslySetInnerHTML={{ __html: mapEmbed }}
                          />
                        ) : (
                          <iframe
                            src={mapEmbed}
                            title="Map"
                            className="w-full h-64"
                            loading="lazy"
                            referrerPolicy="no-referrer-when-downgrade"
                          />
                        )
                      ) : (
                        <div className="h-64 flex items-center justify-center text-sm text-gray-400 bg-gray-50">
                          Peta belum tersedia
                        </div>
                      )}
                    </div>
                    {mapLink ? (
                      <button
                        onClick={() => window.open(mapLink, '_blank', 'noopener,noreferrer')}
                        className="mt-3 w-full inline-flex items-center justify-center gap-2 px-4 py-3 rounded-full bg-[#EEF3F9] text-[#1F2937] font-semibold text-sm shadow-sm hover:bg-[#dce7f6] transition"
                      >
                        <MapPin size={16} className="text-[#1F5FBF]" /> Open in Google Maps
                      </button>
                    ) : null}
                  </div>
                </div>

                <div className="bg-white border border-gray-100 rounded-2xl shadow-md p-5 space-y-4">
                  <div className="text-center space-y-1">
                    <h3 className="text-lg font-bold text-gray-900">Reviews</h3>
                    <span className="text-3xl font-extrabold text-[#D4A017] block">{averageRating()}</span>
                    <div className="flex items-center justify-center gap-1">
                      {[1,2,3,4,5].map((i) => (
                        <Star
                          key={i}
                          size={16}
                          className={i <= Math.round(parseFloat(averageRating()) || 0) ? 'text-[#D4A017]' : 'text-gray-300'}
                          fill={i <= Math.round(parseFloat(averageRating()) || 0) ? '#D4A017' : 'none'}
                          stroke={i <= Math.round(parseFloat(averageRating()) || 0) ? '#D4A017' : '#E5E7EB'}
                        />
                      ))}
                    </div>
                    <p className="text-[11px] text-gray-500">Based on {currentEventReviews.length || '0'} review</p>
                  </div>

                  <div className="space-y-2 border-t border-gray-100 pt-3">
                    <div className="flex items-center gap-1 justify-center">
                      {[1,2,3,4,5].map((i) => (
                        <button
                          key={i}
                          onClick={() => setUserRating(i)}
                          className="p-1"
                          aria-label={`Beri rating ${i}`}
                        >
                          <Star
                            size={18}
                            className={i <= userRating ? 'text-[#F5C542]' : 'text-gray-300'}
                            fill={i <= userRating ? '#F5C542' : 'none'}
                            stroke={i <= userRating ? '#F5C542' : '#E5E7EB'}
                          />
                        </button>
                      ))}
                    </div>
                    <textarea
                      value={userComment}
                      onChange={(e) => setUserComment(e.target.value)}
                      className="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:border-[#5E9BF5] resize-none"
                      rows={3}
                      placeholder="Tulis review..."
                    />
                    <button
                      onClick={handleSubmitReview}
                      disabled={isSubmitting}
                      className="w-full bg-[#5E9BF5] text-white font-bold text-sm py-2.5 rounded-xl shadow hover:bg-[#3b7cdb] disabled:opacity-60 disabled:cursor-not-allowed transition"
                    >
                      {isSubmitting ? 'Mengirim...' : 'Kirim'}
                    </button>
                  </div>

                  <div className="pt-2 space-y-3 border-t border-gray-100 max-h-[240px] overflow-y-auto pr-1">
                    {currentEventReviews.length === 0 ? (
                      <p className="text-sm text-gray-400 text-center">Belum ada review.</p>
                    ) : (
                      currentEventReviews.map((rev, idx) => (
                        <div key={`${rev.id || idx}`} className="flex gap-3 border-b border-gray-100 pb-3 last:border-b-0 last:pb-0">
                          <img
                            src={getReviewerAvatar(rev)}
                            alt={getReviewerName(rev)}
                            className="w-9 h-9 rounded-full object-cover"
                          />
                          <div className="flex-1">
                            <div className="flex items-center justify-between">
                              <span className="font-semibold text-sm text-gray-800">{getReviewerName(rev)}</span>
                              <span className="text-[10px] text-gray-400">{rev.createdAt ? new Date(rev.createdAt).toLocaleDateString('en-GB') : ''}</span>
                            </div>
                            <div className="flex items-center gap-1 my-1">
                              {[1,2,3,4,5].map((i) => (
                                <Star
                                  key={i}
                                  size={12}
                                  className={i <= (rev.rating || 0) ? 'text-[#D4A017]' : 'text-gray-300'}
                                  fill={i <= (rev.rating || 0) ? '#D4A017' : 'none'}
                                  stroke={i <= (rev.rating || 0) ? '#D4A017' : '#E5E7EB'}
                                />
                              ))}
                            </div>
                            <p className="text-xs text-gray-600">{rev.comment || '-'}</p>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="mt-10">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xl font-bold text-gray-900">More Events</h3>
              <button
                onClick={() => navigate('/events')}
                className="text-sm font-semibold text-[#5E9BF5] hover:text-[#3b7cdb] inline-flex items-center gap-1"
              >
                Lihat semua <ArrowLeft size={14} className="rotate-180" />
              </button>
            </div>
             {recommendations.length === 0 ? (
              <div className="text-sm text-gray-500">Belum ada event lainnya.</div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                {recommendations.map((item) => {
                  const backendRating = extractBackendRating(item);
                  const recRating = getRatingForEvent(item.id_event || item.id) ?? backendRating;
                  const badgeLabel = formatRating(recRating);
                  return (
                    <div
                      key={item.id_event || item.id}
                      onClick={() => navigate(`/events/${item.id_event || item.id}`)}
                      className="group cursor-pointer bg-white rounded-[10px] border border-gray-100 shadow-md hover:shadow-xl transition-all duration-300 flex flex-col overflow-hidden hover:-translate-y-1 h-full"
                    >
                      <div className="relative h-[150px] w-full overflow-hidden p-1">
                        <img
                          src={processImage(item.image_event)}
                          alt={item.nameevent}
                          className="w-full h-full object-cover group-hover:scale-110 transition duration-700 rounded-[10px]"
                        />
                        <div className="absolute top-3 right-3 bg-white/90 rounded-full px-3 py-1 text-[11px] font-bold text-gray-800 shadow-sm flex items-center gap-1.5">
                          <Star size={12} className="text-[#F5C542]" fill="#F5C542" stroke="none" />
                          <span>{badgeLabel}</span>
                        </div>
                      </div>

                      <div className="flex flex-col flex-1">
                        <div className="p-4 flex flex-col gap-2 flex-1">
                          <h4 className="text-base font-bold text-gray-900 leading-tight line-clamp-2 min-h-[40px]">
                            {item.nameevent || 'Event'}
                          </h4>
                          <div className="flex items-center gap-1.5 text-gray-500 text-[12px] font-medium min-h-[32px]">
                            <MapPin size={12} className="text-[#5E9BF5] flex-shrink-0" />
                            <span className="truncate">{item.location || 'Lokasi belum tersedia'}</span>
                          </div>
                          <div className="text-[12px] text-gray-700 space-y-1 leading-snug">
                            <div className="flex items-start gap-1.5">
                              <Calendar size={14} className="text-[#5E9BF5] mt-[1px]" />
                              <span className="truncate font-semibold text-gray-800">
                                {formatDateRange(item.start_date, item.end_date)}
                              </span>
                            </div>
                            <div className="flex items-start gap-1.5">
                              <Clock size={14} className="text-[#5E9BF5] mt-[1px]" />
                              <span className="truncate">{timeRange(item.start_time, item.end_time)}</span>
                            </div>
                          </div>
                        </div>

                        <div className="mt-auto flex justify-end">
                          <span className="text-[11px] font-bold text-white bg-[#82B1FF] px-4 py-3 rounded-tl-[10px] shadow-sm">
                            {priceLabel(item.price)}
                          </span>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </>
      ) : (
        <div className="text-gray-500">Event tidak ditemukan.</div>
      )}
    </div>
  );
}
