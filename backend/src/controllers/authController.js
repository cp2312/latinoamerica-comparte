const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const login = async (req, res) => {
  try {
    const { correo, password } = req.body;

    const user = await User.findOne({ correo });
    console.log(user);

    if (!user) {
      return res.status(401).json({
        message: 'Credenciales incorrectas'
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);

console.log(isMatch);

    if (!isMatch) {
      return res.status(401).json({
        message: 'Credenciales incorrectas'
      });
    }

    const token = jwt.sign(
      {
        id: user._id,
        rol: user.rol,
        pais: user.pais
      },
      process.env.JWT_SECRET,
      {
        expiresIn: '1d'
      }
    );

    res.json({
      token,
      user: {
        nombre: user.nombre,
        correo: user.correo,
        rol: user.rol,
        pais: user.pais
      }
    });

  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

module.exports = {
  login
};