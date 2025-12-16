// backend/server.js
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs'); 
const db = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// ==========================================
// 1. PUBLIC ROUTES (WISATA)
// ==========================================

// GET Semua Destinasi (Home)
app.get('/api/destinations', async (req, res) => {
    try {
        // Perhatikan syntax: const [rows] = await ...
        const [rows] = await db.query("SELECT id_destination, namedestination, location, imagedata FROM destination");
        
        const processedData = rows.map(item => {
            let imageSrc = 'https://via.placeholder.com/300';
            try {
                if (item.imagedata) {
                    const parsed = JSON.parse(item.imagedata);
                    if (Array.isArray(parsed) && parsed.length > 0) {
                        imageSrc = `data:image/jpeg;base64,${parsed[0]}`;
                    }
                }
            } catch (e) {}

            return {
                id: item.id_destination,
                title: item.namedestination,
                location: item.location,
                img: imageSrc
            };
        });

        res.json(processedData);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Gagal mengambil data wisata" });
    }
});

// GET Detail Destinasi
app.get('/api/destinations/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const [rows] = await db.query("SELECT * FROM destination WHERE id_destination = ?", [id]);
        
        if (rows.length === 0) return res.status(404).json({ message: "Wisata tidak ditemukan" });

        const item = rows[0];
        let imageList = [];

        try {
            if (item.imagedata) {
                const parsed = JSON.parse(item.imagedata);
                if (Array.isArray(parsed)) {
                    imageList = parsed.map(img => `data:image/jpeg;base64,${img}`);
                } else {
                     imageList = [`data:image/jpeg;base64,${parsed}`];
                }
            }
        } catch (e) {
            imageList = ['https://via.placeholder.com/800x600?text=No+Image'];
        }

        if(imageList.length === 0) imageList = ['https://via.placeholder.com/800x600?text=No+Image'];

        res.json({
            id: item.id_destination,
            title: item.namedestination,
            location: item.location,
            description: item.description,
            price: item.price_budget,
            images: imageList,
            rating: 4.8 
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Gagal mengambil detail wisata" });
    }
});

// ==========================================
// 2. AUTHENTICATION ROUTES (LOGIN/REGISTER)
// ==========================================

// REGISTER
app.post('/api/register', async (req, res) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({ status: "Failed", message: "Semua kolom harus diisi!" });
    }

    try {
        // Cek username sudah ada atau belum
        const [existingUser] = await db.query("SELECT * FROM users WHERE username = ?", [username]);
        
        if (existingUser.length > 0) {
            return res.status(409).json({ status: "Failed", message: "Username sudah terpakai!" });
        }

        // Hash Password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Simpan ke DB (roleId default 2 untuk User)
        await db.query(
            "INSERT INTO users (username, email, password, roleId) VALUES (?, ?, ?, 2)", 
            [username, email, hashedPassword]
        );

        res.json({ status: "Success", message: "Registrasi berhasil! Silakan login." });

    } catch (err) {
        console.error("Register Error:", err);
        res.status(500).json({ status: "Error", message: "Terjadi kesalahan server saat registrasi" });
    }
});

// LOGIN
app.post('/api/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const [users] = await db.query("SELECT * FROM users WHERE username = ?", [username]);
        
        if (users.length === 0) {
            return res.status(404).json({ status: "Failed", message: "User tidak ditemukan!" });
        }

        const user = users[0];
        
        // Cek Password Hash
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(401).json({ status: "Failed", message: "Password salah!" });
        }

        // Kirim data user (kecuali password)
        const { password: _, ...userData } = user;
        
        // Handle gambar profil user jika ada BLOB
        if (userData.image) {
             // Konversi BLOB ke Base64 string agar bisa tampil di frontend
             userData.image = `data:image/jpeg;base64,${userData.image.toString('base64')}`;
        }

        res.json({ status: "Success", user: userData });

    } catch (err) {
        console.error("Login Error:", err);
        res.status(500).json({ status: "Error", message: "Terjadi kesalahan server saat login" });
    }
});

app.listen(3000, () => {
    console.log("🚀 Server berjalan di port 3000");
});