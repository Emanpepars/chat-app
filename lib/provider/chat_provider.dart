import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/message_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class ChatProvider extends ChangeNotifier {
  var messageController = TextEditingController();
  final controller = ScrollController();

  CollectionReference<MessageModel> getMessageCollection() {
    return FirebaseFirestore.instance.collection('Messages').withConverter(
          fromFirestore: (snapshot, _) =>
              MessageModel.fromJson(snapshot.data()!),
          toFirestore: (message, options) => message.toJson(),
        );
  }

  Stream<QuerySnapshot<MessageModel>> getMessagesFromFireStore() {
    var collection = getMessageCollection();
    return collection.orderBy("date", descending: true).snapshots();
  }

  updateMessage(String id, MessageModel message) {
    return getMessageCollection().doc(id).update(
          message.toJson(),
        );
  }

  void addMessageFireBase(String value, args) {
    CollectionReference<MessageModel> getMessageCollection() {
      return FirebaseFirestore.instance.collection('Messages').withConverter(
            fromFirestore: (snapshot, _) =>
                MessageModel.fromJson(snapshot.data()!),
            toFirestore: (message, options) => message.toJson(),
          );
    }

    Future<void> addMessage(MessageModel message) {
      var collection = getMessageCollection();
      var docRef = collection.doc();
      message.id = message.userId;
      return docRef
          .set(message)
          .then((value) => sendPushNotification(args, message.message));
    }

    addMessage(
      MessageModel(
        message: value,
        date: DateTime.now(),
        id: args.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        friendId: args.id,
      ),
    );
    messageController.clear();
    controller.animateTo(0,
        duration: const Duration(seconds: 2), curve: Curves.easeIn);
    notifyListeners();
  }

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then(
      (t) {
        if (t != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'push_token': t,
          });
          log('Push Token: $t');
        }
      },
    );

    // for handling foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');

    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    // });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      UserModel friendModel, String msg) async {
    try {
      final body = {
        "to": friendModel.pushToken,
        "notification": {
          "title": friendModel.name,
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAoM67dP0:APA91bFRlvG6edWHA71n3Lp5qKOmHZhAlBhbGv46UpvSheMlwgG_MLcZwD2nui_vWw3Kcm4r6er53Prcku9GJOFMOOOMS_4OdclHyQpGtPR_TbJgDzR_oPnxAJ9n8SDdBxlKVo7S0BRV'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
