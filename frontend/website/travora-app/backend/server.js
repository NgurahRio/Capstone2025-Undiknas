// backend/server.js
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs'); 
const db = require('./db'); // Pastikan db.js menggunakan mysql2/promise

const app = express();

// Konfigurasi CORS agar Frontend bisa akses
app.use(cors());
app.use(express.json());

// ==========================================
// HELPER FUNCTION (PEMROSES GAMBAR)
// ==========================================
// Fungsi ini mengubah data gambar dari Database (JSON String/BLOB) menjadi URL Base64 yang bisa dibaca React
const processDestinationImages = (imagedata) => {
    let images = ['https://via.placeholder.com/800x600?text=No+Image']; // Default
    try {
        if (imagedata) {
            // Cek apakah data sudah berbentuk Buffer (BLOB)
            if (Buffer.isBuffer(imagedata)) {
                imagedata = imagedata.toString(); // Ubah ke string dulu jika perlu
            }

            const parsed = JSON.parse(imagedata);
            if (Array.isArray(parsed) && parsed.length > 0) {
                // Tambahkan prefix data URI jika belum ada
                images = parsed.map(img => img.startsWith('data:') ? img : `data:image/jpeg;base64,${img}`);
            } else if (typeof parsed === 'string') {
                images = [parsed.startsWith('data:') ? parsed : `data:image/jpeg;base64,${parsed}`];
            }
        }
    } catch (e) {
        // Jika gagal parse JSON, mungkin formatnya lain, kita abaikan atau log error kecil
        // console.log("Image parse warning:", e.message);
    }
    return images;
};


// ==========================================
// 1. PUBLIC ROUTES (WISATA)
// ==========================================

// GET Semua Destinasi (Untuk Home Page)
app.get('/api/destinations', async (req, res) => {
    try {
        const [rows] = await db.query("SELECT id_destination, namedestination, location, imagedata FROM destination");
        
        const processedData = rows.map(item => {
            const images = processDestinationImages(item.imagedata);
            return {
                id: item.id_destination, // Mapping ID biar standar di frontend
                title: item.namedestination,
                location: item.location,
                img: images[0] // Ambil gambar pertama saja untuk thumbnail
            };
        });

        res.json(processedData);
    } catch (err) {
        console.error("Error Get Destinations:", err);
        res.status(500).json({ error: "Gagal mengambil data wisata" });
    }
});

// GET Detail Destinasi (Untuk Halaman Detail)
app.get('/api/destinations/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const [rows] = await db.query("SELECT * FROM destination WHERE id_destination = ?", [id]);
        
        if (rows.length === 0) return res.status(404).json({ message: "Wisata tidak ditemukan" });

        const item = rows[0];
        const images = processDestinationImages(item.imagedata);

        res.json({
            id: item.id_destination,
            title: item.namedestination,
            location: item.location,
            description: item.description,
            price: item.price_budget,
            images: images, // Kirim array gambar lengkap untuk slider
            rating: 4.8 // Dummy rating
        });
    } catch (err) {
        console.error("Error Get Detail:", err);
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
        // Cek username duplikat
        const [existingUser] = await db.query("SELECT * FROM users WHERE username = ?", [username]);
        if (existingUser.length > 0) {
            return res.status(409).json({ status: "Failed", message: "Username sudah terpakai!" });
        }

        // Hash Password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Insert ke DB
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
        
        // Cek Password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ status: "Failed", message: "Password salah!" });
        }

        // Siapkan data user untuk dikirim ke frontend (Hapus password)
        const { password: _, ...userData } = user;
        
        // Handle Gambar Profil User (BLOB to Base64)
        if (userData.image) {
             try {
                const base64 = Buffer.from(userData.image).toString('base64');
                userData.image = `data:image/jpeg;base64,${base64}`;
             } catch (e) {
                userData.image = null; // Fallback jika error konversi
             }
        }

        // Debugging: Pastikan ID terkirim
        // console.log("User Login Success:", userData);

        res.json({ status: "Success", user: userData });

    } catch (err) {
        console.error("Login Error:", err);
        res.status(500).json({ status: "Error", message: "Terjadi kesalahan server saat login" });
    }
});


// ==========================================
// 3. BOOKMARK ROUTES
// ==========================================

// GET: Ambil semua bookmark milik User tertentu
app.get('/api/bookmarks/:userId', async (req, res) => {
    const userId = req.params.userId;
    try {
        // Query JOIN untuk mendapatkan detail wisata dari ID Bookmark
        const query = `
            SELECT b.id_bookmark, d.id_destination, d.namedestination, d.location, d.imagedata 
            FROM bookmark b
            JOIN destination d ON b.destinationId = d.id_destination
            WHERE b.userId = ?
        `;
        
        const [rows] = await db.query(query, [userId]);

        const processedData = rows.map(item => {
            const images = processDestinationImages(item.imagedata);
            return {
                id: item.id_destination,
                title: item.namedestination,
                location: item.location,
                img: images[0]
            };
        });

        res.json(processedData);
    } catch (err) {
        console.error("Bookmark Error:", err);
        res.status(500).json({ error: "Gagal mengambil data bookmark" });
    }
});

// POST: Tambah/Hapus Bookmark (Toggle)
app.post('/api/bookmarks/toggle', async (req, res) => {
    const { userId, destinationId } = req.body;

    try {
        // Cek duplikat
        const [exists] = await db.query(
            "SELECT * FROM bookmark WHERE userId = ? AND destinationId = ?", 
            [userId, destinationId]
        );

        if (exists.length > 0) {
            // UNBOOKMARK (Hapus)
            await db.query(
                "DELETE FROM bookmark WHERE userId = ? AND destinationId = ?", 
                [userId, destinationId]
            );
            return res.json({ status: "Removed", message: "Dihapus dari bookmark" });
        } else {
            // BOOKMARK (Tambah)
            await db.query(
                "INSERT INTO bookmark (userId, destinationId) VALUES (?, ?)", 
                [userId, destinationId]
            );
            return res.json({ status: "Added", message: "Disimpan ke bookmark" });
        }
    } catch (err) {
        console.error("Toggle Bookmark Error:", err);
        res.status(500).json({ error: "Gagal memproses bookmark" });
    }
});

// GET: Cek Status Bookmark (Untuk pewarnaan tombol Love)
app.get('/api/bookmarks/check/:userId/:destId', async (req, res) => {
    const { userId, destId } = req.params;
    try {
        const [rows] = await db.query(
            "SELECT * FROM bookmark WHERE userId = ? AND destinationId = ?", 
            [userId, destId]
        );
        res.json({ isBookmarked: rows.length > 0 });
    } catch (err) {
        console.error("Check Status Error:", err);
        res.status(500).json({ error: "Error checking status" });
    }
});

// Start Server
app.listen(3000, () => {
    console.log("🚀 Server Travora berjalan di port 3000");
});