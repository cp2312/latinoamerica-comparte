const roleMiddleware = (...rolesPermitidos) => {
  return (req, res, next) => {

    if (!req.user) {
      return res.status(401).json({
        message: 'Usuario no autenticado'
      });
    }

    if (!rolesPermitidos.includes(req.user.rol)) {
      return res.status(403).json({
        message: 'No tienes permisos para esta acción'
      });
    }

    next();
  };
};

module.exports = roleMiddleware;