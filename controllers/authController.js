// controllers/authController.js
const pool = require('../config/db');
const bcrypt = require('bcryptjs');

exports.register = async (req, res) => {
    const { username, email, password } = req.body;

    // Verifica los datos recibidos
    console.log("Datos recibidos:", { username, email, password });

    try {
        // Validar que los datos no sean undefined
        if (!username || !email || !password) {
            return res.status(400).json({ message: 'Todos los campos son obligatorios.' });
        }

        // Hashear la contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insertar usuario en la base de datos
        const result = await pool.query(
            'INSERT INTO users (username, email, password) VALUES ($1, $2, $3) RETURNING *',
            [username, email, hashedPassword]
        );

        const newUser = result.rows[0]; // Obtener el nuevo usuario
        res.status(201).json({ id: newUser.id, username: newUser.username });
    } catch (error) {
        console.error('Error al crear usuario:', error); // Imprime el error en la consola

        if (error.code === '23505') { // Código de error para violación de restricción única
            return res.status(409).json({ message: 'El nombre de usuario o el correo ya están en uso.' });
        }
        res.status(500).json({ message: 'Error al crear usuario', error: error.message });
    }
};
