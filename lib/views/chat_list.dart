import 'package:chatapp/controller/chat_list_controller.dart';
import 'package:chatapp/model/chat_data_model.dart';
import 'package:chatapp/utils/app_user.dart';
import 'package:chatapp/views/profile.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login.dart';
enum AppBarAction { Profile, SignOut }
class ChatList extends StatelessWidget {
   ChatList({Key? key}) : super(key: key);
  ChatListController chatListController=Get.put(ChatListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: chatListController.onTapFloatingActionBtn,
          child: const Icon(Icons.add),
        ),
        appBar:AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Chat List",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: chatListController.onTapSearch,
            ),
            PopupMenuButton<AppBarAction>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (v) async {
                if (v == AppBarAction.Profile) {

                  Get.to(()=>ProfilePage());
                } else {
                  await AppUser.logout();
                  Get.offAll(()=>LoginPage());

                }
              },
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<AppBarAction>>[
                const PopupMenuItem(
                  value: AppBarAction.Profile,
                  child: Text('Account settings'),
                ),
                const PopupMenuItem(
                  value: AppBarAction.SignOut,
                  child: Text('Sign out'),
                )
              ],
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: StreamBuilder<List<ChatData>>(
            stream: chatListController.load(),
            builder:
                (BuildContext context, AsyncSnapshot<List<ChatData>> snapshot) {
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
                      Text("No active chatroom")
                    ],
                  ),
                );
              }
              return ListView(
                children: snapshot.data!.map((p) {
                  return ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ProfileImage(
                      path: p.imageUrl,
                    ),
                    subtitle: Text(p.subtitle!),
                    title: Text(
                      p.name!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(chatListController.toTimeString(p.lastUpdate!)),
                        Visibility(
                            visible: p.unreadCount! > 0,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              radius: 15,
                              child: Text(p.unreadCount.toString()),
                            ))
                      ],
                    ),
                    onTap: () => chatListController.onChatListItemTap(p),
                  );
                }).toList(),
              );
            },
          ),
        ));
  }








}
