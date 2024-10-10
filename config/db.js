// config/db.js
const { Pool } = require('pg');

// Configura la conexión con tu base de datos
const pool = new Pool({
    user: 'admin',        // Reemplaza con tu usuario de PostgreSQL
    host: 'localhost',
    database: 'sistemautos', // Reemplaza con el nombre de tu base de datos
    password: '123456',  // Reemplaza con tu contraseña
    port: 5432,                 // El puerto por defecto de PostgreSQL
});

module.exports = pool;
