import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/model/user_model.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:my_health/service/database_service.dart';
import 'package:my_health/view/screens/login_screen.dart';
import 'package:my_health/view/screens/profile_update.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthService>(context);
    var dbProvider = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hesap Detayları'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 7.0),
            child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                        height: Get.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Çıkış yapmak istediğinizden emin misiniz?',
                              style: TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      _resetAndOpenPage();
                                      authProvider.signOut();
                                    },
                                    child: Text('Evet'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text('Vazgeç',
                                        style: TextStyle(color: Colors.white)),
                                    color: Get.theme.accentColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    //  barrierColor: Colors.yellowAccent
                  );
                },
                child: Icon(Icons.logout)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
                width: Get.width,
                height: 200,
                child: Image.asset('assets/images/profile.png')),
            StreamBuilder<Event>(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("users")
                    .child(authProvider.userId ?? "")
                    .onValue,
                builder: (context, event) {
                  if (event.hasData == true &&
                      event.connectionState == ConnectionState.active) {
                    UserModel user = UserModel();
                    
                    var gelenUser = event.data.snapshot.value;

                    if (gelenUser != null) {

                      // gelenUser.forEach((key,value){

                      user = UserModel.fromJson(gelenUser);
                      // });
                     
                      return buildColumn(context, user);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context, UserModel user) {
    var authProvider = Provider.of<AuthService>(context);
    var dbProvider = Provider.of<Database>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: () {
                  Get.to(ProfileUpdate(user: user),
                      transition: Transition.rightToLeft);
                },
                child: Row(
                  children: [
                    Text(
                      "Hesap Ayarları",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: Get.width * 0.005),
                    RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.edit,
                          size: 19,
                        )),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              hintText: user.username,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.grey,
              ),
              hintText: user.email,
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.grey,
              ),
              hintText: user.phone,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Container(
            width: Get.width,
            height: Get.height * 0.07,
            child: RaisedButton(
              onPressed: () {
                deleteAccount(dbProvider, authProvider, user);
              },
              color: Colors.red[900],
              child: Text(
                'Hesabımı Sil',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _resetAndOpenPage() {
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ModalRoute.withName('/'),
    );
  }

  deleteAccount(dbProvider, authProvider, UserModel user) {
    Get.bottomSheet(
        Container(
            height: Get.height < 500 ? Get.height * 0.4 : Get.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Hesabınız kalıcı olarak silinecektir. Bu işlem geri alınamaz. Onaylıyor musunuz?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          dbProvider.createDeleted();
                          authProvider.deleteUser();
                          FirebaseDatabase.instance
                              .reference()
                              .child("users")
                              .child(user.id)
                              .remove();

                          authProvider.userId = "";
                          Get.snackbar(
                            'Başarılı',
                            'Hesabınız başarılı bir şekilde silindi',
                            backgroundColor: Colors.green,
                            colorText: Get.theme.snackBarTheme.actionTextColor,
                            backgroundGradient: LinearGradient(colors: [
                              Colors.green[700],
                              Colors.greenAccent
                            ]),
                          );
                          _resetAndOpenPage();
                        },
                        child: Text('Evet'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('Vazgeç',
                              style: TextStyle(color: Colors.white)),
                          color: Get.theme.accentColor),
                    ],
                  ),
                )
              ],
            )),
        backgroundColor: Get.theme.scaffoldBackgroundColor);
  }
}
