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

exports.sendPushNotification = functions.region("asia-northeast3").https.onCall(async (data, context) => {
    // 클라이언트로부터 받은 데이터
    const {token, title, body, screen} = data;
    console.log("token:", token, "title:", title, "body:", body);
    // 푸시 알림 메시지 구성
    const message = {
        notification: {
            title: title,
            body: body,
        },
        data: {
            screen: screen,
        },
        token: token,
    };

    try {
        // 푸시 알림 전송
        const response = await admin.messaging().send(message);
        console.log("Successfully sent message:", response);
        return {success: true, message: "Notification sent successfully"};
    } catch (error) {
        console.log("Error sending message:", error);
        throw new functions.https.HttpsError("internal", "Error sending push notification");
    }
});

exports.checkEndTimeAndSendFCM = functions.pubsub.schedule("every 1 minutes").onRun(async (context) => {
  const db = admin.firestore();
  const now = admin.firestore.Timestamp.now();
  const oneMinuteAgo = admin.firestore.Timestamp.fromMillis(now.toMillis() - 60 * 1000);

  try {
    const snapshot = await db.collection("posts")
      .where("auctionStatus", "==", 0)
      .where("endTime", ">", oneMinuteAgo)
      .where("endTime", "<=", now)
      .get();

    const batch = db.batch();

    for (const doc of snapshot.docs) {
      const postData = doc.data();
      const postRef = db.collection("posts").doc(doc.id);
      const bidList = postData.bidList || [];

      if (bidList.length === 1) {
        batch.update(postRef, {
          auctionStatus: 2,
          stockStatus: 3,
          isDone: true,
        });

        // 시간 지나서 유찰 -> 판매자에게 fcm보내기
        await sendFCM(postData.writeUser.pushToken, "경매 종료", `${postData.postTitle} 상품의 경매가 종료되었습니다. 낙찰자가 없습니다.`, `/post/detail?${postData.postUid}`);
      } else if (bidList.length >= 2) {
        batch.update(postRef, {
          auctionStatus: 1,
          stockStatus: 1,
        });

        // 시간지나서 판매자에게 fcm보내기
        await sendFCM(postData.writeUser.pushToken, "경매 종료", `${postData.postTitle} 상품의 경매가 종료되었습니다. 낙찰자가 결정되었습니다.`, `/post/detail?${postData.postUid}`);

        // 시간지나서 낙찰자에게 fcm보내기
        const lastBid = `bidList`[bidList.length - 1];
        await sendFCM(lastBid.bidUser.pushToken, "낙찰 알림", `${postData.postTitle} 상품이 낙찰되었습니다. 확인해보세요!`, `/post/detail?${postData.postUid}`);
      }
    }

    // 배치 커밋
    await batch.commit();

    console.log("Batch operation completed");
    return null;
  } catch (error) {
    console.error("Error in checkEndTimeAndSendFCM:", error);
    return null;
  }
});

async function sendFCM(token, title, body, screen) {
  const message = {
          notification: {
              title: title,
              body: body,
          },
          data: {
              screen: screen,
          },
          token: token,
      };

  try {
    await admin.messaging().send(message);
    console.log("Successfully sent message:", title);
  } catch (error) {
    console.log("Error sending message:", error);
  }
}
