import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  var messageController = TextEditingController();
  final controller = ScrollController();

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
      return docRef.set(message);
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
}
