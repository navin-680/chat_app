import 'package:chatapp/views/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';



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
      Get.to(()=>ProfilePage())
    });

  }



}
