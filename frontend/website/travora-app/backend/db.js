// backend/db.js
const mysql = require('mysql2/promise'); // PERUBAHAN DISINI (tambah /promise)

const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'db_wisatabaruu',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Cek koneksi
(async () => {
    try {
        const connection = await db.getConnection();
        console.log('✅ Terhubung ke Database MySQL (Mode Promise)');
        connection.release();
    } catch (err) {
        console.error('❌ Gagal koneksi database:', err.message);
    }
})();

module.exports = db;