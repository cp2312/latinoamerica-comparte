// scripts/seedPaises.ts
// Crea los 4 países iniciales en la base de datos.
// Ejecutar UNA sola vez: npx ts-node scripts/seedPaises.ts

import 'dotenv/config';
import mongoose from 'mongoose';
import Pais from '../src/models/Pais';

const PAISES_INICIALES = ['Colombia', 'Chile', 'Ecuador', 'Argentina'];

const seed = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.MONGO_URI as string);
    console.log('✅ Mongo conectado');

    for (const nombre of PAISES_INICIALES) {
      const existe = await Pais.findOne({ nombre });
      if (existe) {
        console.log(`⚠️  "${nombre}" ya existe — omitido`);
        continue;
      }
      await Pais.create({ nombre, estado: 'activo' });
      console.log(`✅ País creado: ${nombre}`);
    }

    console.log('\n✅ Seed completado');
    process.exit();
  } catch (e) {
    console.error('❌ Error:', (e as Error).message);
    process.exit(1);
  }
};

seed();