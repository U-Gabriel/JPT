import Stripe from 'stripe';
import { UpdateCartAndGetTotal, GetUserMailById, GetAllOrdersCompleteRequest, GetOrdersByStatusRequest, UpdateOrderStatusRequest } from "../models/payment_private.mjs";
import { ResponseApi } from "../models/response-api.mjs";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

const CreatePaymentIntent = async (req, res) => {
    try {
        const id_person = req.data?.id_person;
        let user_mail = req.data?.mail;
        const { items, id_address_delivery } = req.body;

        if (!id_person) return res.status(401).send(new ResponseApi().InitUnauthorized());

        // RÉCUPÉRATION DU MAIL VIA LE MODÈLE ✅
        if (!user_mail) {
            user_mail = await GetUserMailById(id_person);
        }

        if (!id_person) return res.status(401).send(new ResponseApi().InitUnauthorized());
        if (!items || items.length === 0) {
            return res.status(400).send(new ResponseApi().InitBadRequest("Le panier est vide"));
        }

        /** * ÉTAPE 1 : Pré-création de l'intention Stripe 
         * On crée une intention vide juste pour obtenir un ID (pi_...)
         */
        const paymentIntentPlaceholder = await stripe.paymentIntents.create({
            amount: 100, // Montant temporaire (sera mis à jour juste après)
            currency: 'eur',
            metadata: { id_person, id_address_delivery, mail: user_mail },
            automatic_payment_methods: { enabled: true },
        });

        /**
         * ÉTAPE 2 : Verrouillage en BDD
         * On envoie l'ID Stripe (paymentIntentPlaceholder.id) au modèle
         * pour marquer les articles et calculer le prix final REEL.
         */
        const finalAmount = await UpdateCartAndGetTotal(
            id_person, 
            items, 
            paymentIntentPlaceholder.id,
            id_address_delivery
        );

        /**
         * ÉTAPE 3 : Mise à jour de l'intention Stripe
         * Maintenant qu'on a le prix exact calculé par le serveur, on met à jour Stripe.
         */
        const updatedPaymentIntent = await stripe.paymentIntents.update(
            paymentIntentPlaceholder.id,
            { amount: Math.round(finalAmount * 100) }
        );

        // 4. On renvoie le secret définitif à l'App
        return res.status(200).send(new ResponseApi().InitOK({
            clientSecret: updatedPaymentIntent.client_secret,
            total: finalAmount,
            paymentIntentId: updatedPaymentIntent.id
        }));

    } catch (e) {
        console.error("Stripe Create Error:", e);
        // On renvoie un message propre à l'utilisateur (ex: "Stock insuffisant")
        return res.status(400).send(new ResponseApi().InitBadRequest(e.message));
    }
};

const GetAllOrders = async () => {
    try {
        const data = await GetAllOrdersCompleteRequest();
        if (data.length > 0) {
            return new ResponseApi().InitOK(data);
        } else {
            return new ResponseApi().InitNoContent();
        }
    } catch (e) {
        console.error("Error in GetAllOrders:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

const GetOrdersByStatus = async (body) => {
    const { status } = body;

    // Contrôle du body
    if (!status) {
        return new ResponseApi().InitMissingParameters();
    }

    // Validation des statuts autorisés pour éviter les injections inutiles
    const allowedStatuses = ['PAID', 'LOADING', 'SENDING', 'CLOSED'];
    if (!allowedStatuses.includes(status)) {
        return new ResponseApi().InitBadRequest("Statut invalide.");
    }

    try {
        const data = await GetOrdersByStatusRequest(status);
        return new ResponseApi().InitOK(data);
    } catch (e) {
        console.error(`Error in GetOrdersByStatus (${status}):`, e);
        return new ResponseApi().InitInternalServer(e);
    }
};

const UpdateOrderStatus = async (body) => {
    const { id_order, status } = body;

    // 1. Validation des paramètres
    if (!id_order || !status) {
        return new ResponseApi().InitMissingParameters();
    }

    // 2. Liste des statuts autorisés (règle métier)
    const allowedStatuses = ['PAID', 'LOADING', 'SENDING', 'CLOSED'];
    if (!allowedStatuses.includes(status)) {
        return new ResponseApi().InitBadRequest("Statut invalide.");
    }

    try {
        const updatedOrder = await UpdateOrderStatusRequest(id_order, status);
        
        if (updatedOrder) {
            return new ResponseApi().InitOK("Statut mis à jour avec succès.", updatedOrder);
        } else {
            return new ResponseApi().InitBadRequest("Commande non trouvée.");
        }
    } catch (e) {
        console.error("Error in UpdateOrderStatus:", e);
        return new ResponseApi().InitInternalServer(e);
    }
};

export { CreatePaymentIntent, GetAllOrders, GetOrdersByStatus, UpdateOrderStatus };