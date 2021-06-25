import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/main.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:my_health/service/database_service.dart';
import 'package:my_health/view/screens/login_screen.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;
  bool isVisibleText = true;
  bool isVisibleLoading = false;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthService>(context);
    var dbProvider = Provider.of<Database>(context);

    Future<void> saveUser() async {
      
        _isLoading = true;
        isVisibleText = false;
        isVisibleLoading = true;
        if (nameController.text == "") {
          setState(() {
            _isLoading = false;
            isVisibleText = true;
            isVisibleLoading = false;
          });
          Get.snackbar(
            'Hata',
            'Adınızı Soyadınızı girmeniz gerekmektedir',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        } else if (emailController.text == "") {
          setState(() {
            _isLoading = false;
            isVisibleText = true;
            isVisibleLoading = false;
          });
          Get.snackbar(
            'Hata',
            'E-Posta girmeniz gerekmektedir',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        } else if (passwordController.text == "") {
          setState(() {
            _isLoading = false;
            isVisibleText = true;
            isVisibleLoading = false;
          });
          Get.snackbar(
            'Hata',
            'Şifrenizi girmeniz gerekmektedir',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        } else if (validateEmail(emailController.text) == false) {
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
  

         await authProvider
              .createUserWithEmailandPassword(emailController.text.trim(),
                  passwordController.text.trim(), nameController.text.trim());
              
            if (authProvider.durum == UserCase.OturumAcilmis) {
              dbProvider.email = emailController.text;
              dbProvider.username = nameController.text;
              dbProvider.phone =
                  phoneController.text == '' ? '' : phoneController.text;
              dbProvider.createUser(emailController.text.trim(),
                  nameController.text.trim(), phoneController.text.trim());

              authProvider.durum == UserCase.OturumAcilmis
                  ? Get.to(BottomNav())
                  : _isLoading = false;
            } else {
              setState(() {
                _isLoading = false;
                isVisibleText = true;
                isVisibleLoading = false;
              });
              Get.snackbar(
                'Hata',
                'defaultToast'.tr,
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
                    height: Get.height * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.grey[700].withOpacity(0.6),
                        //border: Border.all(),
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text('Kayıt Ol',
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
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                labelText: 'Ad Soyad *',
                              ),
                              controller: nameController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                labelText: 'E-Posta *',
                              ),
                              controller: emailController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                labelText: 'Tel-No *',
                              ),
                              controller: phoneController,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                labelText: 'Şifre',
                              ),
                              controller: passwordController,
                            ),
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
                                        'Üye Ol',
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
                            GestureDetector(
                              onTap: (){
                                Get.to(LoginScreen());
                              },
                                                          child: Text(
                                          'Zaten Hesabın Var Mı?',
                                          style: TextStyle(color: Colors.white,fontSize: 18),
                                        ),
                            ),
                           
                          ],
                        ),
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

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
}
