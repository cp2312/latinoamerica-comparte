// backend/scripts/resetAdminPais.js
// Ejecutar: node scripts/resetAdminPais.js
require('dotenv').config();

const mongoose = require('mongoose');
const bcrypt   = require('bcrypt');
const User     = require('../src/models/User');

const reset = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ Mongo conectado');

    // Ver el usuario actual
    const usuario = await User.findOne({ correo: 'adminpais@test.com' });

    if (!usuario) {
      console.log('❌ Usuario adminpais@test.com NO existe en la base de datos');
      process.exit(1);
    }

    console.log('📋 Usuario encontrado:');
    console.log('   nombre:', usuario.nombre);
    console.log('   correo:', usuario.correo);
    console.log('   rol:   ', usuario.rol);
    console.log('   pais:  ', usuario.pais);
    console.log('   pass hash:', usuario.password?.substring(0, 20) + '...');

    // Resetear contraseña a 123456
    const nuevaPass = await bcrypt.hash('123456', 10);
    await User.updateOne(
      { correo: 'adminpais@test.com' },
      {
        $set: {
          password: nuevaPass,
          rol:      'admin_pais',
          pais:     'Chile',
        }
      }
    );

    console.log('\n✅ Contraseña reseteada a: 123456');
    console.log('✅ rol actualizado a: admin_pais');
    console.log('✅ pais actualizado a: Colombia');
    process.exit();

  } catch (e) {
    console.error('❌ Error:', e.message);
    process.exit(1);
  }
};

reset();