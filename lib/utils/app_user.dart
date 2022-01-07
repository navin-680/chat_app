import 'package:firebase_auth/firebase_auth.dart';


class AppUser {
  static final User? user = FirebaseAuth.instance.currentUser;



  static Future<int> loginStatus() async {
    if (user == null) {
      return 0;
    } else {

      if (user!.displayName == null) {
        return 1;
      } else {
        return 3;
      }
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
