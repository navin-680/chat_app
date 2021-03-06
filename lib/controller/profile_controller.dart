import 'dart:io';
import 'package:chatapp/model/profile_model.dart';
import 'package:chatapp/utils/push_notification.dart';
import 'package:chatapp/views/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage firebaseStorage = firebase_storage.FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  final TextEditingController nameText = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var imageFilePath= "".obs;
  File? image;
  RxString? profileUrl="".obs;
  bool isProcessing = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    await get();
    init(ccode: '+91', phone: '7835966564');
  }

  Future<ProfileData> get() async {
    QueryDocumentSnapshot? userDoc = await getDoc();
    if (userDoc != null) {
      return ProfileData.fromJson({
        'uid': userDoc['uid'],
        'name': userDoc['name'],
        'imageUrl': userDoc['imageUrl']
      });
    } else {
    profileUrl!.value= FirebaseAuth.instance.currentUser!.photoURL!;
    nameText.text=FirebaseAuth.instance.currentUser!.displayName!;
      return ProfileData.fromJson(
          {'uid': null, 'name': null, 'imageUrl': null});
    }
  }

  Future<QueryDocumentSnapshot?> getDoc() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final CollectionReference? userDocs = firestore.collection('users');
    QuerySnapshot docs =
    await userDocs!.where('uid', isEqualTo: uid).limit(1).get();
    if(docs.docs.isNotEmpty){
      profileUrl!.value=docs.docs.first['imageUrl'];
      nameText.text=docs.docs.first['name'];
      return docs.docs.first;
    }
    else{
      return null;
    }


  }





  Future<void> init({required String ccode,  required String phone}) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    final QueryDocumentSnapshot? oldUser = await getDoc();
    if (oldUser != null) {
      return await oldUser.reference.update({
        'ccode': ccode,
        'phone': phone,
      });
    } else {
      final String? token = await PushNotifiaction.getToken();
      final CollectionReference userDocs = firestore.collection('users');
       await userDocs.add({
        'uid': uid,
        'ccode': ccode,
        'phone': phone,
        'token': token,
        'name': nameText.text,
        'imageUrl': profileUrl!.value
      });
    }
  }

  Future<void> updateProfile({String? name, File? imagePath}) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (imagePath != null) {
      try {
        firebase_storage.TaskSnapshot r =
        await firebaseStorage.ref('profile/$uid/').putFile(imagePath);
        DocumentSnapshot? documentSnapshot = await getDoc();
        return await documentSnapshot?.reference
            .update({'imageUrl': 'profile/$uid', 'name': name});
      } on firebase_core.FirebaseException catch (e) {
        throw e;
      }
    } else {
      DocumentSnapshot? documentSnapshot = await getDoc();
      return await documentSnapshot?.reference.update({'name': name});
    }
  }

  Future<void> setToken(String token) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    QuerySnapshot _docs = await firestore
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    return await _docs.docs.first.reference.update({'token': token});
  }

  void setImage(ImageSource source) async {
    Get.back();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFilePath.value=pickedFile.path;
     image = File(pickedFile.path);
    }
  }

  void onSubmit() async {
    final String name = nameText.text;
    setProcess(true);

    if (name.isEmpty) return;

    if(image!=null){
      try {
        await updateProfile(name: name, imagePath: image);
        Get.to(()=>ChatList());
      } catch (e) {
        setError("Something went wrong error!");
      }
    }else{
      Get.to(()=>ChatList());
    }

  }

  void setProcess(bool v) => {

  };

  void setError(String error) {
   Get.snackbar("Error", error);
  }
  void onTapImage() {
    scaffoldKey.currentState?.showBottomSheet((context) {
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