import axios from 'axios';

// Arahkan ke Port 8080 (Go Backend)
export const api = axios.create({
  baseURL: 'http://localhost:8080', 
});

// INTERCEPTOR: Setiap kali kirim request, tempelkan Token dari LocalStorage
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('travora_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
}, (error) => {
  return Promise.reject(error);
});

export default api;