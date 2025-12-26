import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../api';
import { Mail, Lock, User, ArrowRight, CheckCircle, AlertCircle } from 'lucide-react';
import Navbar from '../components/common/Navbar';

export default function Auth() {
  const navigate = useNavigate();
  const [isLogin, setIsLogin] = useState(true); 
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState(null); 

  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: ''
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setMessage(null);

    const endpoint = isLogin ? '/user/login' : '/user/register';

    // === PERBAIKAN PENTING DI SINI ===
    // Backend Go minta "identifier" saat login, bukan "username".
    let payload = {};

    if (isLogin) {
        payload = {
            identifier: formData.username, // Kita kirim username sebagai identifier
            password: formData.password
        };
    } else {
        // Kalau Register, biasanya tetap butuh field lengkap
        payload = {
            username: formData.username,
            email: formData.email,
            password: formData.password
        };
    }

    try {
      console.log(`Mengirim ke ${endpoint}...`, payload);

      const res = await api.post(endpoint, payload); // Kirim payload yang sudah disesuaikan

      console.log("Respon Server:", res.data);

      if (isLogin) {
        // Handle struktur respon Go: { data: { token: "...", user: {...} } }
        // Kita pakai optional chaining (?.) biar gak error kalau strukturnya beda dikit
        const token = res.data.token || res.data.data?.token;
        const userData = res.data.user || res.data.data?.user || { username: formData.username };

        if (token) {
            localStorage.setItem('travora_token', token);
            localStorage.setItem('travora_user', JSON.stringify(userData));
            
            setMessage({ type: 'success', text: 'Login Berhasil!' });
            setTimeout(() => {
                navigate('/profile'); 
            }, 1000);
        } else {
            throw new Error("Login berhasil tapi Token tidak diterima.");
        }

      } else {
        setMessage({ type: 'success', text: 'Akun berhasil dibuat! Silakan Login.' });
        setIsLogin(true); 
        setFormData({ username: '', email: '', password: '' });
      }

    } catch (err) {
      console.error("Error Auth:", err);
      // Ambil pesan error spesifik dari Go
      const errorMsg = err.response?.data?.error || err.response?.data?.message || "Gagal terhubung ke server.";
      setMessage({ type: 'error', text: errorMsg });
    } finally {
      setLoading(false);
    }
  };

  // --- TAMPILAN (Sama seperti sebelumnya) ---
  return (
    <div className="min-h-screen bg-[#FAFAFA] font-poppins">
      <Navbar /> 
      
      <div className="pt-24 min-h-screen flex items-center justify-center p-6">
        <div className="bg-white rounded-[40px] shadow-2xl overflow-hidden max-w-5xl w-full flex flex-col md:flex-row min-h-[600px]">
          
          {/* Form */}
          <div className="w-full md:w-1/2 p-10 md:p-16 flex flex-col justify-center">
            <div className="mb-8">
              <h1 className="text-4xl font-bold text-gray-900 mb-2">
                {isLogin ? 'Welcome Back!' : 'Create Account'}
              </h1>
              <p className="text-gray-500">
                {isLogin ? 'Please enter your details to sign in.' : 'Start your journey with Travora today.'}
              </p>
            </div>

            {message && (
              <div className={`p-4 rounded-xl mb-6 flex items-center gap-3 text-sm font-bold ${message.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                {message.type === 'success' ? <CheckCircle size={20}/> : <AlertCircle size={20}/>}
                {message.text}
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-5">
              
              <div className="space-y-2">
                <label className="text-sm font-bold text-gray-700 ml-1">Username</label>
                <div className="relative">
                    <User className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
                    <input 
                        type="text" 
                        name="username"
                        value={formData.username}
                        onChange={handleChange}
                        placeholder="johndoe" 
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:ring-2 focus:ring-[#82B1FF] transition"
                        required 
                    />
                </div>
              </div>

              {!isLogin && (
                  <div className="space-y-2 animate-fade-in">
                    <label className="text-sm font-bold text-gray-700 ml-1">Email Address</label>
                    <div className="relative">
                        <Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
                        <input 
                            type="email" 
                            name="email"
                            value={formData.email}
                            onChange={handleChange}
                            placeholder="name@example.com" 
                            className="w-full pl-12 pr-4 py-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:ring-2 focus:ring-[#82B1FF] transition"
                            required 
                        />
                    </div>
                  </div>
              )}

              <div className="space-y-2">
                <label className="text-sm font-bold text-gray-700 ml-1">Password</label>
                <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
                    <input 
                        type="password" 
                        name="password"
                        value={formData.password}
                        onChange={handleChange}
                        placeholder="••••••••" 
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border border-gray-200 rounded-2xl outline-none focus:ring-2 focus:ring-[#82B1FF] transition"
                        required 
                    />
                </div>
              </div>

              {isLogin && (
                  <div className="flex justify-end">
                      <a href="#" className="text-sm text-[#5E9BF5] font-bold hover:underline">Forgot Password?</a>
                  </div>
              )}

              <button 
                type="submit" 
                disabled={loading}
                className="w-full bg-[#5E9BF5] text-white font-bold py-4 rounded-2xl hover:bg-[#4a90e2] transition shadow-lg shadow-blue-200 flex items-center justify-center gap-2 disabled:opacity-70"
              >
                {loading ? 'Processing...' : (isLogin ? 'Sign In' : 'Sign Up')}
                {!loading && <ArrowRight size={20} />}
              </button>
            </form>

            <div className="mt-8 text-center">
              <p className="text-gray-500">
                {isLogin ? "Don't have an account?" : "Already have an account?"} 
                <button 
                    onClick={() => {
                        setIsLogin(!isLogin); 
                        setMessage(null); 
                        setFormData({username: '', email: '', password: ''});
                    }} 
                    className="text-[#5E9BF5] font-bold ml-2 hover:underline"
                >
                  {isLogin ? 'Sign Up' : 'Log In'}
                </button>
              </p>
            </div>
          </div>

          <div className="hidden md:block w-1/2 relative bg-blue-50">
             <img 
                src={isLogin 
                    ? "https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=1000" 
                    : "https://images.unsplash.com/photo-1555400038-63f5ba517a47?q=80&w=1000"
                } 
                className="absolute inset-0 w-full h-full object-cover transition-opacity duration-500"
                alt="Auth Banner"
             />
             <div className="absolute inset-0 bg-black/30 backdrop-blur-[2px]"></div>
             <div className="absolute bottom-16 left-12 right-12 text-white">
                <h2 className="text-4xl font-bold mb-4 leading-tight">
                    {isLogin ? "Ready to explore the beauty of Bali?" : "Join our community of travelers."}
                </h2>
                <p className="text-lg opacity-90 font-light">
                    {isLogin 
                        ? "Log in to access your saved destinations and personalized recommendations." 
                        : "Sign up now to bookmark places, write reviews, and plan your perfect trip."}
                </p>
             </div>
          </div>

        </div>
      </div>
    </div>
  );
}
