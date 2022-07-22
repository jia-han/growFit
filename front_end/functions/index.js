const functions = require("firebase-functions");
const firebase = require("firebase-admin");
firebase.initializeApp();
var firestore = firebase.firestore();

exports.resetClaimedReward = functions.pubsub
    .schedule('0 0 * * *')
    .timeZone('Asia/Singapore')
    .onRun(async (context) => {
        const users = firestore.collection('users');
        const user = await users.get();
        user.forEach(snapshot => {
            snapshot.ref.update({ ClaimedReward: false })
        });
        return null;
    });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
