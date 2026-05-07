require('dotenv').config();

const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const User = require('../src/models/User');

const createAdmin = async () => {

  try {

    await mongoose.connect(process.env.MONGO_URI);

    console.log('Mongo conectado');

    const hashedPassword = await bcrypt.hash('123456', 10);

    console.log(hashedPassword);

    const user = new User({
      nombre: 'Super Admin',
      correo: 'admin@test.com',
      password: hashedPassword,
      rol: 'superadmin',
      pais: null
    });

    await user.save();

    console.log('Usuario creado');

    process.exit();

  } catch (error) {

    console.log(error);

    process.exit(1);

  }

};

createAdmin();