import mongoose from 'mongoose';

const connectDB = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.MONGO_URI as string);
    console.log('MongoDB conectado');
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

export default connectDB;