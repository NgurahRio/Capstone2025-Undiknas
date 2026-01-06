import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../../api';
import PlaceCard from '../cards/PlaceCard';

const formatRating = (item) => {
  const calc = parseFloat(item?.calculatedRating);
  if (Number.isFinite(calc) && calc > 0) return calc.toFixed(1);

  const raw = parseFloat(item?.rating);
  if (Number.isFinite(raw) && raw > 0) return raw.toFixed(1);

  return 'New';
};

export default function TravelStyle({ initialShowAll = false, hideViewMore = false, onViewMore }) {
  const navigate = useNavigate();

  const [categories, setCategories] = useState([]);
  const [subcategories, setSubcategories] = useState([]);
  const [destinations, setDestinations] = useState([]);
  const [filteredDestinations, setFilteredDestinations] = useState([]);

  const [activeCategory, setActiveCategory] = useState(null);
  const [activeSubcategory, setActiveSubcategory] = useState(null);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [showAll, setShowAll] = useState(initialShowAll);

  const [loading, setLoading] = useState(true);

  // Helpers
  const getSubcategoryId = (sub) => sub?.id_subcategories || sub?.id;
  const getSubcategoryCategoryId = (sub) =>
    sub?.categoriesId || sub?.categoryId || sub?.id_categories || sub?.category?.id_categories || sub?.category?.id;

  const getDestinationSubIds = (item) => {
    if (Array.isArray(item.subcategory)) {
      return item.subcategory.map((s) => getSubcategoryId(s)).filter(Boolean);
    }
    if (item.subcategoryId) {
      return String(item.subcategoryId)
        .split(',')
        .map((s) => s.trim())
        .filter(Boolean);
    }
    return [];
  };

  // Fetch categories, subcategories, destinations
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [resCat, resSub, resDest] = await Promise.all([
          api.get('/categories'),
          api.get('/subcategories'),
          api.get('/destinations'),
        ]);

        const catData = Array.isArray(resCat.data) ? resCat.data : resCat.data.data || [];
        const subData = Array.isArray(resSub.data) ? resSub.data : resSub.data.data || [];
        const destData = Array.isArray(resDest.data) ? resDest.data : resDest.data.data || [];

        const destWithRating = await Promise.all(
          destData.map(async (item) => {
            const destId = item.id_destination || item.id || item.ID;
            let ratingValue = 0;

            if (destId) {
              try {
                const resRev = await api.get('/review', { params: { destinationId: destId } });
                const reviews = resRev.data?.data || resRev.data;

                if (Array.isArray(reviews) && reviews.length > 0) {
                  const total = reviews.reduce((acc, curr) => acc + parseInt(curr.rating || 0, 10), 0);
                  ratingValue = total / reviews.length;
                }
              } catch (err) {
                console.warn('Gagal ambil rating destinasi:', err);
              }
            }

            return { ...item, calculatedRating: ratingValue };
          })
        );

        setCategories(catData);
        setSubcategories(subData);
        setDestinations(destWithRating);

        if (catData.length > 0) {
          setActiveCategory(catData[0].id_categories || catData[0].id);
        }
      } catch (err) {
        console.error('Gagal load Travel Style:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  // Set default subcategory when category changes
  useEffect(() => {
    if (!activeCategory) return;
    const subs = subcategories.filter(
      (s) => String(getSubcategoryCategoryId(s)) === String(activeCategory)
    );
    if (subs.length > 0) {
      const firstId = getSubcategoryId(subs[0]);
      setActiveSubcategory((prev) =>
        subs.some((s) => String(getSubcategoryId(s)) === String(prev)) ? prev : firstId
      );
    } else {
      setActiveSubcategory(null);
    }
    setCurrentIndex(0);
  }, [activeCategory, subcategories]);

  // Filter destinations by category and subcategory
  useEffect(() => {
    if (!activeCategory) return;

    const subMap = new Map(
      subcategories.map((s) => [String(getSubcategoryId(s)), s])
    );

    const filtered = destinations.filter((item) => {
      const ids = getDestinationSubIds(item);
      if (ids.length === 0) return false;

      const hasCategory = ids.some((id) => {
        const sub = subMap.get(String(id));
        const catId = getSubcategoryCategoryId(sub);
        return String(catId) === String(activeCategory);
      });
      if (!hasCategory) return false;

      if (activeSubcategory) {
        return ids.some((id) => String(id) === String(activeSubcategory));
      }
      return true;
    });

    setFilteredDestinations(filtered);
    setCurrentIndex(0);
  }, [activeCategory, activeSubcategory, destinations, subcategories]);

  if (loading) return <div className="h-[300px] w-full bg-gray-100 rounded-[32px] animate-pulse"></div>;
  if (categories.length === 0) return null;

  const itemsPerPage = showAll ? 12 : 4;
  const canPrev = currentIndex > 0;
  const canNext = currentIndex + itemsPerPage < filteredDestinations.length;
  const visibleItems = filteredDestinations.slice(currentIndex, currentIndex + itemsPerPage);

  const subByCategory = subcategories.filter(
    (s) => String(getSubcategoryCategoryId(s)) === String(activeCategory)
  );
  const activeSubName = subByCategory.find(
    (s) => String(getSubcategoryId(s)) === String(activeSubcategory)
  )?.namesubcategories;
  const activeCategoryName = categories.find(
    (cat) => String(cat.id_categories || cat.id) === String(activeCategory)
  )?.name;

  return (
    <div className="flex flex-col gap-8 w-full bg-[#EEF3FF] rounded-[28px] px-4 py-8 lg:px-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <div className="w-1.5 h-8 bg-[#5E9BF5] rounded-full"></div>
          <h2 className="text-3xl font-bold text-gray-900">Travel Style</h2>
        </div>
        {!hideViewMore && (
          <button
            onClick={() => { onViewMore ? onViewMore() : (setShowAll((prev) => !prev), setCurrentIndex(0)); }}
            className="bg-[#7FB4FF] text-white px-5 py-2 rounded-full font-semibold text-sm shadow-md hover:bg-[#6aa7ff] transition"
          >
            {showAll ? 'View Less' : 'View More'}
          </button>
        )}
      </div>

      {/* Category Pills */}
      <div className="flex flex-wrap gap-3">
        {categories.map((cat) => {
          const isActive = (cat.id_categories || cat.id) === activeCategory;
          return (
            <button
              key={cat.id_categories || cat.id}
              onClick={() => setActiveCategory(cat.id_categories || cat.id)}
              className={`px-4 py-2 rounded-full text-sm font-semibold border transition-all ${
                isActive
                  ? 'bg-[#E9F2FF] text-[#5E9BF5] border-[#5E9BF5]'
                  : 'bg-white text-gray-600 border-gray-200 hover:border-[#5E9BF5]'
              }`}
            >
              {cat.name}
            </button>
          );
        })}
      </div>

      {/* Subcategory Pills */}
      {subByCategory.length > 0 && (
        <div className="flex flex-wrap gap-3">
          {subByCategory.map((sub) => {
            const subId = getSubcategoryId(sub);
            const isActiveSub = String(subId) === String(activeSubcategory);
            return (
              <button
                key={subId}
                onClick={() => {
                  setActiveSubcategory(subId);
                  setCurrentIndex(0);
                }}
                className={`px-4 py-2 rounded-full text-sm font-semibold border transition-all ${
                  isActiveSub
                    ? 'bg-white text-[#5E9BF5] border-[#5E9BF5]'
                    : 'bg-white text-gray-600 border-gray-200 hover:border-[#5E9BF5]'
                }`}
              >
                {sub.namesubcategories || sub.name || 'Subcategory'}
              </button>
            );
          })}
        </div>
      )}

      <div className="h-[1px] w-full bg-gray-200"></div>

      {/* Grid */}
      <div className="w-full min-h-[300px]">
        {visibleItems.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 animate-fade-in">
            {visibleItems.map((item) => {
              let img =
                Array.isArray(item.images) && item.images.length > 0
                  ? item.images[0]
                  : item.Image || null;
              if (img && !img.startsWith('http') && !img.startsWith('data:')) {
                img = `data:image/jpeg;base64,${img}`;
              }
              if (!img) img = 'https://images.unsplash.com/photo-1544644181-1484b3fdfc62';

              return (
                <PlaceCard
                  key={item.ID || item.id_destination}
                  title={item.NameDestination || item.namedestination || item.title}
                  subtitle={item.Location || item.location}
                  description={item.description}
                  tag={activeCategoryName || activeSubName}
                  img={img}
                  rating={formatRating(item)}
                  onPress={() => navigate(`/destination/${item.ID || item.id_destination}`)}
                />
              );
            })}
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center h-[300px] bg-gray-50 rounded-[32px] border border-dashed border-gray-200">
            <p className="text-gray-400 font-medium">Destinasi belum tersedia untuk pilihan ini.</p>
          </div>
        )}
      </div>

      {filteredDestinations.length > itemsPerPage && (
        <div className="flex items-center justify-center gap-6 pt-2">
          <button
            onClick={() => canPrev && setCurrentIndex((prev) => Math.max(prev - itemsPerPage, 0))}
            disabled={!canPrev}
            className={`flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold border ${
              canPrev
                ? 'bg-white text-gray-700 border-gray-200 hover:border-[#5E9BF5]'
                : 'bg-gray-100 text-gray-400 border-gray-100 cursor-not-allowed'
            }`}
          >
            <span className="w-8 h-8 rounded-full border flex items-center justify-center border-[#5E9BF5] text-[#5E9BF5]">
              ←
            </span>
            Back
          </button>
          <button
            onClick={() => canNext && setCurrentIndex((prev) => prev + itemsPerPage)}
            disabled={!canNext}
            className={`flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold border ${
              canNext
                ? 'bg-white text-gray-700 border-gray-200 hover:border-[#5E9BF5]'
                : 'bg-gray-100 text-gray-400 border-gray-100 cursor-not-allowed'
            }`}
          >
            Next
            <span className="w-8 h-8 rounded-full border flex items-center justify-center border-[#5E9BF5] text-[#5E9BF5]">
              →
            </span>
          </button>
        </div>
      )}
    </div>
  );
}
