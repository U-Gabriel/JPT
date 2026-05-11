/**
 * Retourne le sujet et le HTML de l'email de confirmation de commande.
 * Aucun envoi ici — le controller gère le transport.
 *
 * @param {Object} orderDetails - { payment_ref: string, amount: number }
 * @returns {{ subject: string, html: string }}
 */
export const sendOrderConfirmationMail  = (orderDetails) => {
    const formattedAmount = orderDetails.amount.toFixed(2);
    const shortRef = orderDetails.payment_ref.slice(-8).toUpperCase();
    const year = new Date().getFullYear();

    const subject = `Confirmation de commande n° ${shortRef} – GDOME`;

    const html = `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <title>${subject}</title>
  <!--[if mso]>
  <noscript>
    <xml><o:OfficeDocumentSettings><o:PixelsPerInch>96</o:PixelsPerInch></o:OfficeDocumentSettings></xml>
  </noscript>
  <![endif]-->
  <style>
    /* Reset */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { margin: 0; padding: 0; background-color: #f0f0f0; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; -webkit-font-smoothing: antialiased; }
    table { border-collapse: collapse; mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
    img { border: 0; display: block; max-width: 100%; }
    a { text-decoration: none; }

    /* Responsive */
    @media only screen and (max-width: 620px) {
      .wrapper { width: 100% !important; padding: 0 !important; }
      .container { width: 100% !important; border-radius: 0 !important; }
      .content-pad { padding: 24px 20px !important; }
      .detail-table td { display: block; text-align: left !important; padding: 4px 0 !important; }
      .detail-table .value { font-size: 15px !important; }
      .amount-value { font-size: 22px !important; }
      .step-row td { display: block !important; padding: 6px 0 !important; }
      .step-number { margin-bottom: 4px !important; }
    }
  </style>
</head>
<body>

  <!-- Fond général -->
  <table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="background-color:#f0f0f0; padding: 40px 20px;">
    <tr>
      <td align="center">

        <!-- Conteneur principal -->
        <table class="container" width="600" cellpadding="0" cellspacing="0" role="presentation"
          style="background-color:#ffffff; border-radius:16px; overflow:hidden; box-shadow: 0 4px 32px rgba(0,0,0,0.10);">

          <!-- ═══════════════════════════════════════ HEADER ═══ -->
          <tr>
            <td style="background-color:#000000; padding: 36px 40px; text-align:center;">
              <p style="font-size:28px; font-weight:800; color:#ffffff; letter-spacing:6px; text-transform:uppercase; margin:0;">
                GDOME
              </p>
              
            </td>
          </tr>

          <!-- ═══════════════════════════════════════ BADGE SUCCÈS ═══ -->
          <tr>
            <td align="center" style="background-color:#000000; padding-bottom: 0;">
              <table cellpadding="0" cellspacing="0" role="presentation">
                <tr>
                  <td style="background-color:#ffffff; border-radius:50px; padding: 10px 28px; margin-top:0;">
                    <!-- inline SVG checkmark -->
                    <p style="font-size:13px; font-weight:700; color:#1a7a3c; letter-spacing:1.5px; text-transform:uppercase; margin:0;">
                      ✔&nbsp; Commande confirmée
                    </p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Bande de transition noir → blanc -->
          <tr>
            <td style="background: linear-gradient(180deg, #000000 0%, #ffffff 100%); height:32px; line-height:32px; font-size:0;">&nbsp;</td>
          </tr>

          <!-- ═══════════════════════════════════════ CORPS ═══ -->
          <tr>
            <td class="content-pad" style="padding: 8px 48px 40px 48px;">

              <h1 style="font-size:24px; font-weight:800; color:#111111; margin-bottom:12px; line-height:1.3;">
                Merci pour votre confiance&nbsp;!
              </h1>
              <p style="font-size:15px; line-height:1.7; color:#666666; margin-bottom:32px;">
                Votre commande a bien été reçue et votre paiement est validé.
                Nos équipes préparent déjà vos articles avec le plus grand soin.
              </p>

              <!-- ─── Bloc détails commande ─── -->
              <table width="100%" cellpadding="0" cellspacing="0" role="presentation"
                style="background-color:#f7f7f7; border-radius:12px; padding:0; margin-bottom:32px; overflow:hidden;">
                <tr>
                  <td style="padding: 20px 24px 0 24px;">
                    <p style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#aaaaaa; margin:0 0 16px 0;">
                      Détails de la transaction
                    </p>
                  </td>
                </tr>

                <!-- Ligne séparatrice -->
                <tr><td style="padding: 0 24px;"><hr style="border:none; border-top:1px solid #e8e8e8; margin:0;"/></td></tr>

                <!-- Référence -->
                <tr>
                  <td style="padding: 14px 24px;">
                    <table class="detail-table" width="100%" cellpadding="0" cellspacing="0" role="presentation">
                      <tr>
                        <td style="font-size:14px; color:#888888;">Référence commande</td>
                        <td class="value" align="right" style="font-size:14px; font-weight:700; color:#111111; font-family: 'Courier New', monospace; letter-spacing:1px;">
                          #${shortRef}
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>

                <tr><td style="padding: 0 24px;"><hr style="border:none; border-top:1px solid #e8e8e8; margin:0;"/></td></tr>

                <!-- Montant -->
                <tr>
                  <td style="padding: 14px 24px;">
                    <table class="detail-table" width="100%" cellpadding="0" cellspacing="0" role="presentation">
                      <tr>
                        <td style="font-size:14px; color:#888888;">Montant total</td>
                        <td class="value amount-value" align="right" style="font-size:26px; font-weight:800; color:#111111;">
                          ${formattedAmount}&nbsp;€
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>

                <tr><td style="padding: 0 24px;"><hr style="border:none; border-top:1px solid #e8e8e8; margin:0;"/></td></tr>

                <!-- Statut -->
                <tr>
                  <td style="padding: 14px 24px 20px 24px;">
                    <table class="detail-table" width="100%" cellpadding="0" cellspacing="0" role="presentation">
                      <tr>
                        <td style="font-size:14px; color:#888888;">Statut du paiement</td>
                        <td class="value" align="right">
                          <span style="display:inline-block; background-color:#e6f4ec; color:#1a7a3c; font-size:13px; font-weight:700; padding: 4px 12px; border-radius:20px;">
                            Payé
                          </span>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>

              </table>

              <!-- ─── Et la suite ? ─── -->
              <p style="font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#aaaaaa; margin-bottom:16px;">
                Et la suite&nbsp;?
              </p>

              <table width="100%" cellpadding="0" cellspacing="0" role="presentation" style="margin-bottom:32px;">

                <!-- Étape 1 -->
                <tr class="step-row">
                  <td class="step-number" width="48" valign="top" style="padding-bottom:16px;">
                    <div style="width:36px; height:36px; background-color:#000000; border-radius:50%; text-align:center; line-height:36px; font-size:14px; font-weight:800; color:#ffffff;">
                      1
                    </div>
                  </td>
                  <td valign="top" style="padding-left:14px; padding-bottom:16px;">
                    <p style="font-size:14px; font-weight:700; color:#111111; margin-bottom:4px;">Préparation de votre colis</p>
                    <p style="font-size:13px; color:#888888; line-height:1.6; margin:0;">Nos équipes sélectionnent et emballent vos articles avec soin.</p>
                  </td>
                </tr>

                <!-- Étape 2 -->
                <tr class="step-row">
                  <td class="step-number" width="48" valign="top" style="padding-bottom:16px;">
                    <div style="width:36px; height:36px; background-color:#000000; border-radius:50%; text-align:center; line-height:36px; font-size:14px; font-weight:800; color:#ffffff;">
                      2
                    </div>
                  </td>
                  <td valign="top" style="padding-left:14px; padding-bottom:16px;">
                    <p style="font-size:14px; font-weight:700; color:#111111; margin-bottom:4px;">Expédition et suivi</p>
                    <p style="font-size:13px; color:#888888; line-height:1.6; margin:0;">Vous recevrez un e-mail avec votre numéro de suivi dès l'expédition.</p>
                  </td>
                </tr>

                <!-- Étape 3 -->
                <tr class="step-row">
                  <td class="step-number" width="48" valign="top">
                    <div style="width:36px; height:36px; background-color:#000000; border-radius:50%; text-align:center; line-height:36px; font-size:14px; font-weight:800; color:#ffffff;">
                      3
                    </div>
                  </td>
                  <td valign="top" style="padding-left:14px;">
                    <p style="font-size:14px; font-weight:700; color:#111111; margin-bottom:4px;">Livraison chez vous</p>
                    <p style="font-size:13px; color:#888888; line-height:1.6; margin:0;">Votre commande arrive à destination. Profitez de vos nouveaux articles&nbsp;!</p>
                  </td>
                </tr>

              </table>

              <!-- ─── Support ─── -->
              <table width="100%" cellpadding="0" cellspacing="0" role="presentation"
                style="background-color:#f7f7f7; border-radius:12px; padding:0;">
                <tr>
                  <td style="padding: 20px 24px; text-align:center;">
                    <p style="font-size:13px; color:#888888; line-height:1.6; margin:0;">
                      Une question&nbsp;? Notre support est disponible directement<br>
                      via l'application <strong style="color:#111111;">GDOME</strong>.
                    </p>
                  </td>
                </tr>
              </table>

            </td>
          </tr>

          <!-- ═══════════════════════════════════════ FOOTER ═══ -->
          <tr>
            <td style="background-color:#111111; padding: 28px 40px; text-align:center;">
              <p style="font-size:16px; font-weight:800; color:#ffffff; letter-spacing:4px; text-transform:uppercase; margin-bottom:12px;">
                GDOME
              </p>
              <p style="font-size:12px; color:#666666; line-height:1.6; margin-bottom:16px;">
                Vous recevez cet e-mail car vous avez passé une commande sur GDOME App.<br>
                Cet e-mail est envoyé automatiquement, merci de ne pas y répondre.
              </p>
              <p style="font-size:11px; color:#444444; margin:0;">
                &copy; ${year} GDOME. Tous droits réservés.
              </p>
            </td>
          </tr>

        </table>
        <!-- Fin conteneur -->

      </td>
    </tr>
  </table>

</body>
</html>
    `;

    return { subject, html };
};
