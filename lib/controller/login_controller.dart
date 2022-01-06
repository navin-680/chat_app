import 'dart:convert';

import 'package:chatapp/controller/profile_controller.dart';
import 'package:chatapp/model/profile_model.dart';
import 'package:chatapp/views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  var loading = false.obs;
  GoogleSignInAccount? currentUser;
  var contactText = ''.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  var username="".obs;
  var userProfilePhoto="".obs;




  var isSend = false.obs;
  bool isProcessing = false;

  String countryCode="";
  String verificationId="";
  int resendToken=0;





   Future<int> loginStatus() async {
    /*if (user == null) {
      return 0;
    } else {
      final ProfileData userProfile = await profile.get();
      if (userProfile.name == null) {
        return 1;
      } else {
        return 3;
      }
    }*/
     return 0;
  }







  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    currentUser= await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await currentUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
      Get.to(()=>ProfilePage(username: value.user?.displayName!,profileUrl: value.user?.photoURL!,))
    });

  }


  //Future<void> handleSignOut() => _googleSignIn.disconnect();

  void setProcessing(bool v) {
    //setState(() => _isProcessing = v);
  }

  void setError(String error) {
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        error.replaceAll('-', '\t'),
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 20),
    );
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }


}
