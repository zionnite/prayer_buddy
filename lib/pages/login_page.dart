import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prayer_buddy/controllers/login_controller.dart';

import '../bottom_navigation.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginSignupController = LoginController().getXID;

  late String email;
  late String password;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 130.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                      child: const Text('Hey,',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 195.0, 0.0, 0.0),
                      child: const Text('Welcome',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        alignment: const Alignment(1.0, 0.0),
                        padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                        child: const InkWell(
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                isProcessing = true;
                              });
                              String result = await loginSignupController.login(
                                  email, password);

                              Future.delayed(const Duration(seconds: 4), () {
                                if (result == "success") {
                                  showSnackBar("Redirecting...",
                                      "Login successful", Colors.green);
                                  Future.delayed(
                                    const Duration(seconds: 4),
                                    () {
                                      Get.offAll(
                                        () => Nav(),
                                        transition:
                                            Transition.leftToRightWithFade,
                                      );
                                    },
                                  );
                                } else if (result == "fail_01") {
                                  showSnackBar(
                                      "Oops!!",
                                      "User not found or Password is incorrect!",
                                      Colors.red);
                                } else if (result == "fail_02") {
                                  showSnackBar(
                                      "Oops!!",
                                      "Email Or Password can not be empty!",
                                      Colors.red);
                                } else {
                                  showSnackBar(
                                      "Oops!!",
                                      "Unidentified error occur",
                                      Colors.deepOrange);
                                }

                                setState(() {
                                  isProcessing = false;
                                });
                              });
                              //Navigator.pushNamed(context, Nav.id);
                            },
                            child: Center(
                              child: (isProcessing)
                                  ? const Text(
                                      'Loading...',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    )
                                  : const Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  )),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'New to PrayerBuddy ?',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  const SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SignupPage.id);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  showSnackBar(String title, String msg, Color backgroundColor) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
