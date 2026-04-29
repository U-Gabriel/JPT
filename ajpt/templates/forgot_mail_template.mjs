// templates/forgot_mail_template.mjs
export const getForgotEmailHtml = (firstname, resetCode) => {
    return `
        <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e0e0e0; border-radius: 10px; overflow: hidden;">
            <div style="background-color: #4CAF50; padding: 20px; text-align: center;">
                <h1 style="color: white; margin: 0;">Sécurité de votre compte</h1>
            </div>
            <div style="padding: 30px; color: #333; line-height: 1.6;">
                <h2 style="color: #4CAF50;">Bonjour ${firstname},</h2>
                <p>Nous avons reçu une demande de réinitialisation de mot de passe pour votre espace <strong>Plante App</strong>.</p>
                <p>Veuillez utiliser le code de vérification suivant :</p>
                <div style="margin: 30px 0; background: #f9f9f9; border-radius: 8px; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #2e7d32; border: 1px dashed #4CAF50;">
                    ${resetCode}
                </div>
                <p style="font-size: 0.9em; color: #666;">Ce code est strictement confidentiel et expirera dans <strong>15 minutes</strong>.</p>
                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                <p style="font-size: 0.8em; color: #999;">Si vous n'êtes pas à l'origine de cette demande, vous pouvez ignorer ce mail en toute sécurité.</p>
            </div>
            <div style="background-color: #f4f4f4; padding: 15px; text-align: center; font-size: 0.8em; color: #777;">
                &copy; 2026 GDOME App - La domotique à votre service.
            </div>
        </div>
    `;
};