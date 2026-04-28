import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    },
});

// On vérifie la connexion au démarrage (optionnel mais conseillé)
transporter.verify((error, success) => {
    if (error) {
        console.error("❌ Erreur configuration MailService:", error);
    } else {
        console.log("✅ Serveur de mail prêt à envoyer des messages");
    }
});

export default transporter;