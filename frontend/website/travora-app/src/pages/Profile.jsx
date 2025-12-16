import React, { useEffect, useState } from 'react';
import { User, Lock, Edit, LogOut, ChevronRight, Mail } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export default function Profile() {
  const navigate = useNavigate();
  // Ambil data user dari localStorage
  const [user, setUser] = useState(null);

  useEffect(() => {
    const storedUser = localStorage.getItem('travora_user');
    if (storedUser) {
        setUser(JSON.parse(storedUser));
    } else {
        // Jika tidak ada user, redirect ke halaman login
        navigate('/auth');
    }
  }, [navigate]);

  const handleLogout = () => {
    localStorage.removeItem('travora_user');
    navigate('/auth');
  };

  // Jika user null (sedang loading atau redirecting), tampilkan kosong
  if (!user) return null;

  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Hero Header */}
      <div className="h-[350px] relative w-full">
        <img src="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f" className="w-full h-full object-cover brightness-50" alt="Profile Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
             <div className="w-2 h-16 bg-white mr-6"></div>
             <h1 className="text-5xl md:text-6xl font-bold text-white">My Profile</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <div className="flex flex-col lg:flex-row gap-20">
             
             {/* Kolom Kiri: Info User */}
             <div className="lg:w-1/3 text-center lg:text-left">
               <div className="w-40 h-40 bg-gray-200 rounded-full mb-8 overflow-hidden mx-auto lg:mx-0 shadow-xl border-4 border-white">
                 <img 
                    src={user.image ? user.image : `https://ui-avatars.com/api/?name=${user.username}&background=5E9BF5&color=fff`} 
                    alt="Avatar" 
                    className="w-full h-full object-cover" 
                 />
               </div>
               <h1 className="text-4xl font-bold text-gray-900 mb-2 capitalize">{user.username}</h1>
               <div className="flex items-center justify-center lg:justify-start gap-2 text-gray-500 mb-6">
                  <Mail size={16} />
                  <span>{user.email}</span>
               </div>
               <div className="bg-[#EAFDF5] text-[#00966D] border border-[#00966D]/20 px-4 py-1.5 rounded-full text-sm font-bold w-fit mx-auto lg:mx-0">
                 Travora Member
               </div>
             </div>

             {/* Kolom Kanan: Menu Actions */}
             <div className="lg:w-2/3 flex flex-col gap-6">
               <h3 className="text-xl font-bold text-gray-900 mb-4">Account Settings</h3>
               
               <ProfileButton icon={<Edit size={24} />} text="Edit Profile" sub="Change your display name or photo" />
               <ProfileButton icon={<Lock size={24} />} text="Change Password" sub="Update your security credentials" />
               
               <div className="h-8"></div>
               <h3 className="text-xl font-bold text-gray-900 mb-4">Session</h3>

               <button onClick={handleLogout} className="bg-red-50 border border-red-100 text-red-600 rounded-2xl py-5 px-8 flex items-center justify-between hover:bg-red-100 transition shadow-sm w-full group">
                 <div className="flex items-center gap-4">
                    <LogOut size={24} />
                    <span className="font-bold text-lg">Log Out</span>
                 </div>
                 <ChevronRight className="opacity-50 group-hover:translate-x-1 transition" />
               </button>
             </div>
          </div>
      </div>
    </div>
  );
}

const ProfileButton = ({ icon, text, sub }) => (
  <button className="bg-white border border-gray-100 shadow-sm rounded-2xl py-6 px-8 flex items-center text-left hover:shadow-xl transition w-full transform hover:-translate-y-1 group">
    <span className="text-gray-400 mr-6 group-hover:text-[#5E9BF5] transition">{icon}</span>
    <div>
      <span className="font-bold text-lg text-gray-900 block">{text}</span>
      <span className="text-sm text-gray-400 font-light">{sub}</span>
    </div>
    <div className="ml-auto text-gray-300"><ChevronRight className="group-hover:translate-x-1 transition" /></div>
  </button>
);