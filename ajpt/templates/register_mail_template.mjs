export const getRegisterEmailHtml = (firstname, registerCode) => {
    return `
        <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e0e0e0; border-radius: 10px; overflow: hidden;">
            <div style="background-color: #2196F3; padding: 20px; text-align: center;">
                <h1 style="color: white; margin: 0;">Bienvenue parmi nous !</h1>
            </div>
            <div style="padding: 30px; color: #333; line-height: 1.6;">
                <h2 style="color: #2196F3;">Bonjour,</h2>
                <p>Merci de nous avoir rejoint. Pour activer votre compte, veuillez saisir le code de validation suivant :</p>
                <div style="margin: 30px 0; background: #f0f7ff; border-radius: 8px; padding: 20px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #1976D2; border: 1px dashed #2196F3;">
                    ${registerCode}
                </div>
                <p>Ce code est nécessaire pour finaliser votre inscription.</p>
                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                <p style="font-size: 0.8em; color: #999;">Si vous n'avez pas créé de compte, vous pouvez ignorer ce message.</p>
            </div>
        </div>
    `;
};