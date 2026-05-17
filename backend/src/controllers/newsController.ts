import { Request, Response } from 'express';
import News from '../models/News';
import { AuthRequest } from '../types';

// POST /news — crear noticia (requiere auth)
const createNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const {
      titulo,
      contenido,
      pais,
      estado,
    }: {
      titulo: string;
      contenido: string;
      pais?: string;
      estado?: string;
    } = req.body;

    const news = new News({
      titulo,
      contenido,
      imagen: req.file ? `/uploads/${req.file.filename}` : null,
      pais,
      estado,
      autor: authReq.user!.id,
    });

    await news.save();
    res.status(201).json({ message: 'Noticia creada', news });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /news — listar noticias con filtros opcionales por país y estado
// Ejemplos:
//   GET /news                          → todas las noticias (admin)
//   GET /news?estado=publicado         → solo publicadas
//   GET /news?pais=Chile               → solo de Chile
//   GET /news?estado=publicado&pais=Chile → publicadas de Chile
const getAllNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const filtro: Record<string, unknown> = {};

    if (req.query.estado) {
      filtro.estado = req.query.estado as string;
    }

    if (req.query.pais) {
      // Regex case-insensitive para que "chile", "Chile" o "CHILE" funcionen igual
      filtro.pais = {
        $regex: new RegExp(`^${req.query.pais as string}$`, 'i'),
      };
    }

    const news = await News.find(filtro)
      .populate('autor', 'nombre correo rol')
      .sort({ createdAt: -1 });

    res.json(news);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PUT /news/:id — actualizar noticia
const updateNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const {
      titulo,
      contenido,
      pais,
      estado,
    }: {
      titulo: string;
      contenido: string;
      pais?: string;
      estado?: string;
    } = req.body;

    const news = await News.findById(id);

    if (!news) {
      res.status(404).json({
        message: 'Noticia no encontrada',
      });
      return;
    }

    // conservar imagen actual
    let imagen = news.imagen;

    // solo reemplazar si llega nueva imagen
    if (req.file) {
      imagen = `/uploads/${req.file.filename}`;
    }

    news.titulo = titulo;
    news.contenido = contenido;
    news.pais = pais || null;
    news.estado = (estado as 'borrador' | 'publicado') || news.estado;
    news.imagen = imagen;

    await news.save();

    res.status(200).json({
      message: 'Noticia actualizada correctamente',
      news,
    });
  } catch (error) {
    res.status(500).json({
      message: (error as Error).message,
    });
  }
};
// DELETE /news/:id — eliminar noticia
const deleteNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const deletedNews = await News.findByIdAndDelete(id);

    if (!deletedNews) {
      res.status(404).json({ message: 'Noticia no encontrada' });
      return;
    }

    res.json({ message: 'Noticia eliminada' });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export { createNews, getAllNews, updateNews, deleteNews };