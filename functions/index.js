/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
// const stripe = require("stripe")("sk_test_51N7x3JDmfaCGD9zyizcIUrLt1SxaCBE4zGUIHLLpfm36C2cPLvYfTpFkFkbNdBIeA6KhLOnzazB8DwBP3urbT88F00AN1hgVV4");
const stripe = require("stripe")(functions.config().stripe.token);


exports.createPaymentIntent = functions.region('us-central1').https.onCall( async (req) => {
  // Create a PaymentIntent with the order amount and currency
    const paymentIntent = await stripe.paymentIntents.create({
        amount: req.price,
        currency: "jpy",
        automatic_payment_methods: {
            enabled: true,
        },
    });

    return {
    clientSecret: paymentIntent.client_secret,
    };
});

exports.helloWorld = functions.region("us-central1").https.onRequest((request, response) => {
    var string = "Hello from Firebase"
    var name = request.name
    response.send({
        data: String(name+string)
    });
});

exports.ServerTime = functions.https.onRequest((request, response) => {
    var dt = new Date();
    var delta = dt.getTime();
    response.send({
        data: String(delta)
    });
});

exports.addNumbers = functions.https.onCall((data) => {
    const firstNumber = data.firstNumber;
    const secondNumber = data.secondNumber;
    if (!Number.isFinite(firstNumber) || !Number.isFinite(secondNumber)) {
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +'two arguments "firstNumber" and "secondNumber" which must both be numbers.');
    }

    return {
        firstNumber: String(firstNumber),
        secondNumber: String(secondNumber),
        operator: String("+"),
        operationResult: String(firstNumber + secondNumber),
    };
});