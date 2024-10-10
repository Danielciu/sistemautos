// server.js
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path'); // Importar path para manejar rutas de archivos
const authRoutes = require('./routes/authRoutes');

const app = express();

// Middleware para parsear JSON
app.use(bodyParser.json());

// Servir archivos estáticos desde la carpeta 'public'
app.use(express.static(path.join(__dirname, 'public')));

// Rutas
app.use('/', authRoutes);

// Ruta para mostrar el formulario de registro
app.get('/register', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'register.html'));
});

// Iniciar el servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
