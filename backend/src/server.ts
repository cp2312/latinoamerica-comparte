import 'dotenv/config';
import app from './app';
import connectDB from './config/db';

connectDB();

const PORT: number = Number(process.env.PORT) || 3000;

app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});