const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Configuración de la conexión a la base de datos MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Tu usuario de MySQL
  password: process.env.DB_PASSWORD, // Contraseña guardada en una variable de entorno
  database: 'snake_meta', // Nombre de tu base de datos
});

db.connect((err) => {
  if (err) {
    console.error('Error al conectar con la base de datos:', err.message);
    process.exit(1);
  }
  console.log('MySQL Connected...');
});

// Ruta para registrar un nuevo usuario
app.post('/signup', (req, res) => {
  const { usrName, usrEmail, usrPassword, usrDob } = req.body;

  // Validación de los datos del usuario
  if (!usrName || !usrEmail || !usrPassword || !usrDob) {
    return res.status(400).send({ message: 'Todos los campos son obligatorios' });
  }

  // Validación del formato del correo electrónico
  if (!validateEmail(usrEmail)) {
    return res.status(400).send({ message: 'Formato de correo electrónico inválido' });
  }

  const user = { usrName, usrEmail, usrPassword, usrDob };
  const sql = 'INSERT INTO users SET ?';

  // Consulta preparada para evitar inyección SQL
  db.query(sql, user, (err, result) => {
    if (err) {
      console.error('Error al registrar usuario:', err.message);
      return res.status(500).send({ message: 'Error al registrar usuario' });
    }
    res.status(201).send({ message: 'Usuario registrado', userId: result.insertId });
  });
});

// Función para validar el formato del correo electrónico
function validateEmail(email) {
    const re = /\S+@\S+\.\S+/;
    return re.test(email);
}

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
