
import 'dart:io';

import 'package:chatapp/model/profile_model.dart';
import 'package:chatapp/utils/app_user.dart';
import 'package:chatapp/utils/push_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  final TextEditingController nameText = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  File image=File("");
  String profileUrl="";

  bool isProcessing = false;

  Future<ProfileData> get() async {
    QueryDocumentSnapshot? userDoc = await getDoc();
    if (userDoc != null) {
      return ProfileData.fromJson({
        'uid': userDoc['uid'],
        'name': userDoc['name'],
        'imageUrl': userDoc['imageUrl']
      });
    } else {
      return ProfileData.fromJson(
          {'uid': null, 'name': null, 'imageUrl': null});
    }
  }

  Future<QueryDocumentSnapshot> getDoc() async {
    final String uid = FirebaseAuth.instance.currentUser.uid;
    final CollectionReference? userDocs = firestore.collection('users');
    QuerySnapshot docs =
    await userDocs!.where('uid', isEqualTo: uid).limit(1).get();
    if (docs.docs.isNotEmpty) {
      return docs.docs.first;
    } else {
      return null;
    }
  }

  Future<void> init({String ccode,  String phone}) async {
    final String uid = FirebaseAuth.instance.currentUser.uid;

    final QueryDocumentSnapshot? oldUser = await getDoc();
    if (oldUser != null) {
      return await oldUser.reference.update({
        'ccode': ccode,
        'phone': phone,
      });
    } else {
      final String token = await PushNotifiaction.getToken();
      final CollectionReference userDocs = firestore.collection('users');

      // return await userDocs.add({
      //   'uid': uid,
      //   'ccode': ccode,
      //   'phone': phone,
      //   'token': token,
      //   'name': null,
      //   'imageUrl': null
      // });
    }
  }

  // Future<void> update({String? name, File image}) async {
  //   final String? uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (image != null) {
  //     try {
  //       firebase_storage.TaskSnapshot r =
  //       await _firebaseStorage.ref('profile/$uid/').putFile(image);
  //       DocumentSnapshot? documentSnapshot = await getDoc();
  //       return await documentSnapshot!.reference
  //           .update({'imageUrl': 'profile/$uid', 'name': name});
  //     } on firebase_core.FirebaseException catch (e) {
  //       throw e;
  //     }
  //   } else {
  //     DocumentSnapshot? documentSnapshot = await getDoc();
  //     return await documentSnapshot!.reference.update({'name': name});
  //   }
  // }

  Future<void> setToken(String token) async {
    final String uid = FirebaseAuth.instance.currentUser.uid;

    QuerySnapshot _docs = await firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    return await _docs.docs.first.reference.update({'token': token});
  }

  void setImage(ImageSource source) async {
    //Navigator.pop(context);
    final pickedFile = await picker.getImage(source: source);
   // if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  void onSubmit() async {
    final String name = nameText.text;
    setProcess(true);

    if (name.isEmpty) return;
    try {
     // await _profile!.update(name: name, image: _image);
     // Navigator.pushNamedAndRemoveUntil(context, '/chatList', (route) => false);
    } catch (e) {
      setError("Something went wrong error!");
    }
  }

  void setProcess(bool v) => {

  };

  void setError(String error) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        error,
        //error.replaceAll('-', '\t'),
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 20),
    );
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }
  void onTapImage() {
    scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        //color: Colors.grey,
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () => setImage(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () => setImage(ImageSource.gallery),
            )
          ],
        ),
      );
    }, backgroundColor: Colors.white, elevation: 10);
  }
}