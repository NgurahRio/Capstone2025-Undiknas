const mysql = require('mysql2');

// Gunakan createPool, BUKAN createConnection
const db = mysql.createPool({
  host: 'localhost',
  user: 'root',      
  password: '',      
  database: 'db_wisatabaruu',
  waitForConnections: true,
  connectionLimit: 10, // Maksimal 10 koneksi sekaligus
  queueLimit: 0
});

// Cek koneksi saat pertama kali jalan (Opsional, hanya untuk debug)
db.getConnection((err, connection) => {
  if (err) {
    console.error('Database connection failed:', err.message);
  } else {
    console.log('Connected to MySQL Database via Pool');
    connection.release(); // Kembalikan koneksi ke pool
  }
});

module.exports = db;