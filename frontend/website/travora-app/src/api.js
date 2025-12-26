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

// INTERCEPTOR RESPONSE:
// Redirect ke /auth hanya jika request membawa Authorization (artinya endpoint butuh login).
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error?.response?.status;
    const hadAuthHeader = !!error?.config?.headers?.Authorization;
    if (hadAuthHeader && (status === 401 || status === 403)) {
      localStorage.removeItem('travora_token');
      localStorage.removeItem('travora_user');
      if (typeof window !== 'undefined' && window.location.pathname !== '/auth') {
        window.location.href = '/auth';
      }
    }
    return Promise.reject(error);
  }
);

export default api;
