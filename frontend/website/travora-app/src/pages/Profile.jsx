import React from 'react';
import { User, Edit, Lock, MessageCircle, LogOut, ChevronRight } from 'lucide-react';

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

export default function Profile({ isLoggedIn, onToggleLogin }) {
  return (
    <div className="w-full animate-fade-in pb-20">
      <div className="h-[450px] relative w-full">
        <img src="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f?q=80&w=1200" className="w-full h-full object-cover brightness-50" alt="Profile Hero" />
        <div className="absolute inset-0 flex items-center justify-center">
          <div className="max-w-7xl w-full px-6 flex items-center">
            <div className="w-2 h-16 bg-white mr-6"></div>
            <h1 className="text-6xl font-bold text-white">Profile</h1>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto w-full px-6 py-20">
        <h2 className="text-[#82B1FF] text-xl font-bold mb-4 uppercase tracking-wide">Account Settings</h2>
        <div className="h-[1px] bg-gray-200 w-full mb-16"></div>

        {!isLoggedIn ? (
          <div className="text-center py-24 bg-white rounded-[40px] shadow-lg border border-gray-100">
            <div className="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <User size={40} className="text-gray-400" />
            </div>
            <h1 className="text-4xl font-bold mb-4 text-gray-900">Guest User</h1>
            <button onClick={onToggleLogin} className="bg-[#82B1FF] text-white px-12 py-4 rounded-full font-bold text-xl hover:bg-[#6fa5ff] transition shadow-lg shadow-blue-200">
              Login / Sign up
            </button>
          </div>
        ) : (
          <div className="flex flex-col lg:flex-row gap-20">
            <div className="lg:w-1/3">
              <div className="w-32 h-32 bg-gray-200 rounded-full mb-6 overflow-hidden mx-auto lg:mx-0 shadow-inner">
                <img src="https://i.pravatar.cc/300" alt="Avatar" className="w-full h-full object-cover" />
              </div>
              <h1 className="text-5xl font-bold text-black mb-2 text-center lg:text-left">Riyo Sumedang</h1>
              <p className="text-xl text-gray-500 mb-2 font-light text-center lg:text-left">riyookkkkkk@gmail.com</p>
              <div className="bg-green-100 text-green-700 px-4 py-1 rounded-full text-sm font-bold w-fit mx-auto lg:mx-0 mt-4">Verified Member</div>
            </div>

            <div className="lg:w-2/3 flex flex-col gap-6">
              <ProfileButton icon={<Edit size={24} />} text="Edit Profile Name" sub="Change your display name" />
              <ProfileButton icon={<Lock size={24} />} text="Change Password" sub="Update your security credentials" />
              <ProfileButton icon={<MessageCircle size={24} />} text="Support" sub="Get help with your bookings" />
              
              <div className="h-4"></div>
              
              <button onClick={onToggleLogin} className="bg-[#EF685B] text-white rounded-2xl py-5 px-8 flex items-center justify-center gap-3 hover:bg-opacity-90 transition shadow-lg shadow-red-100 transform hover:-translate-y-1 w-full lg:w-fit">
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