export const getAlreadyRegisteredEmailHtml = (firstname) => {
    return `
        <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e0e0e0; border-radius: 10px; overflow: hidden;">
            <div style="background-color: #FF9800; padding: 20px; text-align: center;">
                <h1 style="color: white; margin: 0;">Alerte de sécurité</h1>
            </div>
            <div style="padding: 30px; color: #333; line-height: 1.6;">
                <h2 style="color: #F57C00;">Bonjour,</h2>
                <p>Une personne a tenté de créer un compte <strong>GDOME App</strong> avec votre adresse e-mail.</p>
                
                <div style="background-color: #FFF3E0; border-left: 4px solid #FF9800; padding: 15px; margin: 20px 0;">
                    <p style="margin: 0; font-weight: bold;">Bonne nouvelle : Votre compte est déjà actif et sécurisé.</p>
                </div>

                <p><strong>S'il s'agit de vous :</strong> Vous pouvez simplement vous connecter à votre compte habituel. Si vous avez oublié votre mot de passe, utilisez la fonction de récupération.</p>
                
                <p><strong>S'il ne s'agit pas de vous :</strong> Aucune action n'est requise. Votre mot de passe actuel n'a pas été modifié et personne n'a pu accéder à vos données. Par précaution, veillez à ne jamais divulguer vos identifiants.</p>

                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
                <p style="font-size: 0.8em; color: #999; text-align: center;">L'équipe de sécurité GDOME App</p>
            </div>
        </div>
    `;
};