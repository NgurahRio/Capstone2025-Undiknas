// backend/server.js
const express = require('express');
const cors = require('cors');
const db = require('./db');
const app = express();

app.use(cors()); // Izinkan Frontend mengakses Backend
app.use(express.json());

// --- API ROUTES ---

// 1. GET Semua Destinasi (Untuk Home Page)

app.get('/api/destinations', async (req, res) => {
    // Pastikan nama kolom sesuai dengan tabel 'destination' di TRAVORA.sql
    const sql = "SELECT id_destination, namedestination, location, imagedata FROM destination";
    
    db.query(sql, (err, data) => {
        if (err) {
            console.error("Database Error:", err);
            return res.status(500).json({ error: "Database error" });
        }
        
        // Cek apakah data kosong
        if (!data || data.length === 0) return res.json([]);

        // Format ulang data agar aman untuk React
        const processedData = data.map(item => {
            let imageSrc = 'https://via.placeholder.com/300'; // Gambar default

            // Coba parsing imagedata (karena di DB Anda tersimpan sebagai string JSON '["..."]')
            try {
                if (item.imagedata) {
                    const parsedImages = JSON.parse(item.imagedata);
                    if (Array.isArray(parsedImages) && parsedImages.length > 0) {
                        // Ambil gambar pertama dan tambahkan header base64
                        imageSrc = `data:image/jpeg;base64,${parsedImages[0]}`;
                    }
                }
            } catch (e) {
                console.log("Gagal parse gambar untuk ID:", item.id_destination);
            }

            return {
                id: item.id_destination,
                title: item.namedestination, // Sesuai kolom DB
                location: item.location,     // Sesuai kolom DB
                img: imageSrc
            };
        });

        return res.json(processedData);
    });
});

// 2. GET Detail Destinasi (Untuk Halaman Detail)
app.get('/api/destinations/:id', (req, res) => {
    const id = req.params.id;
    const sql = "SELECT * FROM destination WHERE id_destination = ?";
    db.query(sql, [id], (err, data) => {
        if(err) return res.json({ error: err.message });
        if(data.length === 0) return res.status(404).json({ message: "Not Found" });
        return res.json(data[0]);
    });
});

// 3. Login User
app.post('/api/login', (req, res) => {
    const { username, password } = req.body;
    // Query sederhana (Perhatian: Password sebaiknya di-hash di production)
    const sql = "SELECT * FROM users WHERE username = ? AND password = ?"; 
    db.query(sql, [username, password], (err, data) => {
        if(err) return res.json({ error: "Error" });
        if(data.length > 0) {
            return res.json({ status: "Success", user: data[0] });
        } else {
            return res.json({ status: "Failed" });
        }
    });
});

app.listen(3000, () => {
  console.log("Server berjalan di port 3000...");
});