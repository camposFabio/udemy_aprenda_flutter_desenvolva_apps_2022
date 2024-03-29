import 'dart:async';

import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });

    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     List<ChatMessage> lista = snapshot.docs.map((doc) {
    //       return doc.data();
    //     }).toList();
    //     controller.add(lista);
    //   });
    // });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
        id: '',
        text: text,
        createdAt: DateTime.now(),
        userId: user.id,
        userName: user.name,
        userImageUrl: user.imageUrl);

    // ChatMessage => Map<String, dynamic>

    final docRef = await store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .add(msg);

    // final docRef = await store.collection('chat').add({
    //   'text': text,
    //   'createdAt': DateTime.now().toIso8601String(),
    //   'userId': user.id,
    //   'userName': user.name,
    //   'userImageUrl': user.imageUrl,
    // });

    final doc = await docRef.get();
    return doc.data();
  }
//    final data = doc.data()!;

  // Map<String, dynamic> => ChatMessage

  //   return ChatMessage(
  //       id: doc.id,
  //       text: data['text'],
  //       createdAt: DateTime.parse(data['createdAt']),
  //       userId: data['userId'],
  //       userName: data['userName'],
  //       userImageUrl: data['userImageUrl']);
  // }

  // ChatMessage => Map<String, dynamic>
  Map<String, dynamic> _toFirestore(
    ChatMessage msg,
    SetOptions? options,
  ) {
    return {
      'text': msg.text,
      'createdAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageUrl': msg.userImageUrl,
    };
  }

  // Map<String, dynamic> => ChatMessage
  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
        id: doc.id,
        text: doc['text'],
        createdAt: DateTime.parse(doc['createdAt']),
        userId: doc['userId'],
        userName: doc['userName'],
        userImageUrl: doc['userImageUrl']);
  }
}
