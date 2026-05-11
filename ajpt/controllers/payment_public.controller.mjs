import Stripe from 'stripe';
import { FinalizeOrder } from "../models/payment_public.mjs";
import { ResponseApi } from "../models/response-api.mjs";
import { sendOrderConfirmationMail } from "../templates/send_order_confirmation_mail_template.mjs";
import transporter from '../services/mail_service.mjs';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);


const StripeWebhook = async (req, res) => {
    const sig = req.headers['stripe-signature'];
    let event;

    try {
        event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
    } catch (err) {
        return res.status(400).send(`Webhook Error`);
    }

    if (event.type === 'payment_intent.succeeded') {
        const paymentIntent = event.data.object;
        
        // On récupère tout proprement
        const id_person = paymentIntent.metadata.id_person;
        const id_address_delivery = paymentIntent.metadata.id_address_delivery;
        const userEmail = paymentIntent.metadata.mail; // On l'appelle userEmail ici

        try {
            console.log(`--- Traitement Commande ${paymentIntent.id} ---`);

            // Étape A : BDD
            await FinalizeOrder(paymentIntent.id, id_person, id_address_delivery, paymentIntent.amount);
            console.log("✅ BDD mise à jour (FinalizeOrder)");

            // Étape B : MAIL
            if (userEmail) {
                console.log(`📧 Tentative envoi mail à : ${userEmail}`);
                await sendOrderConfirmationMail(userEmail, {
                    payment_ref: paymentIntent.id,
                    amount: paymentIntent.amount / 100
                });
                console.log("✅ Mail envoyé avec succès");
            } else {
                console.warn("⚠️ Attention : Aucun mail dans les metadata");
            }

        } catch (err) {
            // Ici on log l'erreur RÉELLE pour comprendre la 500
            console.error(`❌ Erreur interne Webhook pour ${paymentIntent.id}:`, err.message);
            // On renvoie quand même une 500 pour que Stripe sache qu'il doit réessayer
            return res.status(500).send("Erreur interne");
        }
    }

    res.json({ received: true });
};

export { StripeWebhook };