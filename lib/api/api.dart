import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:private_chat/models/chat_user.dart';

import '../models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get authUser => auth.currentUser!;

  //for Accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessage = FirebaseMessaging.instance;

  //for getting firebase message token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessage.requestPermission();

    fMessage.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Token: $t');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${msg.data}');

      if (msg.notification != null) {
        log('Message also contained a notification: ${msg.notification}');
      }
    });
  }

  //For sending Push Notification

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": {"some_data": "User ID: ${me.id}"}
      };

      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    "key=AAAANT1Nyxk:APA91bFTBB-PFg27A1Vyhsv3EMS-svRp55Xlr3VddOVPvPw42nw1u7Z75A8sCuZDrp0F3dWfZZi4lXh_d7wAxiuJKqclGuTEqYs3L8CouEMUW4w6RlC4T7yK9uUJs-sEHE9kpqum7uMr"
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static late ChatUser me;

  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(authUser.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore
        .collection('users')
        .doc(authUser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: authUser.photoURL.toString(),
        name: authUser.displayName.toString(),
        about: 'Hey, I am using Private Chat',
        email: authUser.email.toString(),
        createdAt: time,
        lastActive: time,
        id: auth.currentUser!.uid,
        isOnline: false,
        pushToken: '');
    return await firestore
        .collection('users')
        .doc(authUser.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: authUser.uid)
        .snapshots();
  }

  // For getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(authUser.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(authUser.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profile_picture/${authUser.uid}$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(authUser.uid)
        .update({'image': me.image});
  }

  // **************** Chat Screen Related APIs ***********************

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversation(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static String getConversation(String id) =>
      authUser.uid.hashCode <= id.hashCode
          ? '${authUser.uid}_$id'
          : '${id}_${authUser.uid}';

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //Send Message
    final Message message = Message(
        msg: msg,
        toID: chatUser.id,
        read: '',
        type: type,
        sent: time,
        fromID: authUser.uid);

    final ref =
        firestore.collection('chats/${getConversation(chatUser.id)}/messages');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'Image'));
  }

  //update read status

  static Future<void> updateMessageReadStatus(Message message) async {
    await firestore
        .collection('chats/${getConversation(message.fromID)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversation(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // Send Chat Image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversation(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //Delete Message
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversation(message.toID)}/messages')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image)
      await storage.refFromURL(message.msg).delete();
  }
}
