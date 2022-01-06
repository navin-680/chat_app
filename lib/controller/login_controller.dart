import 'package:chatapp/controller/profile_controller.dart';
import 'package:chatapp/model/profile_model.dart';
import 'package:chatapp/utils/app_user.dart';
import 'package:chatapp/views/home.dart';
import 'package:chatapp/views/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController {
  var loading = false.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ProfileController profile = Get.put(ProfileController());
  final User user = FirebaseAuth.instance.currentUser;


  var isSend = false.obs;
  bool isProcessing = false;

  String countryCode="";
  String verificationId="";
  int resendToken=0;

  final TextEditingController phoneText = TextEditingController();
  final TextEditingController codeText = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


   Future<int> loginStatus() async {
    if (user == null) {
      return 0;
    } else {
      final ProfileData userProfile = await profile.get();
      if (userProfile.name == null) {
        return 1;
      } else {
        return 3;
      }
    }
  }

  void onTapSend() async {
    final String phone = phoneText.text;
    if (phone.isEmpty) return;
    setProcessing(true);
    await auth.verifyPhoneNumber(
        phoneNumber: countryCode + phoneText.text,
        //phoneNumber: '+16505556789',
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential)  {
          setProcessing(true);
          auth.signInWithCredential(phoneAuthCredential).then((u) async {
            await profile.init(ccode: countryCode, phone: phone);
            setProcessing(false);
            Get.to(()=>ProfilePage());
            //Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
          }).catchError((e) {
            setError(e.code);
            setProcessing(false);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setError(e.code);
          setProcessing(false);
        },
        codeSent: (String verificationId, int resendToken) {
          verificationId = verificationId;
          resendToken = resendToken;
          setProcessing(false);
          isSend.value = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  void onTapVerify() async {
    final String phone = phoneText.text;
    final String code = codeText.text;
    if (code.length != 6) return;
    setProcessing(true);
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    auth.signInWithCredential(phoneAuthCredential).then((u) async {
      await profile.init(ccode: countryCode, phone: phone);
      setProcessing(false);
     // Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    }).catchError((e) {
      setError(e.code);
      setProcessing(false);
    });

    // _addUser(await _auth.signInWithCredential(phoneAuthCredential));
  }

  void onTapResend() {
    setProcessing(false);
  //  setState(() => _isSend = false);
  }

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
