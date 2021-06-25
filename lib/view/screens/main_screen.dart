import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/model/user_info_model.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:my_health/view/screens/beslenme.dart';
import 'package:my_health/view/screens/create_data.dart';
import 'package:my_health/view/screens/training.dart';
import 'package:my_health/view_model/user_helper_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var userHelperProvider = Provider.of<UserHelperProvider>(context);

    var authProvider = Provider.of<AuthService>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  icon: Column(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                  ),
                  Text('Beslenme', style: TextStyle(color: Colors.white))
                ],
              )),
              Tab(
                  icon: Column(
                children: [
                  Icon(
                    CupertinoIcons.home,
                    color: Colors.white,
                  ),
                  Text('Ana Sayfa', style: TextStyle(color: Colors.white))
                ],
              )),
              Tab(
                  icon: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                  ),
                  Text('Spor', style: TextStyle(color: Colors.white))
                ],
              )),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Beslenme(),
            buildHome(authProvider,userHelperProvider),
            Training()
          ],
          
        ),
      ),
    );
  }

  StreamBuilder<Event> buildHome(AuthService authProvider,UserHelperProvider userHelperProvider) {
    return StreamBuilder<Event>(
      stream: FirebaseDatabase.instance
          .reference()
          .child("userInfo")
          .child(authProvider.userId ?? "")
          .onValue,
      builder: (BuildContext context, event) {
        if (event.hasData == true &&
            event.connectionState == ConnectionState.active) {
          UserInfoModel userInfo = UserInfoModel();
          var gelenInfo = event.data.snapshot.value;
          if (gelenInfo != null) {
            userInfo = UserInfoModel.fromJson(gelenInfo);
            userHelperProvider.vki=userInfo.vki;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Kilo',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.weight)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Boy',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.height)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Yaş',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.age)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Cinsiyet',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.gender)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Çalışma Biçimi',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.movement)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Günlük Kalori İhtiyacı',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(
                              text: userInfo.dailyCalori.toString())),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      readOnly: true,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Vücut Kitle İndeksi',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: CupertinoColors.activeGreen)),
                      controller: controller = TextEditingController.fromValue(
                          TextEditingValue(text: userInfo.vki.toString())),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: Get.width,
                      height: Get.height * 0.07,
                      child: RaisedButton(
                        onPressed: () {
                          Get.to(
                              CreateData(
                                age: userInfo.age,
                                gender: userInfo.gender,
                                height: userInfo.height,
                                weight: userInfo.weight,
                                movement: userInfo.movement,
                                isUpdate: true,
                              ),
                              transition: Transition.rightToLeft);
                        },
                        color: CupertinoColors.activeGreen,
                        child: Text(
                          'Güncelle',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else
            return buildEmptyScreen();
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  GestureDetector buildEmptyScreen() {
    return GestureDetector(
      onTap: () => Get.to(
          CreateData(
            isUpdate: false,
          ),
          transition: Transition.rightToLeft),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outlined,
              size: 38,
              color: CupertinoColors.activeGreen,
            ),
            Text(
              'Kalori hesabı için dokunun',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
