// @ts-nocheck
const username = "admin'; DROP TABLE Users; --";
const queryString = `SELECT * FROM Users WHERE username='${username}'`;

// XSS

const userInput = '<script>alert("XSS");</script>';
const html = `<div>${userInput}</div>`;

// CSRF

app.post('/change-password', (req, res) => {
  const newPassword = req.body.newPassword;
  // Cambiar la contraseña sin verificar el token CSRF
});

// Deserialización

const data = JSON.parse(req.body);

// Credenciales

const dbPassword = 'password123';
// const apiSecretKey = 'supersecretkey123'; // No usar en producción
const config = {
  dbUsername: 'admin',
  dbPassword: 'password123',
  apiKey: 'abc123',
};

const hashedPassword = hash('password123');

console.log(`Error: La contraseña ${dbPassword} no es válida`);

export {};