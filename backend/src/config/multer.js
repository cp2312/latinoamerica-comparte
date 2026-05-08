const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },

  filename: (req, file, cb) => {
    const uniqueName =
      Date.now() + path.extname(file.originalname);

    cb(null, uniqueName);
  }
});

const fileFilter = (req, file, cb) => {
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

const upload = multer({
  storage,
  fileFilter
});

module.exports = upload;