import 'dotenv/config';
import mongoose from 'mongoose';
import bcrypt from 'bcrypt';
import User from '../src/models/User';

const createAdmin = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.MONGO_URI as string);
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
    console.error(error);
    process.exit(1);
  }
};

createAdmin();