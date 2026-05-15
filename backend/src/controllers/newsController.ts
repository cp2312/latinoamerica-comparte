import { Request, Response } from 'express';
import News from '../models/News';
import { AuthRequest } from '../types';

const createNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const {
      titulo,
      contenido,
      pais,
      estado
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
      autor: authReq.user!.id
    });

    await news.save();

    res.status(201).json({ message: 'Noticia creada', news });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

const getAllNews = async (_req: Request, res: Response): Promise<void> => {
  try {
    const news = await News.find().populate('autor', 'nombre correo rol');
    res.json(news);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

const updateNews = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const updatedNews = await News.findByIdAndUpdate(id, req.body, {
      new: true
    });

    if (!updatedNews) {
      res.status(404).json({ message: 'Noticia no encontrada' });
      return;
    }

    res.json({ message: 'Noticia actualizada', updatedNews });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

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