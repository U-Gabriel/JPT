import Stripe from 'stripe';
import { FinalizeOrder } from "../models/payment_public.mjs";
import { ResponseApi } from "../models/response-api.mjs";
import { sendOrderConfirmationMail } from "../templates/send_order_confirmation_mail_template.mjs";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);


const StripeWebhook = async (req, res) => {
    console.log("--- DEBUG WEBHOOK ---");
    console.log("Type du Body:", typeof req.body);
    console.log("Est-ce un Buffer?:", Buffer.isBuffer(req.body));
    const sig = req.headers['stripe-signature'];
    let event;

    try {
        event = stripe.webhooks.constructEvent(
            req.body, 
            sig, 
            process.env.STRIPE_WEBHOOK_SECRET
        );
    } catch (err) {
        console.error(`Webhook Signature Error: ${err.message}`);
        return res.status(400).send(`Webhook Error`);
    }

    if (event.type === 'payment_intent.succeeded') {
        const paymentIntent = event.data.object;
        
        // RECUPERATION DES DEUX INFOS DEPUIS LES METADATA
        const id_person = paymentIntent.metadata.id_person;
        const id_address_delivery = paymentIntent.metadata.id_address_delivery;

        try {
            // AJOUT DE id_address_delivery DANS L'APPEL
            await FinalizeOrder(paymentIntent.id, id_person, id_address_delivery, paymentIntent.amount);

            const userMail = paymentIntent.receipt_email || paymentIntent.metadata.mail; 

            // 3. Envoyer le mail de confirmation
            if (userMail) {
                await sendOrderConfirmationMail(userMail, {
                    payment_ref: paymentIntent.id,
                    amount: paymentIntent.amount /100
                });
            }

            console.log(`✅ Commande finalisée pour l'utilisateur ${id_person} à l'adresse ${id_address_delivery}`);
        } catch (err) {
            console.error(`❌ Erreur BDD Webhook: ${err.message}`);
            return res.status(500).send("Erreur interne");
        }
    }

    res.json({ received: true });
};

export { StripeWebhook };