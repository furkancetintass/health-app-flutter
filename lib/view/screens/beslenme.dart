import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/model/beslenme_model.dart';
import 'package:my_health/view/screens/create_data.dart';
import 'package:my_health/view_model/user_helper_provider.dart';
import 'package:provider/provider.dart';

class Beslenme extends StatefulWidget {
  @override
  _BeslenmeState createState() => _BeslenmeState();
}

class _BeslenmeState extends State<Beslenme> {
  

  @override
  Widget build(BuildContext context) {
    var userHelperProvider = Provider.of<UserHelperProvider>(context);
    var vki;
    checkVki() {
      if (double.parse(userHelperProvider.vki) < 19) {
        vki = 'Zayıf';
        return 'Zayıf';
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
          .child("Beslenme/$vki/$day")
          .onValue,
      builder: (BuildContext context, event) {
        if (event.hasData == true &&
            event.connectionState == ConnectionState.active) {
          BeslenmeModel beslenme = BeslenmeModel();

          var gelenInfo = event.data.snapshot.value;
          if (gelenInfo != null) {
            beslenme = BeslenmeModel.fromJson(gelenInfo);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    buildDivider('Beslenme Programı'),
                    SizedBox(height: 30),
                    Text(
                      'Sabah',
                      style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold),
                    ),
                    buildListView(beslenme.sabah),
                    SizedBox(height: 30),
                    Text(
                      'Öğle',
                      style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold),
                    ),
                    buildListView(beslenme.ogle),
                    SizedBox(height: 30),
                    Text(
                      'Ara Öğün',
                      style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold),
                    ),
                    buildListView(beslenme.ara),
                    SizedBox(height: 30),
                    Text(
                      'Akşam',
                      style: TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.bold),
                    ),
                    buildListView(beslenme.aksam),
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

  ListView buildListView(List<String> liste) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: liste.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            leading: Icon(Icons.label_important),
            title: Text(
              liste[index],
            ));
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
