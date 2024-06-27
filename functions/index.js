/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Only authenticated users can delete user accounts",
    );
  }

  const uid = data.uid;
  if (!(typeof uid === "string") || uid.length === 0) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with " +
        "one arguments 'uid' containing the user id to delete",
    );
  }

  try {
    await admin.auth().deleteUser(uid);
    return {
      uid: uid,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
        "internal",
        "An error occurred while deleting the user",
    );
  }
});

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
