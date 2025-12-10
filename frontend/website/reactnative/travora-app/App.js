import React, { useState, useRef } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Image,
  ScrollView,
  TouchableOpacity,
  SafeAreaView,
  Dimensions,
  TextInput,
  StatusBar,
  Platform,
} from 'react-native';
// Pastikan sudah install: npx expo install react-native-calendars
import { Calendar, LocaleConfig } from 'react-native-calendars';
import { FontAwesome5, MaterialIcons, Ionicons } from '@expo/vector-icons';

// --- KONSTANTA & DATA ---
const { width } = Dimensions.get('window');
const PAD_HOR = width > 1000 ? 150 : 20; 

const COLORS = {
  main: '#5E9BF5',
  light: '#82B1FF',
  dark: '#576D85',
  bg: '#F2F7FB',
  sos: '#EF685B',
  gold: '#EBC136',
  white: '#FFFFFF',
  black: '#000000',
  gray: '#9CA3AF',
  lightGray: '#F3F4F6',
};

// --- KOMPONEN UTAMA (APP) ---
export default function App() {
  const [activeTab, setActiveTab] = useState('home'); 
  const [currentPage, setCurrentPage] = useState('main'); 
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  
  const scrollViewRef = useRef(null);

  // Fungsi Navigasi Tab
  const handleTabPress = (index, tabName) => {
    if (index === 0) { // Home
      setIsSearching(false);
      setSearchQuery("");
      setCurrentPage('main');
      setActiveTab('home');
      scrollToTop();
    } else if (index === 1) { // Event
      setActiveTab('event');
      setCurrentPage('main');
      setIsSearching(false);
      // Scroll ke event section
      setTimeout(() => scrollViewRef.current?.scrollTo({ y: 2500, animated: true }), 100);
    } else if (index === 2) { // Bookmark
      setActiveTab('bookmark');
      setCurrentPage('bookmark');
      scrollToTop();
    } else if (index === 3) { // Profile
      setActiveTab('profile');
      setCurrentPage('profile');
      scrollToTop();
    }
  };

  const handleSearch = (query) => {
    if (query.length > 0) {
      setIsSearching(true);
      setSearchQuery(query);
      setTimeout(() => {
        scrollViewRef.current?.scrollTo({ y: 600, animated: true });
      }, 100);
    }
  };

  const clearSearch = () => {
    setIsSearching(false);
    setSearchQuery("");
    scrollToTop();
  };

  const scrollToTop = () => {
    scrollViewRef.current?.scrollTo({ y: 0, animated: true });
  };

  const toggleLogin = () => {
    setIsLoggedIn(!isLoggedIn);
  };

  const renderPage = () => {
    if (currentPage === 'destination') {
      return <DestinationPage onBack={() => setCurrentPage('main')} />;
    }
    if (currentPage === 'bookmark') {
      return <BookmarkPage isLoggedIn={isLoggedIn} onToggleLogin={toggleLogin} onNavigate={() => setCurrentPage('destination')} />;
    }
    if (currentPage === 'profile') {
      return <ProfilePage isLoggedIn={isLoggedIn} onToggleLogin={toggleLogin} />;
    }

    return (
      <View>
        <HeroSection onSearch={handleSearch} initialQuery={searchQuery} />
        {isSearching ? (
          <SearchResultsSection query={searchQuery} onHomeTap={clearSearch} onNavigate={() => setCurrentPage('destination')} />
        ) : (
          <View>
            <View style={{ paddingVertical: 60 }}>
              <PopularPlacesSection onNavigate={() => setCurrentPage('destination')} />
            </View>
            <View style={{ paddingBottom: 80 }}>
              <ExploreUbudSection onNavigate={() => setCurrentPage('destination')} />
            </View>
            <View style={{ paddingBottom: 80 }}>
              <TravelStyleSection onNavigate={() => setCurrentPage('destination')} />
            </View>
            <View style={{ paddingBottom: 80 }}>
              <TopRatedSection onNavigate={() => setCurrentPage('destination')} />
            </View>
            <View style={{ paddingBottom: 80 }}>
              <TodaysEventSection onNavigate={() => setCurrentPage('destination')} />
            </View>
            <TravoraChatSection />
          </View>
        )}
      </View>
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="white" />
      
      {/* NAVBAR */}
      <View style={styles.navbar}>
        <TouchableOpacity onPress={() => handleTabPress(0, 'home')} style={styles.navLeft}>
          <FontAwesome5 name="map-marker-alt" size={28} color={COLORS.main} />
          <Text style={styles.logoText}>Travora</Text>
        </TouchableOpacity>

        <View style={styles.navCenter}>
          <View style={styles.tabContainer}>
            <NavTab title="Home" active={activeTab === 'home'} onPress={() => handleTabPress(0, 'home')} />
            <NavTab title="Event" active={activeTab === 'event'} onPress={() => handleTabPress(1, 'event')} />
            <NavTab title="Bookmark" active={activeTab === 'bookmark'} onPress={() => handleTabPress(2, 'bookmark')} />
            <NavTab title="Profile" active={activeTab === 'profile'} onPress={() => handleTabPress(3, 'profile')} />
          </View>
        </View>

        <View style={styles.navRight}>
          <TouchableOpacity style={styles.btnChatNav}>
            <MaterialIcons name="chat-bubble-outline" size={18} color="white" />
            <Text style={{ color: 'white', marginLeft: 5 }}>Chat</Text>
          </TouchableOpacity>
          {(!isLoggedIn || (currentPage !== 'profile' && currentPage !== 'bookmark')) && (
            <TouchableOpacity style={styles.btnLoginNav} onPress={toggleLogin}>
              <Text style={{ color: 'white', fontWeight: 'bold' }}>{isLoggedIn ? 'Log Out' : 'Log In'}</Text>
            </TouchableOpacity>
          )}
        </View>
      </View>

      <ScrollView ref={scrollViewRef} style={styles.scrollView} contentContainerStyle={{ flexGrow: 1 }}>
        {renderPage()}
        <Footer onScrollTop={scrollToTop} />
      </ScrollView>
    </SafeAreaView>
  );
}

// --- SUB-COMPONENTS ---

// 1. HERO SECTION
const HeroSection = ({ onSearch, initialQuery }) => {
  const [text, setText] = useState(initialQuery);
  return (
    <View style={{ height: 600, width: '100%', position: 'relative' }}>
      <Image source={{ uri: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&q=80' }} style={StyleSheet.absoluteFillObject} />
      <View style={styles.overlayDark} />
      <View style={[styles.heroContent, { paddingHorizontal: PAD_HOR }]}>
        <View style={styles.rowCenter}>
          <FontAwesome5 name="globe-americas" size={20} color="#ddd" />
          <Text style={{ color: '#eee', fontSize: 16, marginLeft: 8, fontWeight: '500' }}>Let's discover the beauty of Bali</Text>
        </View>
        <View style={{ marginTop: 20 }}>
          <Text style={{ fontSize: 56, fontWeight: 'bold', color: 'white', lineHeight: 65 }}>Evening!{"\n"}<Text style={{ color: COLORS.light }}>Ready to explore?</Text></Text>
        </View>
        <Text style={{ fontSize: 48, fontWeight: 'bold', color: 'white', marginTop: 10 }}>The Best Ubud Experience</Text>
        <View style={styles.searchBoxWrapper}>
          <View style={{ width: 20 }} />
          <TextInput 
            style={{ flex: 1, fontSize: 16, height: 40 }}
            placeholder="Where do you want to go?"
            placeholderTextColor="#999"
            value={text}
            onChangeText={setText}
            onSubmitEditing={() => onSearch(text)}
          />
          <TouchableOpacity onPress={() => onSearch(text)} style={styles.searchBtn}>
            <Ionicons name="search" size={24} color="white" />
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
};

// 2. SEARCH RESULTS SECTION
const SearchResultsSection = ({ query, onHomeTap, onNavigate }) => {
  return (
    <View style={{ paddingHorizontal: PAD_HOR, paddingVertical: 40, minHeight: 600 }}>
      <View style={styles.rowCenter}>
        <TouchableOpacity onPress={onHomeTap}><Text style={{ fontSize: 18, color: COLORS.light, fontWeight: '500' }}>Home</Text></TouchableOpacity>
        <Text style={{ fontSize: 18, color: 'grey', marginHorizontal: 5 }}> {'>'} {query} </Text>
      </View>
      <View style={styles.divider} />
      <Text style={{ fontSize: 36, fontWeight: 'bold', marginTop: 30 }}>{query || "Search Result"}</Text>
      <Text style={{ fontSize: 18, fontWeight: '500', marginTop: 10 }}>4 Result Found</Text>
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 20, marginTop: 40 }}>
        <ResultCard title="Monkey Forest Ubud" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600" onPress={onNavigate} />
        <ResultCard title="Ulun Danu Beratan" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600" onPress={onNavigate} />
        <ResultCard title="Campuhan Ridge" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600" onPress={onNavigate} />
        <ResultCard title="Tanah Lot" img="https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600" onPress={onNavigate} />
      </View>
    </View>
  );
};

// 3. POPULAR PLACES SECTION
const PopularPlacesSection = ({ onNavigate }) => {
  const scrollRef = useRef(null);

  const scrollPopular = (offset) => {
    scrollRef.current?.scrollTo({ x: offset > 0 ? 300 : 0, animated: true });
  };

  return (
    <View style={{ paddingHorizontal: PAD_HOR, flexDirection: 'row' }}>
      <View style={{ flex: 2, marginRight: 30 }}>
        <Text style={{ fontSize: 42, fontWeight: 'bold', lineHeight: 50 }}>Populer Place{'\n'}Now</Text>
        <Text style={{ fontSize: 18, color: '#666', marginTop: 20 }}>Discover the most popular{'\n'}travel spots in Bali right now.</Text>
      </View>
      <View style={{ flex: 4, flexDirection: 'row', alignItems: 'center' }}>
        <TouchableOpacity onPress={() => scrollPopular(-1)} style={styles.circleBtn}><Ionicons name="arrow-back" size={24} color={COLORS.main} /></TouchableOpacity>
        <ScrollView ref={scrollRef} horizontal showsHorizontalScrollIndicator={false} style={{ marginHorizontal: 15 }}>
          <PlaceCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600" onPress={onNavigate} />
          <PlaceCard title="Ulun Danu" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600" onPress={onNavigate} />
          <PlaceCard title="Campuhan" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600" onPress={onNavigate} />
          <PlaceCard title="Tanah Lot" img="https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600" onPress={onNavigate} />
          <PlaceCard title="Tegalalang" img="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=600" onPress={onNavigate} />
        </ScrollView>
        <TouchableOpacity onPress={() => scrollPopular(1)} style={styles.circleBtn}><Ionicons name="arrow-forward" size={24} color={COLORS.main} /></TouchableOpacity>
      </View>
    </View>
  );
};

// ... Sections 4, 5, 6 same structure ...
const ExploreUbudSection = ({ onNavigate }) => {
  return (
    <View style={{ backgroundColor: COLORS.bg, paddingHorizontal: PAD_HOR, paddingVertical: 40 }}>
      <Text style={{ fontSize: 36, fontWeight: 'bold', textAlign: 'center', marginBottom: 40 }}>Explore Ubud</Text>
      <View style={{ height: 400, flexDirection: 'row', gap: 20 }}>
        <TouchableOpacity style={{ flex: 1, borderRadius: 16, overflow: 'hidden' }} onPress={onNavigate}>
          <Image source={{ uri: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=800' }} style={{ width: '100%', height: '100%' }} />
        </TouchableOpacity>
        <View style={{ flex: 1, gap: 20 }}>
          <TouchableOpacity style={{ flex: 1, borderRadius: 16, overflow: 'hidden' }} onPress={onNavigate}><Image source={{ uri: 'https://images.unsplash.com/photo-1554481923-a6918bd997bc?q=80&w=800' }} style={{ width: '100%', height: '100%' }} /></TouchableOpacity>
          <TouchableOpacity style={{ flex: 1, borderRadius: 16, overflow: 'hidden' }} onPress={onNavigate}><Image source={{ uri: 'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=800' }} style={{ width: '100%', height: '100%' }} /></TouchableOpacity>
        </View>
        <TouchableOpacity style={{ flex: 1, borderRadius: 16, overflow: 'hidden' }} onPress={onNavigate}>
          <Image source={{ uri: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=800' }} style={{ width: '100%', height: '100%' }} />
        </TouchableOpacity>
      </View>
    </View>
  );
};

const TravelStyleSection = ({ onNavigate }) => {
  return (
    <View style={{ paddingHorizontal: PAD_HOR }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}><View style={{ width: 4, height: 28, backgroundColor: 'black', marginRight: 10 }} /><Text style={{ fontSize: 32, fontWeight: 'bold' }}>Travel Style</Text></View>
        <TouchableOpacity style={styles.viewMoreBtn}><Text style={{ color: 'white', fontWeight: 'bold' }}>View More</Text></TouchableOpacity>
      </View>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={{ marginVertical: 30 }}><TagItem label="Culture" icon="theater-masks" active /><TagItem label="Adventure" icon="compass" /><TagItem label="Art" /><TagItem label="Food" /></ScrollView>
      <View style={{ flexDirection: 'row', gap: 20 }}>
        <StyleCard title="Monkey Forest" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=400" onPress={onNavigate} />
        <StyleCard title="Sacred Monkey" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400" onPress={onNavigate} />
        <StyleCard title="Ubud Yoga" img="https://images.unsplash.com/photo-1598091383021-15ddea10925d?q=80&w=400" onPress={onNavigate} />
        <StyleCard title="Local Culture" img="https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=400" onPress={onNavigate} />
      </View>
    </View>
  );
};

const TopRatedSection = ({ onNavigate }) => {
  return (
    <View style={{ backgroundColor: COLORS.bg, paddingHorizontal: PAD_HOR, paddingVertical: 40 }}>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 40 }}>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}><View style={{ width: 4, height: 28, backgroundColor: 'black', marginRight: 10 }} /><Text style={{ fontSize: 32, fontWeight: 'bold' }}>Top-Rated Travel Experiences</Text></View>
        <View style={{ flexDirection: 'row', gap: 20 }}><Text style={{ fontSize: 18, fontWeight: 'bold', textDecorationLine: 'underline' }}>All</Text><Text style={{ fontSize: 18, color: '#666' }}>Adventure</Text><Text style={{ fontSize: 18, color: '#666' }}>Culture</Text></View>
      </View>
      <View style={{ flexDirection: 'row', gap: 20 }}>
        <StyleCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=600" onPress={onNavigate} />
        <StyleCard title="Ulun Danu" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=600" onPress={onNavigate} />
        <StyleCard title="Campuhan" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=600" onPress={onNavigate} />
        <StyleCard title="Tanah Lot" img="https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=600" onPress={onNavigate} />
      </View>
    </View>
  );
};

// 7. TODAY'S EVENT SECTION (WITH REACT-NATIVE-CALENDARS)
const TodaysEventSection = ({ onNavigate }) => {
  const [selectedDate, setSelectedDate] = useState('2025-05-27');

  return (
    <View style={{ paddingHorizontal: PAD_HOR }}>
      <View style={{ flexDirection: 'row', alignItems: 'center' }}>
        <View style={{ width: 4, height: 28, backgroundColor: 'black', marginRight: 10 }} />
        <Text style={{ fontSize: 32, fontWeight: 'bold' }}>Today's Event</Text>
      </View>
      <Text style={{ fontSize: 18, color: '#333', marginTop: 10, marginBottom: 40 }}>Events available today, on the {selectedDate.split('-')[2]}th.</Text>
      
      <View style={{ flexDirection: 'row', gap: 40 }}>
        <View style={{ flex: 3, flexDirection: 'row', flexWrap: 'wrap', gap: 20 }}>
          <EventCard title="Legong Dance" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400" onPress={onNavigate} />
          <EventCard title="Kecak Fire" img="https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=400" onPress={onNavigate} />
        </View>
        
        {/* React Native Calendars Integration */}
        <View style={{ flex: 2, backgroundColor: 'white', borderRadius: 20, padding: 20, elevation: 5, shadowColor: '#000', shadowOffset: {width: 0, height: 2}, shadowOpacity: 0.1, shadowRadius: 8 }}>
          <Calendar
            current={'2025-05-27'}
            onDayPress={day => {
              setSelectedDate(day.dateString);
            }}
            markedDates={{
              [selectedDate]: {selected: true, disableTouchEvent: true, selectedDotColor: 'orange'}
            }}
            theme={{
              backgroundColor: '#ffffff',
              calendarBackground: '#ffffff',
              textSectionTitleColor: '#9CA3AF', // Gray for Mon/Tue etc
              selectedDayBackgroundColor: COLORS.light, // Blue circle
              selectedDayTextColor: '#ffffff',
              todayTextColor: COLORS.light,
              dayTextColor: '#1F2937',
              textDisabledColor: '#d9e1e8',
              arrowColor: '#1F2937',
              monthTextColor: '#1F2937',
              indicatorColor: COLORS.light,
              textDayFontWeight: '500',
              textMonthFontWeight: 'bold',
              textDayHeaderFontWeight: '600',
              textDayFontSize: 16,
              textMonthFontSize: 18,
              textDayHeaderFontSize: 14
            }}
            // Custom arrows to match Figma (Simple chevrons)
            renderArrow={(direction) => (
              <Ionicons 
                name={direction === 'left' ? 'chevron-back' : 'chevron-forward'} 
                size={24} 
                color="#1F2937" 
              />
            )}
            enableSwipeMonths={true}
          />
        </View>
      </View>
    </View>
  );
};

// 8. CHAT SECTION
const TravoraChatSection = () => {
  return (
    <View style={{ backgroundColor: COLORS.bg, paddingHorizontal: PAD_HOR, paddingVertical: 80, flexDirection: 'row' }}>
      <View style={{ flex: 1 }}>
        <Text style={{ fontSize: 42, fontWeight: 'bold' }}>Need quick answers?</Text>
        <Text style={{ fontSize: 18, color: '#333', marginTop: 20, marginBottom: 40 }}>Meet Travora’s smart WhatsApp assistant...</Text>
        <TouchableOpacity style={{ backgroundColor: '#64829F', paddingHorizontal: 32, paddingVertical: 20, borderRadius: 12, flexDirection: 'row', alignSelf: 'flex-start' }}>
          <Ionicons name="chatbubble" size={18} color="white" />
          <Text style={{ color: 'white', fontSize: 18, fontWeight: 'bold', marginLeft: 10 }}>Chat</Text>
        </TouchableOpacity>
      </View>
      <View style={{ width: 80 }} />
      <View style={{ flex: 1, backgroundColor: 'white', borderRadius: 20, overflow: 'hidden', height: 400, elevation: 5 }}>
        <View style={{ backgroundColor: '#64829F', padding: 20, flexDirection: 'row', alignItems: 'center' }}>
          <Ionicons name="chatbox" size={28} color="white" />
          <Text style={{ color: 'white', fontSize: 20, fontWeight: 'bold', marginLeft: 12 }}>Travora chat</Text>
        </View>
        <View style={{ flex: 1, padding: 24 }}>
          <ChatBubble text="Halo! Saya Asisten Chat." isUser={false} />
          <ChatBubble text="Wisata yang populer?" isUser={true} />
        </View>
        <View style={{ padding: 16, borderTopWidth: 1, borderColor: '#eee', flexDirection: 'row', backgroundColor: '#f9f9f9' }}>
          <Text style={{ color: '#999', flex: 1 }}>ketik pertanyaanmu...</Text>
          <Text style={{ color: COLORS.main, fontWeight: 'bold' }}>Kirim</Text>
        </View>
      </View>
    </View>
  );
};

// --- DESTINATION PAGE (FIXED MAP) ---
const DestinationPage = ({ onBack }) => {
  const [imgIndex, setImgIndex] = useState(0);
  const images = [
    'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=1200',
    'https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=1200',
    'https://images.unsplash.com/photo-1516483638261-f4dbaf036963?q=80&w=1200'
  ];

  return (
    <View>
      {/* Hero */}
      <View style={{ height: 400 }}>
        <Image source={{ uri: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200' }} style={StyleSheet.absoluteFillObject} />
        <View style={styles.overlayDark} />
        <View style={{ paddingHorizontal: PAD_HOR, justifyContent: 'center', flex: 1 }}>
          <View style={{ flexDirection: 'row' }}>
            <View style={{ width: 5, height: 48, backgroundColor: 'white', marginRight: 15 }} />
            <Text style={{ fontSize: 48, fontWeight: 'bold', color: 'white' }}>Destination</Text>
          </View>
        </View>
      </View>

      <View style={{ paddingHorizontal: PAD_HOR, paddingVertical: 40 }}>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          <Text onPress={onBack} style={{ fontSize: 18, color: COLORS.light, fontWeight: '500' }}>Home</Text>
          <Text style={{ fontSize: 18, color: 'grey' }}> {'>'} Destination</Text>
        </View>
        <View style={styles.divider} />

        {/* Gallery */}
        <View style={{ height: 500, borderRadius: 20, overflow: 'hidden', marginVertical: 40 }}>
          <Image source={{ uri: images[imgIndex] }} style={{ width: '100%', height: '100%' }} />
        </View>
        <View style={{ flexDirection: 'row', justifyContent: 'center', gap: 40, marginBottom: 80 }}>
          <TouchableOpacity onPress={() => setImgIndex(0)} style={styles.navBtnRound}><Ionicons name="arrow-back" size={20} color={COLORS.light} /><Text style={{ marginLeft: 10 }}>Back</Text></TouchableOpacity>
          <TouchableOpacity onPress={() => setImgIndex(1)} style={styles.navBtnRound}><Text style={{ marginRight: 10 }}>Next</Text><Ionicons name="arrow-forward" size={20} color={COLORS.light} /></TouchableOpacity>
        </View>

        {/* Details Two Column */}
        <View style={{ flexDirection: 'row', gap: 60 }}>
          <View style={{ flex: 2 }}>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
              <Text style={{ fontSize: 36, fontWeight: 'bold' }}>Monkey Forest Ubud</Text>
              <FontAwesome5 name="bookmark" size={40} color={COLORS.light} />
            </View>
            <View style={{ flexDirection: 'row', alignItems: 'center', marginVertical: 10 }}>
              <MaterialIcons name="location-on" size={20} color="grey" />
              <Text style={{ fontSize: 16 }}> JL. Monkey Forest, Ubud, Gianyar, Bali</Text>
            </View>
            <Text style={{ fontSize: 16, lineHeight: 26, marginVertical: 20 }}>Discover the sacred Monkey Forest in Ubud, where hundreds of playful monkeys live freely among ancient temples and lush jungle.</Text>
            <View style={{ flexDirection: 'row', gap: 10, marginBottom: 40 }}>
              <TagBadge text="Adventure" />
              <TagBadge text="Spiritual" />
            </View>

            <Text style={{ fontSize: 24, fontWeight: 'bold', marginBottom: 20 }}>Facilities</Text>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginBottom: 40 }}>
              <IconCol icon="camera" label="Photo area" />
              <IconCol icon="parking" label="Parking" />
              <IconCol icon="restroom" label="Toilet" />
              <IconCol icon="user" label="Guide" />
              <IconCol icon="store" label="Shop" />
            </View>

            <Text style={{ fontSize: 24, fontWeight: 'bold', marginBottom: 20 }}>Available Ticket</Text>
            <View style={{ flexDirection: 'row', gap: 10, marginBottom: 20 }}>
              <TicketBtn label="Solo Trip" icon="user" active />
              <TicketBtn label="Romantic" icon="heart" />
              <TicketBtn label="Group" icon="users" />
            </View>
            <View style={{ flexDirection: 'row', gap: 10, marginBottom: 20 }}>
              <TouchableOpacity style={{ backgroundColor: COLORS.sos, paddingHorizontal: 20, paddingVertical: 10, borderRadius: 20 }}><Text style={{ color: 'white', fontWeight: 'bold' }}>SOS</Text></TouchableOpacity>
              <TouchableOpacity style={{ backgroundColor: COLORS.light, paddingHorizontal: 20, paddingVertical: 10, borderRadius: 20 }}><Text style={{ color: 'white', fontWeight: 'bold' }}>Do & Don't</Text></TouchableOpacity>
            </View>
            
            <View style={{ borderWidth: 1, borderColor: '#eee', borderRadius: 16, padding: 24 }}>
              <Text style={{ fontSize: 20, fontWeight: 'bold', marginBottom: 10 }}>Solo Trip</Text>
              <Text style={{ color: 'grey', marginBottom: 10 }}>Includes:</Text>
              <CheckRow text="Entrance fee" />
              <CheckRow text="Traditional attire" />
              <CheckRow text="Free Parking" />
              <View style={styles.divider} />
              <Text style={{ fontSize: 24, fontWeight: 'bold', color: COLORS.gold }}>IDR. 80.000</Text>
            </View>
          </View>

          {/* Right Column: Map & Review */}
          <View style={{ flex: 1 }}>
            {/* Functional Map for Web (Iframe) */}
            <View style={{ backgroundColor: 'white', padding: 12, borderRadius: 16, elevation: 2, marginBottom: 40 }}>
              {Platform.OS === 'web' ? (
                <View style={{ height: 250, width: '100%', borderRadius: 12, overflow: 'hidden' }}>
                  <iframe
                    width="100%"
                    height="100%"
                    frameBorder="0"
                    scrolling="no"
                    marginHeight="0"
                    marginWidth="0"
                    src="https://www.openstreetmap.org/export/embed.html?bbox=115.25919%2C-8.52314%2C115.26719%2C-8.51514&amp;layer=mapnik&amp;marker=-8.51914%2C115.26319"
                    style={{ border: 0 }}
                  ></iframe>
                </View>
              ) : (
                <Image source={{ uri: 'https://images.unsplash.com/photo-1569336415962-a4bd9f69cd83?q=80&w=600' }} style={{ height: 250, width: '100%', borderRadius: 12 }} />
              )}
              <TouchableOpacity style={{ backgroundColor: '#ddd', padding: 12, marginTop: 10, alignItems: 'center', borderRadius: 8 }}>
                <Text style={{ fontWeight: 'bold' }}>View on Google Maps</Text>
              </TouchableOpacity>
            </View>

            <View style={{ backgroundColor: 'white', padding: 24, borderRadius: 16, elevation: 2 }}>
              <Text style={{ fontSize: 24, fontWeight: 'bold', textAlign: 'center' }}>Reviews</Text>
              <Text style={{ fontSize: 48, fontWeight: 'bold', color: COLORS.gold, textAlign: 'center' }}>4.9</Text>
              <View style={{ flexDirection: 'row', justifyContent: 'center' }}><Ionicons name="star" size={20} color={COLORS.gold} /><Ionicons name="star" size={20} color={COLORS.gold} /><Ionicons name="star" size={20} color={COLORS.gold} /><Ionicons name="star" size={20} color={COLORS.gold} /><Ionicons name="star" size={20} color={COLORS.gold} /></View>
              <Text style={{ textAlign: 'center', color: 'grey', marginVertical: 10 }}>Based on 5 reviews</Text>
              <View style={styles.divider} />
              <ReviewItem name="Riyo (you)" text="Sangat rekomendasi." />
              <ReviewItem name="Nielsun" text="Tempat indah." />
            </View>
          </View>
        </View>

        {/* All Destination */}
        <View style={{ marginTop: 80 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 40 }}>
            <View style={{ width: 4, height: 28, backgroundColor: 'black', marginRight: 10 }} />
            <Text style={{ fontSize: 32, fontWeight: 'bold' }}>All Destination</Text>
          </View>
          <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 20 }}>
            <RecCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=400" />
            <RecCard title="Jungle Trek" img="https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?q=80&w=400" />
          </View>
        </View>
      </View>
    </View>
  );
};

// ... BookmarkPage and ProfilePage remain consistent ...
const BookmarkPage = ({ isLoggedIn, onToggleLogin, onNavigate }) => {
  return (
    <View>
      <View style={{ height: 400 }}>
        <Image source={{ uri: 'https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1200' }} style={StyleSheet.absoluteFillObject} />
        <View style={styles.overlayDark} />
        <View style={{ paddingHorizontal: PAD_HOR, justifyContent: 'center', flex: 1 }}><View style={{ flexDirection: 'row' }}><View style={{ width: 5, height: 48, backgroundColor: 'white', marginRight: 15 }} /><Text style={{ fontSize: 48, fontWeight: 'bold', color: 'white' }}>Bookmark</Text></View></View>
      </View>
      <View style={{ paddingHorizontal: PAD_HOR, paddingVertical: 60 }}>
        <Text style={{ fontSize: 18, color: COLORS.light, fontWeight: '500' }}>Bookmark</Text>
        <View style={styles.divider} />
        {!isLoggedIn ? (
          <View style={{ alignItems: 'center', paddingVertical: 50 }}>
            <Text style={{ fontSize: 32 }}>Please login first</Text>
            <TouchableOpacity onPress={onToggleLogin} style={{ backgroundColor: COLORS.light, paddingHorizontal: 40, paddingVertical: 15, borderRadius: 30, marginTop: 30 }}><Text style={{ color: 'white', fontWeight: 'bold', fontSize: 18 }}>Login / Sign up</Text></TouchableOpacity>
          </View>
        ) : (
          <View>
            <View style={{ flexDirection: 'row', marginBottom: 40 }}><TouchableOpacity style={{ backgroundColor: COLORS.light, padding: 12, borderRadius: 4 }}><Text style={{ color: 'white', fontWeight: 'bold' }}>Choose</Text></TouchableOpacity><TouchableOpacity style={{ backgroundColor: COLORS.sos, padding: 12, borderRadius: 4, marginLeft: 15, flexDirection: 'row' }}><Text style={{ color: 'white', fontWeight: 'bold' }}>Delete All</Text><Ionicons name="trash" color="white" size={16} /></TouchableOpacity></View>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 20 }}><RecCard title="Monkey Forest" img="https://images.unsplash.com/photo-1544644181-1484b3fdfc62?q=80&w=400" onPress={onNavigate} /><RecCard title="Sacred Monkey" img="https://images.unsplash.com/photo-1537953773345-d172ccf13cf1?q=80&w=400" onPress={onNavigate} /></View>
          </View>
        )}
      </View>
    </View>
  );
};

const ProfilePage = ({ isLoggedIn, onToggleLogin }) => {
  return (
    <View>
      <View style={{ height: 400 }}>
        <Image source={{ uri: 'https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=1200' }} style={StyleSheet.absoluteFillObject} />
        <View style={styles.overlayDark} />
        <View style={{ paddingHorizontal: PAD_HOR, justifyContent: 'center', flex: 1 }}><View style={{ flexDirection: 'row' }}><View style={{ width: 5, height: 48, backgroundColor: 'white', marginRight: 15 }} /><Text style={{ fontSize: 48, fontWeight: 'bold', color: 'white' }}>Profile</Text></View></View>
      </View>
      <View style={{ paddingHorizontal: PAD_HOR, paddingVertical: 60 }}>
        <Text style={{ fontSize: 18, color: COLORS.light, fontWeight: '500' }}>Profile</Text>
        <View style={styles.divider} />
        {!isLoggedIn ? (
          <View style={{ alignItems: 'center', paddingVertical: 50 }}>
            <TouchableOpacity onPress={onToggleLogin} style={styles.loginBtn}><Text style={styles.btnTextWhite}>Login / Sign up</Text></TouchableOpacity>
          </View>
        ) : (
          <View>
            <Text style={styles.titleBig}>Hallo,</Text><Text style={styles.titleBig}>Riyo Sumedang</Text><Text style={{ fontSize: 18, color: 'grey', marginBottom: 40 }}>riyookkkkkk@gmail.com</Text>
            <View style={{ maxWidth: 400, gap: 20 }}><ProfileItem icon="edit" text="Edit name" /><ProfileItem icon="lock" text="Change password" /><TouchableOpacity onPress={onToggleLogin} style={{ backgroundColor: COLORS.sos, padding: 15, borderRadius: 30, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}><Text style={{ color: 'white', fontWeight: 'bold', fontSize: 18 }}>Log out</Text><MaterialIcons name="logout" color="white" size={20} style={{ marginLeft: 10 }} /></TouchableOpacity></View>
          </View>
        )}
      </View>
    </View>
  );
};

// --- FOOTER (FIXED LAYOUT) ---
const Footer = ({ onScrollTop }) => (
  <View style={{ padding: 50, borderTopWidth: 1, borderColor: '#eee' }}>
    <View style={{ flexDirection: 'row', justifyContent: 'center', alignItems: 'center', position: 'relative' }}>
      <TouchableOpacity onPress={onScrollTop} style={{ flexDirection: 'row', alignItems: 'center' }}>
        <FontAwesome5 name="map-marker-alt" size={36} color={COLORS.main} />
        <Text style={{ fontSize: 32, fontWeight: 'bold', color: COLORS.main, marginLeft: 10 }}>Travora</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={onScrollTop} style={{ width: 50, height: 50, backgroundColor: COLORS.light, borderRadius: 25, alignItems: 'center', justifyContent: 'center', position: 'absolute', right: 0 }}>
          <Ionicons name="arrow-up" color="white" size={24} />
      </TouchableOpacity>
    </View>
    <View style={{ height: 1, backgroundColor: '#ddd', width: '100%', marginVertical: 20 }} />
    <View style={{ alignItems: 'flex-end' }}>
      <Text style={{ color: 'grey' }}>Copyright © 2025 • Travora.</Text>
    </View>
  </View>
);

// --- ATOMIC COMPONENTS & WIDGETS ---

const NavTab = ({ title, active, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ paddingHorizontal: 20 }}>
    <Text style={{ fontSize: 16, fontWeight: active ? 'bold' : '500', color: active ? 'black' : 'grey' }}>{title}</Text>
  </TouchableOpacity>
);

const ResultCard = ({ title, img, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ width: 250, borderRadius: 16, backgroundColor: 'white', elevation: 3, marginBottom: 10 }}>
    <Image source={{ uri: img }} style={{ width: '100%', height: 160, borderTopLeftRadius: 16, borderTopRightRadius: 16 }} />
    <View style={{ padding: 16 }}>
      <Text style={{ fontWeight: 'bold', fontSize: 16 }}>{title}</Text>
      <Text style={{ fontSize: 12, color: 'grey' }}>Protected forest...</Text>
    </View>
  </TouchableOpacity>
);

const PlaceCard = ({ title, img, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ width: 220, height: 320, borderRadius: 16, marginRight: 20, overflow: 'hidden' }}>
    <Image source={{ uri: img }} style={StyleSheet.absoluteFillObject} />
    <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.3)', justifyContent: 'space-between', padding: 15 }}>
      <View style={{ backgroundColor: 'white', alignSelf: 'flex-start', paddingHorizontal: 8, paddingVertical: 4, borderRadius: 12, flexDirection: 'row' }}><Ionicons name="star" color="orange" size={14} /><Text style={{ fontSize: 12, fontWeight: 'bold' }}> 4.9</Text></View>
      <View>
        <Text style={{ color: 'white', fontSize: 16, fontWeight: 'bold' }}>{title}</Text>
        <View style={{ backgroundColor: COLORS.main, alignSelf: 'flex-end', paddingHorizontal: 10, paddingVertical: 4, borderRadius: 12 }}><Text style={{ color: 'white', fontSize: 10, fontWeight: 'bold' }}>Adventure</Text></View>
      </View>
    </View>
  </TouchableOpacity>
);

const StyleCard = ({ title, img, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ width: 250, backgroundColor: 'white', borderRadius: 16, elevation: 2, marginBottom: 20 }}>
    <Image source={{ uri: img }} style={{ width: '100%', height: 120, borderTopLeftRadius: 16, borderTopRightRadius: 16 }} />
    <View style={{ padding: 16 }}>
      <Text style={{ fontWeight: 'bold' }}>{title}</Text>
      <Text style={{ fontSize: 10, color: 'grey', marginVertical: 5 }}>Protected area...</Text>
      <Text style={{ fontSize: 10, color: 'white', backgroundColor: COLORS.light, alignSelf: 'flex-end', padding: 4, borderRadius: 4 }}>LEARN MORE</Text>
    </View>
  </TouchableOpacity>
);

const EventCard = ({ title, img, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ width: 280, backgroundColor: 'white', borderRadius: 16, elevation: 2 }}>
    <Image source={{ uri: img }} style={{ width: '100%', height: 150, borderTopLeftRadius: 16, borderTopRightRadius: 16 }} />
    <View style={{ padding: 16 }}>
      <Text style={{ fontWeight: 'bold', fontSize: 16 }}>{title}</Text>
      <Text style={{ fontSize: 10, color: 'white', backgroundColor: COLORS.light, alignSelf: 'flex-end', padding: 4, borderRadius: 4, marginTop: 10 }}>FREE ACCESS</Text>
    </View>
  </TouchableOpacity>
);

const ChatBubble = ({ text, isUser }) => (
  <View style={{ alignSelf: isUser ? 'flex-end' : 'flex-start', backgroundColor: isUser ? COLORS.light : '#f0f0f0', padding: 12, borderRadius: 12, marginBottom: 10, maxWidth: '80%' }}>
    <Text style={{ color: isUser ? 'white' : 'black' }}>{text}</Text>
  </View>
);

const TagBadge = ({ text }) => (
  <View style={{ backgroundColor: COLORS.light, paddingHorizontal: 20, paddingVertical: 8, borderRadius: 8 }}>
    <Text style={{ color: 'white', fontWeight: 'bold' }}>{text}</Text>
  </View>
);

const IconCol = ({ icon, label }) => (
  <View style={{ alignItems: 'center' }}><FontAwesome5 name={icon} size={32} color="#333" /><Text style={{ fontSize: 12, marginTop: 8 }}>{label}</Text></View>
);

const TicketBtn = ({ label, icon, active }) => (
  <View style={{ flexDirection: 'row', padding: 12, borderRadius: 12, borderWidth: active ? 2 : 1, borderColor: active ? COLORS.light : '#ddd', alignItems: 'center' }}><FontAwesome5 name={icon} size={16} color={active ? COLORS.light : 'grey'} /><Text style={{ marginLeft: 8, fontWeight: 'bold', color: active ? 'black' : 'grey' }}>{label}</Text></View>
);

const CheckRow = ({ text }) => (
  <View style={{ flexDirection: 'row', marginBottom: 8 }}><FontAwesome5 name="check" color={COLORS.light} size={14} /><Text style={{ marginLeft: 10, color: 'grey' }}>{text}</Text></View>
);

const ReviewItem = ({ name, text }) => (
  <View style={{ marginBottom: 15 }}>
    <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}><Text style={{ fontWeight: 'bold', fontSize: 12 }}>{name}</Text><Text style={{ fontSize: 10, color: 'grey' }}>1 hari lalu</Text></View>
    <Text style={{ fontSize: 12, marginTop: 4 }}>{text}</Text>
  </View>
);

const RecCard = ({ title, img, onPress }) => (
  <TouchableOpacity onPress={onPress} style={{ width: 300, height: 200, borderRadius: 16, overflow: 'hidden', marginBottom: 20 }}>
    <Image source={{ uri: img }} style={StyleSheet.absoluteFillObject} />
    <View style={styles.overlayDark} />
    <View style={{ position: 'absolute', bottom: 15, left: 15 }}><Text style={{ color: 'white', fontWeight: 'bold', fontSize: 18 }}>{title}</Text></View>
    <View style={{ position: 'absolute', bottom: 15, right: 15, backgroundColor: COLORS.light, padding: 5, borderRadius: 10 }}><Text style={{ color: 'white', fontSize: 10, fontWeight: 'bold' }}>Adventure</Text></View>
  </TouchableOpacity>
);

const TagItem = ({ label, icon, active }) => (
  <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 20, paddingVertical: 10, borderRadius: 8, backgroundColor: active ? COLORS.light : '#f0f0f0', marginRight: 15 }}>
    {icon && <FontAwesome5 name={icon} size={16} color={active ? 'white' : 'grey'} style={{ marginRight: 8 }} />}
    <Text style={{ fontWeight: 'bold', color: active ? 'white' : '#333' }}>{label}</Text>
  </View>
);

const ProfileItem = ({ icon, text }) => (
  <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', padding: 20, borderRadius: 12, backgroundColor: 'white', elevation: 2 }}>
    <FontAwesome5 name={icon} size={20} />
    <Text style={{ fontSize: 18, fontWeight: 'bold', marginLeft: 15 }}>{text}</Text>
  </TouchableOpacity>
);

// --- STYLES ---
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: 'white' },
  scrollView: { flex: 1 },
  navbar: { height: 90, flexDirection: 'row', alignItems: 'center', paddingHorizontal: PAD_HOR, borderBottomWidth: 1, borderColor: '#eee', backgroundColor: 'white', zIndex: 100 },
  navLeft: { flexDirection: 'row', alignItems: 'center', width: 200 },
  logoText: { fontSize: 24, fontWeight: 'bold', color: COLORS.main, marginLeft: 8 },
  navCenter: { position: 'absolute', left: 0, right: 0, alignItems: 'center', justifyContent: 'center', pointerEvents: 'none' },
  tabContainer: { flexDirection: 'row', pointerEvents: 'auto' },
  navRight: { marginLeft: 'auto', flexDirection: 'row', alignItems: 'center' },
  btnChatNav: { backgroundColor: COLORS.dark, paddingHorizontal: 20, paddingVertical: 12, borderRadius: 8, flexDirection: 'row', alignItems: 'center', marginRight: 15 },
  btnLoginNav: { backgroundColor: COLORS.light, paddingHorizontal: 24, paddingVertical: 12, borderRadius: 8 },
  overlayDark: { ...StyleSheet.absoluteFillObject, backgroundColor: 'rgba(0,0,0,0.3)' },
  heroContent: { flex: 1, justifyContent: 'center' },
  rowCenter: { flexDirection: 'row', alignItems: 'center' },
  searchBoxWrapper: { marginTop: 50, width: 600, maxWidth: '100%', backgroundColor: 'white', borderRadius: 8, padding: 8, flexDirection: 'row', alignItems: 'center' },
  searchBtn: { height: 50, width: 60, backgroundColor: COLORS.dark, borderRadius: 6, alignItems: 'center', justifyContent: 'center' },
  divider: { height: 1, backgroundColor: '#ddd', marginVertical: 15, width: '100%' },
  circleBtn: { width: 50, height: 50, borderRadius: 25, borderWidth: 1, borderColor: '#ddd', alignItems: 'center', justifyContent: 'center' },
  viewMoreBtn: { backgroundColor: COLORS.light, paddingHorizontal: 20, paddingVertical: 10, borderRadius: 20 },
  navBtnRound: { flexDirection: 'row', alignItems: 'center', padding: 10, borderWidth: 2, borderColor: COLORS.light, borderRadius: 30 },
  loginBtn: { backgroundColor: COLORS.light, paddingHorizontal: 40, paddingVertical: 12, borderRadius: 30 },
  btnTextWhite: { color: 'white', fontWeight: 'bold', fontSize: 18 },
});