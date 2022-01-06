import 'dart:io';

import 'package:chatapp/controller/profile_controller.dart';
import 'package:chatapp/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {


  ProfilePage({Key? key}) : super(key: key);
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: profileController.scaffoldKey,
        appBar: AppBar(
          title: const Text(
            "Account settings",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: size.height * .06),
                    child: Align(
                        child: GestureDetector(
                            child: profileController.image == null && profileController.profileUrl?.value == null
                                ? const CircleAvatar(
                                    radius: 80,
                                    child: Icon(
                                      Icons.person_add,
                                      size: 60,
                                    ))
                                : profileController.image != null
                                    ? Obx(()=> CircleAvatar(
                              maxRadius: 80,
                              child: ClipOval(child: Image.file(File(profileController.imageFilePath.value),height: 200,width: 200,fit: BoxFit.cover,)),
                            ),
                                    )
                                    : Obx(()=> ProfileImage(
                                          path: profileController.profileUrl!.value,
                                          radius: 80,
                                        ),
                                    ),
                            onTap: profileController.onTapImage))),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * .06,
                        vertical: size.height * .05),
                    child: TextField(
                      style: const TextStyle(fontSize: 20),
                      controller: profileController.nameText,
                      cursorColor: Colors.green,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Your Name'),
                    )),
                Container(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * .1,
                        horizontal: size.width * .2),
                    child: profileController.isProcessing
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).indicatorColor)))
                        : RaisedButton(
                            onPressed: profileController.onSubmit,
                            child: Text(
                              'Finish',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ))
              ],
            ),
          ),
        ));
  }
}
