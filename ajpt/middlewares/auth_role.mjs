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

/**
 * Middleware dynamique pour restreindre l'accès à certains rôles spécifiques
 * @param {number[]} allowedRoles - Tableau des ID de rôles autorisés (ex: [3, 7])
 */
const checkRoles = (allowedRoles = []) => {
    return (req, res, next) => {
        // Sécurité : Si le token n'a pas injecté les données ou si le rôle n'est pas dans la liste
        if (!req.data || !allowedRoles.includes(req.data.id_role)) {
            return res.status(403).json({
                success: false,
                message: "Accès refusé. Vous n'avez pas les permissions nécessaires pour effectuer cette action."
            });
        }
        next();
    };
};

export { checkAdmin, checkRoles };