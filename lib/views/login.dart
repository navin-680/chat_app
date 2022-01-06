import 'package:chatapp/controller/login_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';


class LoginPage extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Widget _sendOtp = Column(
      children: [
        Container(
          child: Text('OTP Verifiaction',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1),
        ),
        Container(
          padding: EdgeInsets.only(top: size.height * .02),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              text: 'We will send',
              children: [
                TextSpan(
                    text: '\tOne Time Password',
                    children: [
                      TextSpan(
                          text: '\non this number.',
                          style: Theme.of(context).textTheme.bodyText1)
                    ],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black))
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              top: size.height * .05, bottom: size.height * .01),
          child: Text(
            'Enter Mobile Number',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * .1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: CountryCodePicker(
                      padding: EdgeInsets.only(right: 10),
                      initialSelection: 'IN',
                      flagWidth: 40,
                      textStyle: TextStyle(fontSize: 20),
                      onInit: (v) => loginController.countryCode = v.dialCode,
                      onChanged: (v) => loginController.countryCode = v.dialCode,
                    )),
                Flexible(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.green,
                      style: TextStyle(fontSize: 20),
                      controller: loginController.phoneText,
                      decoration: InputDecoration(

                        //hoverColor: Colors.grey,
                      ),
                    ))
              ],
            )),
        Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * .02, horizontal: size.width * .3),
            child: loginController.isProcessing
                ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).indicatorColor)))
                : RaisedButton(
              onPressed: loginController.onTapSend,
              child: Text(
                'Send',
                style: Theme.of(context).textTheme.button,
              ),
            ))
      ],
    );

    Widget _verifyOtp = Column(
      children: [
        Container(
          child: Text('OTP Verifiaction',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1),
        ),
        Container(
          padding: EdgeInsets.only(
              top: size.height * .04, bottom: size.height * .02),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              text: 'Enter OTP send to',
              children: [
                TextSpan(
                    text: '\t$loginController.countryCode\t${loginController.phoneText?.text}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black))
              ],
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * .2),
            child: PinInputTextField(
                controller: loginController.codeText,
                pinLength: 6,
                decoration: UnderlineDecoration(
                  colorBuilder:
                  PinListenColorBuilder(Colors.green, Colors.grey),
                ))),
        Container(
          padding: EdgeInsets.only(top: size.height * .05),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Didn't recive the OTP?",
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                      text: '\tResend',
                      recognizer: TapGestureRecognizer()..onTap = loginController.onTapResend,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * .02, horizontal: size.width * .3),
            child: loginController.isProcessing
                ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).indicatorColor)))
                : RaisedButton(
              onPressed: loginController.onTapVerify,
              child: Text(
                'Verify',
                style: Theme.of(context).textTheme.button,
              ),
            ))
      ],
    );
    return SafeArea(
      child: Scaffold(

          backgroundColor:const Color(0xFFF2F7F5),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  SizedBox(
                    height: size.height * .25,
                    child: Image.asset('assets/images/otp.png'),
                  ),
                  Obx(()=> AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        child: loginController.isSend.value ? _verifyOtp : _sendOtp),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
