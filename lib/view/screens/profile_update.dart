import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:my_health/model/user_model.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileUpdate extends StatefulWidget {
  ProfileUpdate({
    this.user,
  });
  UserModel user;
  @override
  ProfileUpdateState createState() => ProfileUpdateState();
}

class ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isObsecture = true;
  bool isObsecture2 = true;
  bool isObsecture3 = true;
  bool checkBoxValue1 = false;
  bool isVisibleText = true;
  bool isVisibleLoading = false;
  bool _isLoading = false;
  var locale;

  @override
  void initState() {
    super.initState();
  }

  var profileUpdateMap = Map<String, dynamic>();

  Future<void> profileUpdate() async {
    if (nameController.text != "") {
      profileUpdateMap["username"] = nameController.text;
    }
    if (emailController.text != "") {
      profileUpdateMap["email"] = emailController.text;
    }
    if (phoneController.text != "") {
      profileUpdateMap["phone"] = phoneController.text;
    }
   

    try {
      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(widget.user.id)
          .update(profileUpdateMap);
    } catch (e) {
      return e;
    }
  }

  void clear() {
    profileUpdateMap.removeWhere((key, value) => key == "username");
    profileUpdateMap.removeWhere((key, value) => key == "phone");

    nameController.text = '';
    phoneController.text = '';
  }

  bool checkInputs() {
    if (nameController.text == widget.user.username &&
        phoneController.text == widget.user.phone
       )
      return false;
    else
      return true;
  }


  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthService>(context);
 
    void updatePassword(StateSetter setBottomState) {
      setBottomState(() {
        _isLoading = true;
        isVisibleText = false;
        isVisibleLoading = true;
      });
      if (passwordController.text == password2Controller.text &&
          passwordController.text != '') {
        authProvider.oldPassword = oldPasswordController.text.trim();
        authProvider.newPassword = passwordController.text.trim();
        authProvider.email = widget.user.email;
        authProvider.updatePassword().then((value) {
          if (value == true) {
            Get.back();
            Get.snackbar(
              'Başarılı',
              'Şifreniz başarılı bir şekilde değiştirildi',
              backgroundColor: Colors.green,
              colorText: Get.theme.snackBarTheme.actionTextColor,
              backgroundGradient: LinearGradient(
                  colors: [Colors.green[700], Colors.greenAccent]),
            );
            _isLoading = false;
            isVisibleText = true;
            isVisibleLoading = false;
          } else {
            if (value.code == 'wrong-password') {
              Get.back();
              Get.snackbar(
                'Hata',
                'Eski şifrenizi yanlış girdiniz',
                backgroundColor: Colors.red,
                colorText: Get.theme.snackBarTheme.actionTextColor,
                backgroundGradient:
                    LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
              );
              _isLoading = false;
              isVisibleText = true;
              isVisibleLoading = false;
            } else {
              Get.back();
              Get.snackbar(
                'Hata',
                'Lütfen girdiğiniz şifreleri kontrol edin',
                backgroundColor: Colors.red,
                colorText: Get.theme.snackBarTheme.actionTextColor,
                backgroundGradient:
                    LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
              );
              _isLoading = false;
              isVisibleText = true;
              isVisibleLoading = false;
            }
          }
        });
      } else {
        Get.back();
        Get.snackbar(
          'Hata',
          'Lütfen girdiğiniz şifreleri kontrol edin',
          backgroundColor: Colors.red,
          colorText: Get.theme.snackBarTheme.actionTextColor,
          backgroundGradient:
              LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
        );
        _isLoading = false;
        isVisibleText = true;
        isVisibleLoading = false;
      }
    }

    return Scaffold(
       appBar: AppBar(
        title: Text('Profil Güncelle'),
       // automaticallyImplyLeading: false,
        centerTitle: true,),
        body: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(children: [
         
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: nameController = TextEditingController.fromValue(
                      TextEditingValue(
                          text: nameController.text == ""
                              ? widget.user.username == "null"
                                  ? ""
                                  : widget.user.username
                              : nameController.text,
                          selection: TextSelection.collapsed(
                              offset: nameController.text != ""
                                  ? nameController.text.length
                                  : widget.user.username.length))),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    labelText: 'Ad Soyad *'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      color: Colors.grey,
                    ),
                    hintText: widget.user.email,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // CountryCodePicker(
                    //   initialSelection: 'TR',
                    //   favorite: ['+90', 'TR'],
                    //   showCountryOnly: false,
                    //   showOnlyCountryWhenClosed: false,
                    //   alignLeft: false,
                    //   closeIcon: Icon(Icons.close),
                    //   showDropDownButton: true,
                    //   flagWidth: 20,
                    //   textStyle: TextStyle(fontSize: 15),
                    //   dialogBackgroundColor: Get.theme.scaffoldBackgroundColor,
                    //   backgroundColor: Get.theme.scaffoldBackgroundColor,
                    // ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(12),
                        ],
                        controller: phoneController =
                            TextEditingController.fromValue(TextEditingValue(
                                text: phoneController.text == ""
                                    ? widget.user.phone == ""
                                        ? ""
                                        : widget.user.phone
                                    : phoneController.text,
                                selection: TextSelection.collapsed(
                                    offset: phoneController.text != ""
                                        ? phoneController.text.length
                                        : widget.user.phone.length))),
                        decoration: InputDecoration(
                          hintText: phoneController.text == ""
                              ? widget.user.phone == ""
                                  ? 'Telefon'
                                  : widget.user.phone
                              : phoneController.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
              
             
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlatButton(
                    onPressed: () {
                      isObsecture = true;
                      isObsecture2 = true;
                      isObsecture3 = true;
                      passwordController.text = '';
                      password2Controller.text = '';
                      oldPasswordController.text = '';
                      Get.bottomSheet(
                          StatefulBuilder(builder: (context, setBottomState) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Divider(
                                    endIndent: 10,
                                  )),
                                  Text(
                                    'Şifre Değiştir',
                                    style: TextStyle(
                                        color: Colors.green[900].withOpacity(0.5),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    indent: 10,
                                  )),
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  obscureText: isObsecture3,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Mevcut Şifre',
                                      suffixIcon: isObsecture3 == true
                                          ? IconButton(
                                              icon: Icon(Icons.visibility,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture3 = false;
                                                });
                                              })
                                          : IconButton(
                                              icon: Icon(Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture3 = true;
                                                });
                                              })),
                                  controller: oldPasswordController,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  obscureText: isObsecture,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      labelText:'Yeni Şifre *',
                                      suffixIcon: isObsecture == true
                                          ? IconButton(
                                              icon: Icon(Icons.visibility,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture = false;
                                                });
                                              })
                                          : IconButton(
                                              icon: Icon(Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture = true;
                                                });
                                              })),
                                  controller: passwordController,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  obscureText: isObsecture2,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      labelText: 'Yeni Şifre Tekrar *',
                                      suffixIcon: isObsecture2 == true
                                          ? IconButton(
                                              icon: Icon(Icons.visibility,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture2 = false;
                                                });
                                              })
                                          : IconButton(
                                              icon: Icon(Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .accentIconTheme
                                                      .color),
                                              onPressed: () {
                                                setBottomState(() {
                                                  isObsecture2 = true;
                                                });
                                              })),
                                  controller: password2Controller,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: Get.width,
                                  height: Get.height * 0.055,
                                  child: RaisedButton(
                                    onPressed: _isLoading == true
                                        ? null
                                        : () => updatePassword(setBottomState),
                                    color: Colors.green[900].withOpacity(0.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: isVisibleText,
                                          child: Text(
                                            'Kaydet',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Visibility(
                                            visible: isVisibleLoading,
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }), backgroundColor: Get.theme.scaffoldBackgroundColor);
                    },
                    child: Text(
                      'Şifre Değiştir',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900].withOpacity(0.5),),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.06,
                child: RaisedButton(
                  onPressed: () async {
                    if (checkInputs() == false) {
                      Get.snackbar(
                        'Eksik Bilgi',
                        'Profilinizi güncellemek için en az bir değişiklik yapmalısınız',
                        backgroundColor: Colors.amber,
                        colorText: Get.theme.snackBarTheme.actionTextColor,
                        backgroundGradient: LinearGradient(
                            colors: [Colors.amber[400], Colors.amberAccent]),
                      );
                    } else {
                      profileUpdate();

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      clear();
                      Get.back(result: true);
                      Get.snackbar(
                        'Başarılı',
                        'Profiliniz başarılı bir şekilde güncellendi',
                        backgroundColor: Colors.green,
                        colorText: Get.theme.snackBarTheme.actionTextColor,
                        backgroundGradient: LinearGradient(
                            colors: [Colors.green[700], Colors.greenAccent]),
                      );
                    }
                  },
                  color: Colors.green[900].withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kaydet',
                        style: TextStyle(color: Colors.white),
                      ),
                      Visibility(
                          visible: false,
                          child: Container(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ]),
          ),
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
