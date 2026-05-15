import multer, { FileFilterCallback } from 'multer';
import path from 'path';
import { Request } from 'express';

const storage = multer.diskStorage({
  destination: (_req: Request, _file: Express.Multer.File, cb) => {
    cb(null, 'uploads/');
  },
  filename: (_req: Request, file: Express.Multer.File, cb) => {
    const uniqueName = Date.now() + path.extname(file.originalname);
    cb(null, uniqueName);
  }
});

const fileFilter = (
  _req: Request,
  file: Express.Multer.File,
  cb: FileFilterCallback
) => {
  const allowedTypes = /jpg|jpeg|png|webp/;
  const isValid = allowedTypes.test(
    path.extname(file.originalname).toLowerCase()
  );

  if (isValid) {
    cb(null, true);
  } else {
    cb(new Error('Solo imágenes permitidas'));
  }
};

const upload = multer({ storage, fileFilter });

export default upload;