import multer from 'multer';
import path from 'path';
import fs from 'fs';

// Configuration du dossier de stockage
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // 🛠️ FIX PROTOCOLE VPS PRODUCTION VS LOCAL
        // Si on est sur Linux/VPS, on force le dossier absolu /var/www/html/...
        // Sinon (sur ton Windows en local), on garde le dossier relatif de ton projet
        const isLinux = process.platform === 'linux';
        const dir = isLinux 
            ? '/var/www/html/dataset/object' 
            : './dataset/object';
        
        // Si le dossier n'existe pas, on le crée automatiquement
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        // On génère un nom unique : date-nombre_aléatoire.extension
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname);
        cb(null, `object-${uniqueSuffix}${ext}`);
    }
});

// Filtre pour accepter uniquement les images (Version Blindée)
const fileFilter = (req, file, cb) => {
    // 1. On accepte les extensions courantes (gère minuscules et majuscules)
    const allowedExtensions = /jpeg|jpg|png|gif|webp/i;
    const extName = path.extname(file.originalname).toLowerCase();
    const isExtAllowed = allowedExtensions.test(extName);

    // 2. On accepte les types MIME d'images standards
    const allowedMimeTypes = /^image\/(jpeg|jpg|png|gif|webp|x-png|pjpeg)$/i;
    const isMimeAllowed = allowedMimeTypes.test(file.mimetype);

    if (isExtAllowed || isMimeAllowed) {
        return cb(null, true);
    } else {
        cb(new Error(`Format non supporté (${file.mimetype}). Uniquement JPG, PNG, WEBP, GIF.`));
    }
};

// Limite la taille des fichiers à 5 Mo
const upload = multer({
    storage: storage,
    fileFilter: fileFilter,
    limits: { fileSize: 5 * 1024 * 1024 } 
});

export { upload };