
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore
    .document("chatroom/{chatroomId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
      const chatroomId = context.params.chatroomId;
      const chatroomSnapshot = await admin.firestore()
          .doc(`chatroom/${chatroomId}`).get();
      const who = chatroomSnapshot.data().who;
      // console.log("chat:" + chatroomId);
      // console.log("chatsnap" + chatroomSnapshot.data());
      // console.log("who" + who);

      const promises = who.map((uid) => {
        return admin.messaging().sendToTopic(uid, {
          notification: {
            title: snapshot.data()["username"],
            body: snapshot.data()["text"],
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        });
      });

      return Promise.all(promises);
    });
