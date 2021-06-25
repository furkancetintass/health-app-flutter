import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/model/beslenme_model.dart';
import 'package:my_health/service/auth_service.dart';
import 'package:my_health/view/screens/create_data.dart';
import 'package:my_health/view_model/user_helper_provider.dart';
import 'package:provider/provider.dart';

class Training extends StatefulWidget {
  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  @override
  Widget build(BuildContext context) {
    var userHelperProvider = Provider.of<UserHelperProvider>(context);
    var vki;
    checkVki() {
      if (double.parse(userHelperProvider.vki) < 19) {
        vki = 'Zayif';
        return 'Zayif';
      } else if (double.parse(userHelperProvider.vki) > 19 &&
          double.parse(userHelperProvider.vki) < 25) {
        vki = 'İdeal';
        return 'İdeal';
      } else {
        vki = 'Kilolu';
        return 'Kilolu';
      }
    }

    checkVki();
    var day = DateTime.now().day % 5;
    print(day.toString());
    return StreamBuilder<Event>(
      stream: FirebaseDatabase.instance
          .reference()
          .child("Spor/$vki/$day")
          .onValue,
      builder: (BuildContext context, event) {
        if (event.hasData == true &&
            event.connectionState == ConnectionState.active) {
          var gelenInfo = event.data.snapshot.value;
          print(gelenInfo);
          if (gelenInfo != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    buildDivider('Antrenman Programı'),
                    SizedBox(height: 30),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: gelenInfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Icon(Icons.label_important),
                          title: Text(gelenInfo[index]),
                        );
                      },
                    ),
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

Row buildDivider(String text) {
  return Row(children: <Widget>[
    Expanded(
        child: Divider(
      endIndent: 20,
    )),
    Text(
      text,
      style: TextStyle(
          color: Get.theme.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 24),
    ),
    Expanded(
        child: Divider(
      indent: 20,
    )),
  ]);
}
