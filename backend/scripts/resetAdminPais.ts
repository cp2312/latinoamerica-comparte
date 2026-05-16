import 'dotenv/config';
import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import User, { IUser } from '../src/models/User';

const reset = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.MONGO_URI as string);
    console.log('✅ Mongo conectado');

    const usuario = await User.findOne({ correo: 'adminpais@test.com' }) as IUser | null;

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

    const nuevaPass = await bcrypt.hash('123456', 10);
    await User.updateOne(
      { correo: 'adminpais@test.com' },
      {
        $set: {
          password: nuevaPass,
          rol: 'admin_pais',
          pais: 'Chile'
        }
      }
    );

    console.log('\n✅ Contraseña reseteada a: 123456');
    console.log('✅ rol actualizado a: admin_pais');
    console.log('✅ pais actualizado a: Colombia');
    process.exit();

  } catch (e) {
    console.error('❌ Error:', (e as Error).message);
    process.exit(1);
  }
};

reset();