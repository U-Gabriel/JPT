import multer from 'multer';
import path from 'path';
import fs from 'fs';

// Configuration du dossier de stockage pour les plantes
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const isLinux = process.platform === 'linux';
        const dir = isLinux 
            ? '/var/www/html/dataset/data_plant' 
            : './dataset/data_plant';
        
        // Création automatique si absent
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        const ext = path.extname(file.originalname).toLowerCase();
        cb(null, `plant-${uniqueSuffix}${ext}`);
    }
});

// Filtre de sécurité (pour éviter d'uploader des virus ou des scripts malveillants)
const fileFilter = (req, file, cb) => {
    const allowedExtensions = /jpeg|jpg|png|gif|webp|svg/i;
    const allowedMimeTypes = /^image\/(jpeg|jpg|png|gif|webp|svg\+xml)$/i;
    
    const extName = path.extname(file.originalname).toLowerCase();
    const isExtAllowed = allowedExtensions.test(extName);
    const isMimeAllowed = allowedMimeTypes.test(file.mimetype);

    if (isExtAllowed || isMimeAllowed) {
        return cb(null, true);
    } else {
        cb(new Error(`Format non supporté (${file.mimetype}).`));
    }
};

// Exportation de l'instance avec limite de taille
export const uploadPlant = multer({ 
    storage: storage,
    fileFilter: fileFilter,
    limits: { fileSize: 5 * 1024 * 1024 } // 5MB max
});