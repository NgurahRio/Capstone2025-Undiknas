import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import EventCard from '../../components/cards/EventCard'; 

// --- WIDGET KALENDER DINAMIS ---
const CalendarWidget = () => {
    // 1. State untuk menyimpan Tanggal yang sedang dilihat (Default: Hari ini)
    const [currentDate, setCurrentDate] = useState(new Date());
    
    // 2. State untuk tanggal yang dipilih user (Default: Tanggal hari ini)
    const [selectedDay, setSelectedDay] = useState(new Date().getDate());

    // Daftar Nama Bulan
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    // Ambil Tahun dan Bulan dari state currentDate
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth(); // 0 = Jan, 11 = Dec

    // 3. FUNGSI AJAIB: Hitung jumlah hari dalam bulan ini
    // (Trik JS: tanggal '0' bulan depan = hari terakhir bulan ini)
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    // 4. Fungsi Ganti Bulan
    const prevMonth = () => {
        setCurrentDate(new Date(year, month - 1, 1));
        setSelectedDay(1); // Reset pilihan ke tanggal 1
    };

    const nextMonth = () => {
        setCurrentDate(new Date(year, month + 1, 1));
        setSelectedDay(1); // Reset pilihan ke tanggal 1
    };

    return (
      <div className="select-none">
        {/* HEADER: BULAN & TAHUN */}
        <div className="flex justify-between items-center mb-6 px-2">
          <button onClick={prevMonth} className="p-1 hover:bg-gray-100 rounded-full transition">
             <ChevronLeft className="text-gray-400 hover:text-black" />
          </button>
          
          <h3 className="font-bold text-lg text-gray-900 transition-all flex-1 text-center whitespace-nowrap">
            {monthNames[month]} {year}
        </h3>
          
          <button onClick={nextMonth} className="p-1 hover:bg-gray-100 rounded-full transition">
             <ChevronRight className="text-gray-400 hover:text-black" />
          </button>
        </div>

        {/* NAMA HARI */}
        <div className="grid grid-cols-7 text-center mb-4 text-xs font-bold text-gray-400 uppercase">
            {['S','M','T','W','T','F','S'].map((d, i) => <span key={i}>{d}</span>)}
        </div>

        {/* GRID TANGGAL (Dinamis 28-31 hari) */}
        <div className="grid grid-cols-7 gap-y-2 justify-items-center">
            {Array.from({ length: daysInMonth }, (_, i) => i + 1).map((day) => {
                const isSelected = day === selectedDay;
                return (
                    <button 
                        key={day} 
                        onClick={() => setSelectedDay(day)} 
                        className={`w-10 h-10 flex items-center justify-center rounded-full text-sm transition-all duration-300 ${
                            isSelected 
                            ? 'bg-[#82B1FF] text-white shadow-lg font-bold scale-110' 
                            : 'text-gray-700 hover:bg-gray-100'
                        }`}
                    >
                        {day}
                    </button>
                );
            })}
        </div>
      </div>
    );
};

// --- MAIN COMPONENT ---
export default function EventSection() {
    const navigate = useNavigate();
    const [events, setEvents] = useState([]);
    const [loading, setLoading] = useState(true);

    // Ganti IP Sesuai Laptop Backend
    const API_URL = 'http://172.20.10.12:8080/api/events';

    useEffect(() => {
        const fetchEvents = async () => {
            try {
                const response = await axios.get(API_URL);
                setEvents(response.data);
                setLoading(false);
            } catch (error) {
                console.error("Gagal ambil event:", error);
                setLoading(false);
            }
        };
        fetchEvents();
    }, []);

    return (
        <div>
            <div className="flex items-center gap-4 mb-3">
                <div className="w-2 h-10 bg-black rounded-full"></div>
                <h2 className="text-4xl font-bold text-gray-900">Today's Event</h2>
            </div>
            <p className="text-lg text-gray-500 mb-12 pl-6">Events available today.</p>
            
            <div className="flex flex-col lg:flex-row gap-12">
                <div className="flex-1 grid grid-cols-1 md:grid-cols-2 gap-8 content-start">
                    {loading ? (
                        <p className="p-4 text-gray-400">Loading events...</p>
                    ) : events.length === 0 ? (
                        <p className="p-4 text-gray-400">Tidak ada event ditemukan.</p>
                    ) : (
                        events.map((item) => {
                            let imgUrl = "https://via.placeholder.com/300";
                            if (item.images && item.images.length > 0) {
                                imgUrl = item.images[0].image;
                            }
                            return (
                                <EventCard 
                                    key={item.id_event}
                                    title={item.name_event} 
                                    loc={item.location} 
                                    img={imgUrl} 
                                    onPress={() => navigate(`/event/${item.id_event}`)} 
                                />
                            );
                        })
                    )}
                </div>

                <div className="lg:w-[350px] bg-white rounded-[32px] shadow-xl border border-gray-100 p-8 h-fit">
                    <CalendarWidget />
                </div>
            </div>
        </div>
    );
}