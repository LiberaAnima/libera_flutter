/* eslint-disable quotes */

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

exports.sendNotificationOnComment = functions.firestore
    .document("posts/{postId}/comments/{commentId}")
    .onCreate(async (snapshot, context) => {
      const postId = context.params.postId;
      const newComment = snapshot.data();

      // Get the post document
      const postSnapshot = await admin.firestore().doc(`posts/${postId}`).get();
      const postData = postSnapshot.data();

      // Get the post author's uid
      const uid = postData.uid;

      // Prepare the notification
      const notification = {
        notification: {
          title: "New comment on your post",
          // eslint-disable-next-line max-len
          body: `${newComment.isAnonymous ? '匿名' : newComment.name}: ${newComment.text}`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      // Send the notification
      return admin.messaging().sendToTopic(uid, notification);
    });

exports.sendNotificationOnLike = functions.firestore
    .document("posts/{postId}")
    .onUpdate(async (change, context) => {
      // const postId = context.params.postId;
      const beforeData = change.before.data(); // data before the change
      const afterData = change.after.data(); // data after the change

      // Check if likes array has a new item
      if (beforeData.likes.length < afterData.likes.length) {
        // Get the post author's uid
        const uid = afterData.uid;

        // Prepare the notification
        const notification = {
          notification: {
            title: "New like on your post",
            body: "Someone liked your post!",
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        };

        // Send the notification
        return admin.messaging().sendToTopic(uid, notification);
      } else {
        // If likes array didn't change, do nothing
        return null;
      }
    });
