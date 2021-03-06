import 'package:bubble/bubble.dart';
import 'package:chatapp/controller/chat_controller.dart';
import 'package:chatapp/model/message_model.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {

  final String? name;
  final String? imageUrl;
  String? clId;
  final String? reciver;

  ChatPage({Key? key,this.reciver, this.name, this.imageUrl, this.clId}): super(key: key);
ChatController chatController=Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    chatController.init(clId: clId,reciver: reciver);
    final Size size = MediaQuery.of(context).size;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final double px = 1 / pixelRatio;

    final BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: const BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );

    final BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: const Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: const BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title:  Text(
          name!,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ProfileImage(
              path: imageUrl!,
            ),
          )
        ],
        backgroundColor: Colors.white,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: SizedBox(
                  height: double.infinity,
                  child: StreamBuilder<List<Message>>(
                    stream: chatController.snapsshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Message>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.error_outline),
                              Text("Something went wrong")
                            ],
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.error_outline),
                              Text("No chat yet")
                            ],
                          ),
                        );
                      }
                      return ListView(
                        controller: chatController.controller,
                        children: snapshot.data!.map((m) {
                          if (!m.isMessage!) {
                            return Bubble(
                              margin: const BubbleEdges.only(top: 10),
                              alignment: Alignment.center,
                              color: const Color.fromRGBO(212, 234, 244, 1.0),
                              child: Text(m.text!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11.0)),
                            );
                          }
                          final DateTime dateTime = m.time!.toDate();
                          if (!m.isSend! & !m.isRead!) m.setAsRead();
                          return Bubble(
                              margin: m.isSend!
                                  ? const BubbleEdges.only(right: 10)
                                  : const BubbleEdges.only(left: 10),
                              style: m.isSend! ? styleMe : styleSomebody,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.text!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        DateFormat('K:mm a').format(dateTime),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                      Visibility(
                                        visible: m.isSend! & m.isRead!,
                                        child: const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.blue,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ));
                        }).toList(),
                      );
                    },
                  ))),
          Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListTile(
                  title: TextField(
                    onSubmitted: (v) => chatController.send(),
                    scrollPadding: const EdgeInsets.all(20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * .001,
                          horizontal: size.height * .03),
                      hintText: 'Type a message',
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    controller: chatController.textMsg,
                  ),
                  trailing: GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        radius: 25,
                        child: const Icon(Icons.send)),
                    onTap: chatController.send,
                  ))),
        ],
      ),
    );
  }
}
