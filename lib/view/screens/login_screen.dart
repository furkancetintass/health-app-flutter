import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/main.dart';
import 'package:my_health/model/user_model.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:my_health/view/screens/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController emailForgotten = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool isVisibleText = true;
  bool isVisibleLoading = false;
  bool isVisibleTextForgotten = true;
  bool isVisibleLoadingForgotten = true;
  bool isObsecture = true;


  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthService>(context);
    Future<void> saveUser() async {
      _isLoading = true;
      isVisibleText = false;
      isVisibleLoading = true;
      if (emailController.text == "" || passwordController.text == "") {
        setState(() {
          _isLoading = false;
          isVisibleText = true;
          isVisibleLoading = false;
        });

        Get.snackbar(
          'Hata',
          'Lütfen bilgilerinizi kontrol edin',
          backgroundColor: Colors.red,
          colorText: Get.theme.snackBarTheme.actionTextColor,
          backgroundGradient:
              LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
        );
      } else if (validateEmail(emailController.text.trimRight()) == false) {
        setState(() {
          _isLoading = false;
          isVisibleText = true;
          isVisibleLoading = false;
        });
        Get.snackbar(
          'Hata',
          'Geçersiz e-posta',
          backgroundColor: Colors.red,
          colorText: Get.theme.snackBarTheme.actionTextColor,
          backgroundGradient:
              LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
        );
      } else {
        authProvider.email = emailController.text.trimRight();
        authProvider.password = passwordController.text.trim();

        await authProvider.signInUserWithEmailandPassword(
          emailController.text.trimRight(),
          passwordController.text.trim(),
        );

        if (authProvider.durum == UserCase.OturumAcilmis) {
          Get.to(BottomNav(userId: authProvider.userId,));
        } else {
          setState(() {
            _isLoading = false;
            isVisibleText = true;
            isVisibleLoading = false;
          });
          Get.snackbar(
            'Hata',
            'Lütfen bilgilerinizi kontrol edin',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        }
      }
    }

    return Scaffold(
        body: Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.PNG'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(scrollDirection: Axis.vertical, slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height * 0.6,
                    decoration: BoxDecoration(
                        color: Colors.grey[700].withOpacity(0.6),
                        //border: Border.all(),
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text('Giriş Yap',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800])),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.grey,
                              ),
                              labelText: 'E-Posta',
                            ),
                            controller: emailController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            obscureText: isObsecture,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                labelText: 'Şifre',
                                suffixIcon: isObsecture == true
                                    ? IconButton(
                                        icon: Icon(Icons.visibility_off,
                                            color: Theme.of(context)
                                                .accentIconTheme
                                                .color),
                                        onPressed: () {
                                          setState(() {
                                            isObsecture = false;
                                          });
                                        })
                                    : IconButton(
                                        icon: Icon(Icons.visibility,
                                            color: Theme.of(context)
                                                .accentIconTheme
                                                .color),
                                        onPressed: () {
                                          setState(() {
                                            isObsecture = true;
                                          });
                                        })),
                            controller: passwordController,
                          ),
                          forgotPasswordWidget(),
                          SizedBox(height: 30),
                          Container(
                            width: Get.width,
                            height: Get.height * 0.07,
                            child: RaisedButton(
                              onPressed: _isLoading == true ? null : saveUser,
                              color: Colors.black.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: isVisibleText,
                                    child: Text(
                                      'Giriş Yap',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Visibility(
                                      visible: isVisibleLoading,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          //backgroundColor: Colors.white,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: Get.width,
                            height: Get.height * 0.07,
                            child: RaisedButton(
                              onPressed: () {
                                Get.to(RegisterPage());
                              },
                              color: Colors.black,
                              child: Text(
                                'Üye Ol',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    ));
  }

  Widget forgotPasswordWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
            onPressed: () {
              Get.bottomSheet(
                StatefulBuilder(builder: (context, setBottomState) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      height: Get.height * 0.7,
                      color: Get.theme.scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Şifremi Unuttum',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  controller: emailForgotten,
                                  style: TextStyle(fontSize: 14),
                                  cursorColor: Colors.blue,
                                  decoration: InputDecoration(
                                    labelText: 'E-Posta',
                                    labelStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              RaisedButton(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Container(
                                  width: Get.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: isVisibleTextForgotten,
                                        child: Text(
                                          'Gönder',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Visibility(
                                          visible: isVisibleLoadingForgotten,
                                          child: Container(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              backgroundColor: Colors.white,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                disabledColor: Colors.grey,
                                // onPressed: _isLoadingForgotten ==
                                //         true
                                //     ? null
                                //     : () => sendForgottenPassword(
                                //         setBottomState),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                enableDrag: true,
              );
            },
            child: Text(
              'Şifremi Unuttum',
              style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}
