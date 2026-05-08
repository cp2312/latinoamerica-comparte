const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/authRoutes');
const authMiddleware = require('./middlewares/authMiddleware');
const roleMiddleware = require('./middlewares/roleMiddleware');
const newsRoutes = require('./routes/newsRoutes');
const path = require('path');

const app = express();

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(
  path.join(__dirname, '../uploads')
));

app.get('/', (req, res) => {
  res.send('API funcionando');
});

app.use('/auth', authRoutes);
app.use('/news', newsRoutes);

app.get('/private', authMiddleware, (req, res) => {
  res.json({
    message: 'Ruta privada autorizada',
    user: req.user
  });
});
app.get(
  '/superadmin',
  authMiddleware,
  roleMiddleware('superadmin'),
  (req, res) => {
    res.json({
      message: 'Bienvenido Super Admin'
    });
  }
);

app.get(
  '/admin-pais',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais'),
  (req, res) => {
    res.json({
      message: 'Bienvenido Admin País'
    });
  }
);

app.get(
  '/editor',
  authMiddleware,
  roleMiddleware('superadmin', 'admin_pais', 'editor'),
  (req, res) => {
    res.json({
      message: 'Bienvenido Editor'
    });
  }
);

module.exports = app;