/**
 * Template de bienvenue Professionnel et Design
 * @param {string} mail
 */
export const getWelcomeEmailHtml = (mail) => {
    const primaryColor = '#2ecc71'; // Vert élégant
    const darkColor = '#2c3e50';
    
    return `
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            .container { max-width: 600px; margin: 0 auto; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f9f9f9; padding: 20px; }
            .card { background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); border: 1px solid #eeeeee; }
            .header { background-color: ${darkColor}; padding: 40px 20px; text-align: center; }
            .header h1 { color: #ffffff; margin: 0; font-size: 26px; letter-spacing: 1px; }
            .content { padding: 40px 30px; text-align: center; }
            .content p { color: #555555; line-height: 1.8; font-size: 16px; }
            .user-badge { background-color: #f0fdf4; color: ${primaryColor}; padding: 8px 16px; border-radius: 20px; font-weight: bold; display: inline-block; margin: 10px 0; }
            .button { background-color: ${primaryColor}; color: #ffffff !important; text-decoration: none; padding: 15px 35px; border-radius: 8px; font-weight: 600; display: inline-block; margin-top: 25px; transition: background 0.3s; }
            .footer { padding: 20px; text-align: center; color: #aaaaaa; font-size: 12px; }
            .logo-placeholder { font-size: 32px; font-weight: 800; color: #ffffff; margin-bottom: 10px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="header">
                    <div class="logo-placeholder">GDOME</div>
                    <h1>Bienvenue parmi nous !</h1>
                </div>
                <div class="content">
                    <p>C'est un plaisir de vous compter parmi nos nouveaux utilisateurs.</p>
                    <p>Votre compte est désormais activé pour l'adresse :</p>
                    <div class="user-badge">${mail}</div>
                    <p>Vous pouvez maintenant accéder à votre espace personnel et configurer vos préférences.</p>
                    
                    <a href="#" class="button">Lancer l'application</a>
                </div>
            </div>
            <div class="footer">
                <p>&copy; 2026 GDOME App. Tous droits réservés.</p>
                <p>Vous recevez ce mail car un compte a été créé sur notre plateforme.</p>
            </div>
        </div>
    </body>
    </html>
    `;
};