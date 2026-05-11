export const sendOrderConfirmationMail = async (mail, orderDetails) => {
    try {
        const formattedAmount = orderDetails.amount.toFixed(2);
        
        const mailOptions = {
            from: `"GDOME Support" <${process.env.EMAIL_USER}>`,
            to: mail,
            subject: `Confirmation de commande n° ${orderDetails.payment_ref.slice(-8).toUpperCase()} - GDOME`,
            html: `
            <div style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; color: #333; border: 1px solid #eee; border-radius: 10px; overflow: hidden;">
                <div style="background-color: #000; padding: 20px; text-align: center;">
                    <h1 style="color: #fff; margin: 0; letter-spacing: 2px;">GDOME</h1>
                </div>

                <div style="padding: 30px;">
                    <h2 style="color: #000; margin-top: 0;">Merci pour votre confiance !</h2>
                    <p style="font-size: 16px; line-height: 1.5; color: #555;">
                        Bonjour,<br><br>
                        Nous avons le plaisir de vous confirmer la validation de votre commande. Nos équipes préparent déjà vos produits avec le plus grand soin.
                    </p>

                    <div style="background-color: #f9f9f9; padding: 20px; border-radius: 8px; margin: 25px 0;">
                        <h3 style="margin-top: 0; font-size: 14px; text-transform: uppercase; color: #888;">Détails de la transaction</h3>
                        <table style="width: 100%; border-collapse: collapse;">
                            <tr>
                                <td style="padding: 5px 0; color: #555;">Référence :</td>
                                <td style="padding: 5px 0; text-align: right; font-weight: bold;">${orderDetails.payment_ref}</td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0; color: #555;">Montant total :</td>
                                <td style="padding: 5px 0; text-align: right; font-weight: bold; font-size: 18px; color: #000;">${formattedAmount} €</td>
                            </tr>
                            <tr>
                                <td style="padding: 5px 0; color: #555;">Statut du paiement :</td>
                                <td style="padding: 5px 0; text-align: right; color: #27ae60; font-weight: bold;">Confirmé</td>
                            </tr>
                        </table>
                    </div>

                    <p style="font-size: 15px; line-height: 1.5; color: #555;">
                        <b>Et la suite ?</b><br>
                        Dès que votre colis quitte notre entrepôt, vous recevrez un nouvel e-mail contenant votre numéro de suivi transporteur.
                    </p>
                    
                    <p style="font-size: 15px; line-height: 1.5; color: #555;">
                        Nous serons très rapidement de retour vers vous avec vos articles !
                    </p>

                    <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; text-align: center;">
                        <p style="font-size: 14px; color: #888;">
                            Une question ? Notre support est là pour vous aider via l'application.
                        </p>
                    </div>
                </div>

                <div style="background-color: #f4f4f4; padding: 20px; text-align: center; font-size: 12px; color: #aaa;">
                    &copy; ${new Date().getFullYear()} GDOME. Tous droits réservés.
                </div>
            </div>
            `
        };

        await transporter.sendMail(mailOptions);
        console.log(`✅ Mail de confirmation pro envoyé à : ${mail}`);
    } catch (error) {
        console.error("Erreur envoi mail confirmation commande:", error);
    }
};