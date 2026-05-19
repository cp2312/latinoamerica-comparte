import { Request, Response } from 'express';
import nodemailer from 'nodemailer';
import Solicitud from '../models/Solicitud';
import Actividad from '../models/Actividad';
import { AuthRequest } from '../types';

type EstadoSolicitud = 'pendiente' | 'gestionada' | 'respondida';

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// ── Helper para registrar actividad ──────────────────────────────────────────
const registrarActividad = async (
  tipo: 'solicitud' | 'noticia' | 'testimonio',
  accion: string,
  texto: string,
  pais: string,
  usuario: string
) => {
  try {
    await Actividad.create({ tipo, accion, texto, pais: pais.toLowerCase(), usuario });
  } catch (_) {}
};

// GET /solicitudes
const getSolicitudes = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const filtro: Record<string, unknown> = {};

    if (req.query.pais)   filtro.pais   = req.query.pais as string;
    if (req.query.estado) filtro.estado = req.query.estado as string;

    if (authReq.user?.rol === 'admin_pais' && authReq.user.pais) {
      filtro.pais = authReq.user.pais;
    }

    const items = await Solicitud.find(filtro).sort({ createdAt: -1 });
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// GET /solicitudes/:id
const getSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Solicitud.findById(req.params.id);
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// POST /solicitudes/public — sin auth, registra actividad automáticamente
const createSolicitudPublica = async (req: Request, res: Response): Promise<void> => {
  try {
    const { nombre, correo, telefono, finalidad, pais } = req.body as {
      nombre: string; correo: string; telefono: string;
      finalidad: string; pais: string;
    };

    if (!nombre || !correo || !telefono || !finalidad || !pais) {
      res.status(400).json({ message: 'Faltan campos requeridos' });
      return;
    }

    const item = await Solicitud.create({ nombre, correo, telefono, finalidad, pais });

    // Registrar en actividad
    await registrarActividad(
      'solicitud',
      'nueva_solicitud',
      `Nueva solicitud de ${nombre}`,
      pais,
      nombre
    );

    res.status(201).json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// PATCH /solicitudes/:id/estado
const cambiarEstadoSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const { estado } = req.body as { estado: EstadoSolicitud };
    const validos: EstadoSolicitud[] = ['pendiente', 'gestionada', 'respondida'];

    if (!validos.includes(estado)) {
      res.status(400).json({ message: 'Estado inválido' });
      return;
    }

    const item = await Solicitud.findByIdAndUpdate(
      req.params.id, { estado }, { new: true }
    );
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }

    // Registrar en actividad
    const textos: Record<EstadoSolicitud, string> = {
      pendiente:  `Solicitud de ${item.nombre} marcada como pendiente`,
      gestionada: `Solicitud de ${item.nombre} en gestión`,
      respondida: `Solicitud de ${item.nombre} marcada como respondida`,
    };
    await registrarActividad(
      'solicitud',
      'estado_cambiado',
      textos[estado],
      item.pais,
      authReq.user?.id ?? ''
    );

    res.json(item);
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

// POST /solicitudes/:id/responder
const responderSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const authReq = req as AuthRequest;
    const { mensaje } = req.body as { mensaje: string };

    if (!mensaje || mensaje.trim().length === 0) {
      res.status(400).json({ message: 'El mensaje no puede estar vacío' });
      return;
    }

    const solicitud = await Solicitud.findById(req.params.id);
    if (!solicitud) {
      res.status(404).json({ message: 'Solicitud no encontrada' });
      return;
    }

    await transporter.sendMail({
      from:    `"Latinoamérica Comparte" <${process.env.EMAIL_USER}>`,
      to:      solicitud.correo,
      subject: `Respuesta a tu solicitud — Latinoamérica Comparte`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #6A0080, #9C27B0);
                      padding: 32px; text-align: center; border-radius: 12px 12px 0 0;">
            <h2 style="color: white; margin: 0;">Latinoamérica Comparte</h2>
            <p style="color: rgba(255,255,255,0.8); margin: 8px 0 0;">
              Hemos respondido tu solicitud
            </p>
          </div>
          <div style="background: #fff; padding: 32px;
                      border: 1px solid #eee; border-top: none;
                      border-radius: 0 0 12px 12px;">
            <p style="color: #333; font-size: 16px;">
              Hola <strong>${solicitud.nombre}</strong>,
            </p>
            <p style="color: #555; line-height: 1.7;">
              Gracias por contactarnos. A continuación nuestra respuesta:
            </p>
            <div style="background: #F9F0FF; border-left: 4px solid #6A0080;
                        padding: 16px 20px; border-radius: 8px; margin: 20px 0;">
              <p style="color: #333; margin: 0; line-height: 1.7; white-space: pre-line;">
                ${mensaje}
              </p>
            </div>
            <p style="color: #888; font-size: 13px; margin-top: 28px;">
              Tu solicitud sobre <em>"${solicitud.finalidad}"</em>
              registrada el ${new Date((solicitud as any).createdAt)
                .toLocaleDateString('es-CO', { year: 'numeric', month: 'long', day: 'numeric' })}
              ha sido marcada como <strong>respondida</strong>.
            </p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
            <p style="color: #aaa; font-size: 12px; text-align: center;">
              Latinoamérica Comparte · Colombia · Chile · Ecuador · Argentina
            </p>
          </div>
        </div>
      `,
    });

    await Solicitud.findByIdAndUpdate(req.params.id, { estado: 'respondida' });

    // Registrar en actividad
    await registrarActividad(
      'solicitud',
      'respondida',
      `Solicitud de ${solicitud.nombre} respondida por correo`,
      solicitud.pais,
      authReq.user?.id ?? ''
    );

    res.json({ message: 'Correo enviado y solicitud marcada como respondida' });
  } catch (error) {
    res.status(500).json({ message: 'No se pudo enviar el correo: ' + (error as Error).message });
  }
};

// DELETE /solicitudes/:id
const deleteSolicitud = async (req: Request, res: Response): Promise<void> => {
  try {
    const item = await Solicitud.findByIdAndDelete(req.params.id);
    if (!item) { res.status(404).json({ message: 'No encontrada' }); return; }
    res.json({ message: 'Solicitud eliminada' });
  } catch (error) {
    res.status(500).json({ message: (error as Error).message });
  }
};

export {
  getSolicitudes,
  getSolicitud,
  createSolicitudPublica,
  cambiarEstadoSolicitud,
  responderSolicitud,
  deleteSolicitud,
};