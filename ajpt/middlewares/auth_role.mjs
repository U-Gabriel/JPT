/**
 * Middleware pour bloquer l'accès si l'utilisateur n'est pas Admin (id_role != 3)
 */
const checkAdmin = (req, res, next) => {
    // Si authToken a bien fait son travail, req.data contient l'utilisateur
    if (!req.data || req.data.id_role !== 3) {
        // 403 Forbidden : On sait qui tu es, mais tu n'as pas les droits
        return res.status(403).json({
            success: false,
            message: "Accès refusé. Droits administrateur requis."
        });
    }
    next();
};

export { checkAdmin };