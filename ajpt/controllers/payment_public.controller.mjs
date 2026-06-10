import Stripe from 'stripe';
import { FinalizeOrder } from "../models/payment_public.mjs";
import { sendOrderConfirmationMail } from "../templates/send_order_confirmation_mail_template.mjs";
import transporter from '../services/mail_service.mjs';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const StripeWebhook = async (req, res) => {
    const sig = req.headers['stripe-signature'];
    let event;

    try {
        event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
    } catch (err) {
        // 🌟 Log l'erreur exacte en console pour debug si la clé whsec_ est mauvaise
        console.error(`❌ Webhook Signature Error: ${err.message}`);
        return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === 'payment_intent.succeeded') {
        const paymentIntent = event.data.object;
        
        // 🌟 Sécurité : On extrait et on convertit en Integer pour la BDD
        const id_person = paymentIntent.metadata.id_person ? parseInt(paymentIntent.metadata.id_person, 10) : null;
        const id_address_delivery = paymentIntent.metadata.id_address_delivery ? parseInt(paymentIntent.metadata.id_address_delivery, 10) : null;
        const userEmail = paymentIntent.metadata.mail; 

        try {
            console.log(`--- Traitement Commande Live ${paymentIntent.id} ---`);

            // Étape A : BDD
            await FinalizeOrder(paymentIntent.id, id_person, id_address_delivery, paymentIntent.amount);
            console.log("✅ BDD mise à jour (FinalizeOrder)");

            // Étape B : MAIL
            if (userEmail) {
                const { subject, html } = sendOrderConfirmationMail({
                    payment_ref: paymentIntent.id,
                    amount: paymentIntent.amount / 100 // Stripe donne 4590, on envoie 45.90 au template
                });

                await transporter.sendMail({
                    from: `"GDOME Support" <${process.env.EMAIL_USER}>`,
                    to: userEmail,
                    subject,
                    html
                });

                console.log(`✅ Mail de confirmation envoyé à : ${userEmail}`);
            } else {
                console.warn("⚠️ Attention : Aucun mail dans les metadata");
            }

        } catch (err) {
            console.error(`❌ Erreur interne Webhook pour ${paymentIntent.id}:`, err.message);
            // On renvoie une 500 pour que Stripe retente l'envoi du webhook plus tard
            return res.status(500).send("Erreur interne lors du traitement de la commande");
        }
    }

    // On renvoie un 200 à Stripe pour lui dire qu'on a bien reçu l'info
    res.json({ received: true });
};

export { StripeWebhook };