import 'package:chatapp/controller/login_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';


class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                focalRadius: 28,
                colors: [
                  Color(0xFFE9EDEA),
                  Color(0xFFDBE8E2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/otp.png"),
                  width: 250,
                ),
                const SizedBox(
                  height: 100,
                ),

                GestureDetector(
                  onTap: () {
                    loginController.loading.value = true;
                    loginController.signInWithGoogle();
                  },
                  child: Container(
                    height: 60,
                    width: 275,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xff383838),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    child: const Center(
                        child: Text(
                          "Sign In",
                          style:
                          TextStyle(color: Colors.white, fontSize: 22),
                        )),
                  ),
                ),
              ],
            )),
    );
  }
}
