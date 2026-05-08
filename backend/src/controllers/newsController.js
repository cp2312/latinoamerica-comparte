const News = require('../models/News');

const createNews = async (req, res) => {
  try {
    const {
      titulo,
      contenido,
      imagen,
      pais,
      estado
    } = req.body;

    const news = new News({
      titulo,
      contenido,
   imagen: req.file
  ? `/uploads/${req.file.filename}`
  : null,
      pais,
      estado,
      autor: req.user.id
    });

    await news.save();

    res.status(201).json({
      message: 'Noticia creada',
      news
    });

  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

const getAllNews = async (req, res) => {
  try {
    const news = await News.find()
      .populate('autor', 'nombre correo rol');

    res.json(news);

  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};
const updateNews = async (req, res) => {
  try {
    const { id } = req.params;

    const updatedNews = await News.findByIdAndUpdate(
      id,
      req.body,
      {
        new: true
      }
    );

    if (!updatedNews) {
      return res.status(404).json({
        message: 'Noticia no encontrada'
      });
    }

    res.json({
      message: 'Noticia actualizada',
      updatedNews
    });

  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

const deleteNews = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedNews = await News.findByIdAndDelete(id);

    if (!deletedNews) {
      return res.status(404).json({
        message: 'Noticia no encontrada'
      });
    }

    res.json({
      message: 'Noticia eliminada'
    });

  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};
module.exports = {
  createNews,
  getAllNews,
  updateNews,
  deleteNews
};