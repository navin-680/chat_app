import 'package:chatapp/utils/app_user.dart';
import 'package:chatapp/views/profile.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 3),
        () => {
              AppUser.loginStatus().then((s) {
                switch (s) {
                  case 0:
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) {
                      return LoginPage();
                    }), (route) => false);
                    break;
                  case 1:
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) {
                      return ProfilePage();
                    }), (route) => false);
                    break;
                  default:
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) {
                      return ProfilePage();
                    }), (route) => false);
                }
              })
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: const Center(
          child: Image(image: AssetImage("assets/images/splash_logo.png"))));
}
