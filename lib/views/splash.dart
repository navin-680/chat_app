import 'package:chatapp/utils/app_user.dart';
import 'package:chatapp/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_list.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 2),
        () => {
              AppUser.loginStatus().then((s) {
                switch (s) {
                  case 0:
                    Get.offAll(()=>LoginPage());
                    break;
                  case 1:
                    Get.offAll(()=>ProfilePage());

                    break;
                  default:
                    Get.offAll(()=>ChatList());
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
