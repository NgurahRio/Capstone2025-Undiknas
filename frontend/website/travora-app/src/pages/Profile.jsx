import React, { useState } from 'react';
import { User, Lock, Edit, LogOut, ChevronRight } from 'lucide-react';
import { api } from '../api';

export default function Profile() {
  // Cek apakah ada data user tersimpan di localStorage
  const [user, setUser] = useState(() => JSON.parse(localStorage.getItem('travora_user')) || null);
  
  // State form login
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");
    try {
      const res = await api.post('/login', { username, password });
      if (res.data.status === "Success") {
        const userData = res.data.user;
        setUser(userData);
        localStorage.setItem('travora_user', JSON.stringify(userData)); // Simpan sesi
      } else {
        setError("Username atau Password salah!");
      }
    } catch (err) {
      setError("Terjadi kesalahan server.");
    }
  };

  const handleLogout = () => {
    setUser(null);
    localStorage.removeItem('travora_user');
  };

  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Hero Header */}
      <div className="h-[350px] relative w-full">
        <img src="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f" className="w-full h-full object-cover brightness-50" alt="Profile Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
             <div className="w-2 h-16 bg-white mr-6"></div>
             <h1 className="text-5xl md:text-6xl font-bold text-white">Profile</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <h2 className="text-[#82B1FF] text-xl font-bold mb-4 uppercase tracking-wide">Account Settings</h2>
        <div className="h-[1px] bg-gray-200 w-full mb-16"></div>

        {!user ? (
          // --- TAMPILAN LOGIN ---
          <div className="max-w-md mx-auto bg-white p-10 rounded-[32px] shadow-xl border border-gray-100 text-center">
             <div className="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center mx-auto mb-6">
               <Lock size={32} className="text-[#5E9BF5]" />
             </div>
             <h2 className="text-3xl font-bold mb-6 text-gray-900">Welcome Back!</h2>
             
             {error && <div className="bg-red-100 text-red-600 p-3 rounded-lg mb-4 text-sm font-bold">{error}</div>}

             <form onSubmit={handleLogin} className="space-y-4">
               <input 
                 type="text" 
                 placeholder="Username" 
                 value={username}
                 onChange={(e) => setUsername(e.target.value)}
                 className="w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200 outline-none focus:ring-2 focus:ring-[#82B1FF] transition"
                 required
               />
               <input 
                 type="password" 
                 placeholder="Password" 
                 value={password}
                 onChange={(e) => setPassword(e.target.value)}
                 className="w-full px-6 py-4 rounded-xl bg-gray-50 border border-gray-200 outline-none focus:ring-2 focus:ring-[#82B1FF] transition"
                 required
               />
               <button type="submit" className="w-full bg-[#5E9BF5] text-white font-bold py-4 rounded-xl hover:bg-[#4a8cdb] transition shadow-lg shadow-blue-200 mt-4">
                 Log In
               </button>
             </form>
          </div>
        ) : (
          // --- TAMPILAN SUDAH LOGIN ---
          <div className="flex flex-col lg:flex-row gap-20">
             <div className="lg:w-1/3 text-center lg:text-left">
               <div className="w-32 h-32 bg-gray-200 rounded-full mb-6 overflow-hidden mx-auto lg:mx-0 shadow-inner border-4 border-white shadow-gray-200">
                 {/* Jika ada gambar di DB, pakai itu. Jika tidak, pakai avatar default */}
                 <img src="https://i.pravatar.cc/300" alt="Avatar" className="w-full h-full object-cover" />
               </div>
               <h1 className="text-4xl font-bold text-gray-900 mb-2">{user.username}</h1>
               <p className="text-lg text-gray-500 mb-2 font-light">{user.email || 'user@travora.com'}</p>
               <div className="bg-green-100 text-green-700 px-4 py-1 rounded-full text-sm font-bold w-fit mx-auto lg:mx-0 mt-4">
                 Member Active
               </div>
             </div>

             <div className="lg:w-2/3 flex flex-col gap-6">
               <ProfileButton icon={<Edit size={24} />} text="Edit Profile" sub="Change your display name" />
               <ProfileButton icon={<Lock size={24} />} text="Change Password" sub="Update your security credentials" />
               
               <div className="h-4"></div>
               
               <button onClick={handleLogout} className="bg-[#EF685B] text-white rounded-2xl py-5 px-8 flex items-center justify-center gap-3 hover:bg-opacity-90 transition shadow-lg shadow-red-100 transform hover:-translate-y-1 w-full lg:w-fit">
                 <span className="font-bold text-xl">Log out</span>
                 <LogOut size={24} />
               </button>
             </div>
          </div>
        )}
      </div>
    </div>
  );
}

const ProfileButton = ({ icon, text, sub }) => (
  <button className="bg-white border border-gray-100 shadow-sm rounded-2xl py-6 px-8 flex items-center text-left hover:shadow-xl transition w-full transform hover:-translate-y-1 group">
    <span className="text-gray-400 mr-6 group-hover:text-[#5E9BF5] transition">{icon}</span>
    <div>
      <span className="font-bold text-xl text-gray-900 block">{text}</span>
      <span className="text-sm text-gray-400 font-light">{sub}</span>
    </div>
    <div className="ml-auto text-gray-300"><ChevronRight /></div>
  </button>
);