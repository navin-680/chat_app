import 'dart:async';

import 'package:chatapp/controller/chat_list_controller.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class ChatController extends GetxController{
  String? clId;
  String? reciver;
  int? _limit = 0;
  final String? sender = FirebaseAuth.instance.currentUser?.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatListController? chatListController = Get.put(ChatListController());
  final StreamController<List<Message>> _chatStreamController = StreamController<List<Message>>();
  final TextEditingController textMsg = TextEditingController();
  final ScrollController controller = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void init({String? clId, String? reciver}) async {
    this.clId = clId;
    this.reciver = reciver;
    if (clId == null) {
      this.clId = await chatListController!.getClid(reciver!);
    }

    loadMore();
  }

  void scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {}
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {
      // To implement lazy-load
    }
  }

  void scrollToEnd() {
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  void send() async {
    String texts = textMsg.text;
    if (texts.isEmpty) return;
    textMsg.clear();
    await sendText(texts);
    scrollToEnd();
  }


  Future<void> sendText(String text) async {
    if (clId == null) {
      clId = await chatListController!.create(reciver!, text);
      loadMore();
    }
    final CollectionReference _messageRef = _firestore.collection('message');
    final CollectionReference _chatListRef = _firestore.collection('chatList');
    _messageRef.add({
      'clId': clId,
      'sender': sender,
      'reciver': reciver,
      'text': text,
      'isRead': false,
      'sendTs': DateTime.now(),
    });
    return _chatListRef.doc(clId).get().then((doc) {
      final int i = doc['ids'].indexOf(reciver);
      var users = doc['users'];
      users[i]['unreadCount']++;
      doc.reference.update(
          {'users': users, 'subtitle': text, 'lastUpdate': DateTime.now()});
    });
  }

  List<Message> toMessages(QuerySnapshot data) {
    List<Message> messages = [];
    if (data.docs.isNotEmpty) {
      DateTime dateTime = data.docs.first['sendTs'].toDate();
      int numDays = countDays(DateTime.now(), dateTime);
      String text;
      switch (numDays) {
        case 0:
          text = 'TODAY';
          break;
        case 1:
          text = 'YESTERDAY';
          break;
        default:
          text = DateFormat('MMMM d,yyyy').format(dateTime);
      }

      messages.add(Message.fromJson({'text': text, 'isMessage': false}));

      for (var doc in data.docs) {
        final DateTime msgDatetime = doc['sendTs'].toDate();
        numDays = countDays(dateTime, msgDatetime);

        if (numDays != 0) {
          numDays = countDays(DateTime.now(), msgDatetime);
          String text;
          switch (numDays) {
            case 0:
              text = 'TODAY';
              break;
            case 1:
              text = 'YESTERDAY';
              break;
            default:
              text = DateFormat('MMMM d,yyyy').format(msgDatetime);
          }
          messages.add(Message.fromJson({'text': text, 'isMessage': false}));
        }
        messages.add(Message.fromJson({
          'id': doc.id,
          'clId': doc['clId'],
          'text': doc['text'],
          'time': doc['sendTs'],
          'isRead': doc['isRead'],
          'isMessage': true,
          'isSend': doc['sender'] == sender
        }));
        dateTime = msgDatetime;
      }
    }
    return messages;
  }
  int countDays(DateTime first, DateTime second) {
    final DateTime firstInDate =
    DateTime.parse(DateFormat("yyyy-MM-dd").format(first));
    final DateTime secondInDate =
    DateTime.parse(DateFormat("yyyy-MM-dd").format(second));
    return firstInDate.difference(secondInDate).inDays;
  }

  void loadMore() {
    if (clId == null) {
      _chatStreamController.add([]);
    } else {
      final CollectionReference chatList = _firestore.collection('message');
      chatList
          .where('clId', isEqualTo: clId)
          .orderBy('sendTs', descending: false)
      //.limit(_limit)
      //.startAt()
          .snapshots()
          .asyncMap((data) {
        return toMessages(data);
      }).listen((r) {
        _chatStreamController.add(r);
      });
    }
  }

  Stream<List<Message>> snapsshots() {
    return _chatStreamController.stream;
  }
}