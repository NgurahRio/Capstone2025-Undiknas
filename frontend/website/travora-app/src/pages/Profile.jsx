import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  LogOut,
  ChevronRight,
  Mail,
  UploadCloud,
  AlertCircle,
  CheckCircle2,
  X,
  Edit,
  Lock,
} from 'lucide-react';
import api from '../api';

export default function Profile() {
  const navigate = useNavigate();

  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const [savingProfile, setSavingProfile] = useState(false);
  const [savingPassword, setSavingPassword] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const [username, setUsername] = useState('');
  const [imageFile, setImageFile] = useState(null);

  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const [showEditModal, setShowEditModal] = useState(false);
  const [showPasswordModal, setShowPasswordModal] = useState(false);

  const previewUrl = useMemo(() => {
    if (imageFile) return URL.createObjectURL(imageFile);
    if (user?.image) return `data:image/jpeg;base64,${user.image}`;
    if (user?.username) return `https://ui-avatars.com/api/?name=${user.username}&background=5E9BF5&color=fff`;
    return '';
  }, [imageFile, user]);

  useEffect(() => {
    const token = localStorage.getItem('travora_token');
    if (!token) {
      navigate('/auth');
      return;
    }

    const fetchProfile = async () => {
      try {
        setLoading(true);
        const res = await api.get('/user/profile');
        const profile = res.data?.user || {};
        setUser(profile);
        setUsername(profile.username || '');
        localStorage.setItem('travora_user', JSON.stringify(profile));
      } catch (err) {
        console.error(err);
        navigate('/auth');
      } finally {
        setLoading(false);
      }
    };

    fetchProfile();
  }, [navigate]);

  const handleLogout = () => {
    localStorage.removeItem('travora_user');
    localStorage.removeItem('travora_token');
    navigate('/auth');
  };

  const handleImageChange = (e) => {
    const file = e.target.files?.[0];
    if (file) setImageFile(file);
  };

  const submitEditProfile = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!username.trim()) {
      setError('Username tidak boleh kosong.');
      return;
    }

    const formData = new FormData();
    formData.append('username', username.trim());
    if (imageFile) formData.append('image', imageFile);

    try {
      setSavingProfile(true);
      const res = await api.put('/user/profile', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      const updatedUser = res.data?.user;
      if (updatedUser) {
        setUser(updatedUser);
        localStorage.setItem('travora_user', JSON.stringify(updatedUser));
        setSuccess('Profil berhasil diperbarui.');
        setShowEditModal(false);
        setImageFile(null);
      }
    } catch (err) {
      console.error(err);
      const msg = err.response?.data?.error || 'Gagal memperbarui profil.';
      setError(msg);
    } finally {
      setSavingProfile(false);
    }
  };

  const submitChangePassword = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!oldPassword || !newPassword || !confirmPassword) {
      setError('Lengkapi semua field password.');
      return;
    }
    if (newPassword !== confirmPassword) {
      setError('Konfirmasi password tidak sama.');
      return;
    }

    const formData = new FormData();
    formData.append('old_password', oldPassword);
    formData.append('password', newPassword);

    try {
      setSavingPassword(true);
      const res = await api.put('/user/profile', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      const updatedUser = res.data?.user;
      if (updatedUser) {
        setUser(updatedUser);
        localStorage.setItem('travora_user', JSON.stringify(updatedUser));
        setSuccess('Password berhasil diperbarui.');
        setShowPasswordModal(false);
        setOldPassword('');
        setNewPassword('');
        setConfirmPassword('');
      }
    } catch (err) {
      console.error(err);
      const msg = err.response?.data?.error || 'Gagal memperbarui password.';
      setError(msg);
    } finally {
      setSavingPassword(false);
    }
  };

  if (loading) {
    return (
      <div className="w-full min-h-screen flex items-center justify-center text-gray-400">
        Memuat profil...
      </div>
    );
  }

  if (!user) return null;

  return (
    <div className="w-full animate-fade-in pb-20">
      {/* Hero Header */}
      <div className="h-[350px] relative w-full">
        <img
          src="https://images.unsplash.com/photo-1577717903315-1691ae25ab3f"
          className="w-full h-full object-cover brightness-50"
          alt="Profile Hero"
        />
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
              {previewUrl ? (
                <img src={previewUrl} alt="Avatar" className="w-full h-full object-cover" />
              ) : (
                <div className="w-full h-full flex items-center justify-center text-gray-400">No Image</div>
              )}
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

          {/* Kolom Kanan: Actions */}
          <div className="lg:w-2/3 flex flex-col gap-6">
            <h3 className="text-xl font-bold text-gray-900 mb-2">Account Settings</h3>

            {error && (
              <div className="flex items-center gap-2 bg-red-50 text-red-700 border border-red-100 px-4 py-3 rounded-xl">
                <AlertCircle size={18} />
                <span className="text-sm font-medium">{error}</span>
              </div>
            )}

            {success && (
              <div className="flex items-center gap-2 bg-green-50 text-green-700 border border-green-100 px-4 py-3 rounded-xl">
                <CheckCircle2 size={18} />
                <span className="text-sm font-medium">{success}</span>
              </div>
            )}

            <ProfileButton
              icon={<Edit size={24} />}
              title="Edit Profile"
              subtitle="Change display name or photo"
              onClick={() => setShowEditModal(true)}
            />

            <ProfileButton
              icon={<Lock size={24} />}
              title="Change Password"
              subtitle="Update account security"
              onClick={() => setShowPasswordModal(true)}
            />


            <div className="flex justify-end">
              <button
                onClick={handleLogout}
                className="bg-red-50 border border-red-100 text-red-600 rounded-lg py-2.5 px-5 flex items-center gap-2 hover:bg-red-100 transition shadow-sm text-sm font-bold"
              >
                <LogOut size={18} />
                <span>Log Out</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {showEditModal && (
        <Modal onClose={() => setShowEditModal(false)} title="Edit Profile">
          <form onSubmit={submitEditProfile} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-gray-700">New name</label>
              <input
                className="border border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[#5E9BF5]"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Username"
              />
            </div>

            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-gray-700">Foto Profil</label>
              <div className="flex items-center gap-3">
                <label className="cursor-pointer flex items-center gap-2 px-4 py-2 border border-dashed border-gray-300 rounded-xl hover:border-[#5E9BF5] text-sm font-semibold text-gray-600">
                  <UploadCloud size={16} />
                  <span>Pilih foto</span>
                  <input type="file" accept="image/*" className="hidden" onChange={handleImageChange} />
                </label>
                {imageFile && <span className="text-xs text-gray-500">{imageFile.name}</span>}
              </div>
            </div>

            <button
              type="submit"
              disabled={savingProfile}
              className="mt-2 bg-[#5E9BF5] text-white rounded-2xl py-3 px-6 font-bold flex items-center justify-center gap-2 hover:bg-[#4a8be6] transition disabled:opacity-60"
            >
              {savingProfile ? 'Menyimpan...' : 'Simpan Perubahan'}
            </button>
          </form>
        </Modal>
      )}

      {showPasswordModal && (
        <Modal onClose={() => setShowPasswordModal(false)} title="Change Password">
          <form onSubmit={submitChangePassword} className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-gray-700">Password Lama</label>
              <input
                type="password"
                className="border border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[#5E9BF5]"
                value={oldPassword}
                onChange={(e) => setOldPassword(e.target.value)}
                placeholder="Isi untuk ganti password"
              />
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-gray-700">Password Baru</label>
              <input
                type="password"
                className="border border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[#5E9BF5]"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                placeholder="Password baru"
              />
            </div>
            <div className="flex flex-col gap-2">
              <label className="text-sm font-semibold text-gray-700">Konfirmasi Password Baru</label>
              <input
                type="password"
                className="border border-gray-200 rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-[#5E9BF5]"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="Ulangi password baru"
              />
            </div>

            <button
              type="submit"
              disabled={savingPassword}
              className="mt-2 bg-[#5E9BF5] text-white rounded-2xl py-3 px-6 font-bold flex items-center justify-center gap-2 hover:bg-[#4a8be6] transition disabled:opacity-60"
            >
              {savingPassword ? 'Menyimpan...' : 'Simpan Password'}
            </button>
          </form>
        </Modal>
      )}
    </div>
  );
}

const ProfileButton = ({ icon, title, subtitle, onClick }) => (
  <button
    onClick={onClick}
    className="bg-white border border-gray-100 shadow-sm rounded-2xl py-6 px-8 flex items-center text-left hover:shadow-xl transition w-full transform hover:-translate-y-1 group"
  >
    <span className="text-gray-400 mr-6 group-hover:text-[#5E9BF5] transition">{icon}</span>
    <div>
      <span className="font-bold text-lg text-gray-900 block">{title}</span>
      <span className="text-sm text-gray-400 font-light">{subtitle}</span>
    </div>
    <div className="ml-auto text-gray-300">
      <ChevronRight className="group-hover:translate-x-1 transition" />
    </div>
  </button>
);

const Modal = ({ children, onClose, title }) => (
  <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
    <div className="bg-white rounded-2xl shadow-xl max-w-lg w-full p-6 relative">
      <button
        onClick={onClose}
        className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
        aria-label="Close"
      >
        <X size={18} />
      </button>
      <h4 className="text-xl font-bold text-gray-900 mb-4">{title}</h4>
      {children}
    </div>
  </div>
);
