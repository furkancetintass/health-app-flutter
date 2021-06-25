import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/constants/constants.dart';

class Vegetables extends StatefulWidget {
  @override
  _VegetablesState createState() => _VegetablesState();
}

class _VegetablesState extends State<Vegetables> {
  Future futureBrokoli,
      futureDomates,
      futureEnginar,
      futureFasulye,
      futureHavuc,
      futureIspanak,
      futureKabak,
      futureKusburnu,
      futureLimon,
      futureMarul,
      futureMisir,
      futurePatates,
      futureSalatalik,
      futureSarimsak,
      futureSogan;
  @override
  void initState() {
    futureBrokoli = _getImage(context, "vegetables/brokoli.jpg");
    futureDomates = _getImage(context, "vegetables/domates.jpg");
    futureEnginar = _getImage(context, "vegetables/enginar.jpg");
    futureFasulye = _getImage(context, "vegetables/fasulye.jpg");
    futureHavuc = _getImage(context, "vegetables/havuc.jpg");
    futureIspanak = _getImage(context, "vegetables/ispanak.jpg");
    futureKabak = _getImage(context, "vegetables/kabak.jpg");
    futureKusburnu = _getImage(context, "vegetables/kusburnu.jpg");
    futureLimon = _getImage(context, "vegetables/limon.jpg");
    futureMarul = _getImage(context, "vegetables/marul.jpg");
    futureMisir = _getImage(context, "vegetables/misir.jpg");
    futurePatates = _getImage(context, "vegetables/patates.jpg");
    futureSalatalik = _getImage(context, "vegetables/salatalik.jpg");
    futureSarimsak = _getImage(context, "vegetables/sarimsak.jpg");
    futureSogan = _getImage(context, "vegetables/sogan.jpg");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sebzeler'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 15,
          itemBuilder: (BuildContext context, int index) {
            return buildCard(context, index);
          },
        ),
      ),
    );
  }

  Card buildCard(BuildContext context, int index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFutureBuilder(context, index),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              Constants.vegetablesTitle[index],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeGreen),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              Constants.vegetablesContent[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFutureBuilder(BuildContext context, int index) {
    return Container(
      height: Get.height * 0.34,
      child: FutureBuilder(
        future: checkFuture(index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
              child: snapshot.data,
            );

          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
                child: CircularProgressIndicator(
              strokeWidth: 1,
            ));

          return Container();
        },
      ),
    );
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    String _urlImage =
        await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    m = Image.network(
      _urlImage.toString(),
      fit: BoxFit.scaleDown,
    );

    return m;
  }

  Future<dynamic> checkFuture(int i) {
    if (i == 0) {
      return futureBrokoli;
    }
    if (i == 1) {
      return futureDomates;
    }
    if (i == 2) {
      return futureEnginar;
    }
    if (i == 3) {
      return futureFasulye;
    }
    if (i == 4) {
      return futureHavuc;
    }
    if (i == 5) {
      return futureIspanak;
    }
    if (i == 6) {
      return futureKabak;
    }
    if (i == 7) {
      return futureKusburnu;
    }
    if (i == 8) {
      return futureLimon;
    }
    if (i == 9) {
      return futureMarul;
    }
    if (i == 10) {
      return futureMisir;
    }
    if (i == 11) {
      return futurePatates;
    }
    if (i == 12) {
      return futureSalatalik;
    }
    if (i == 13) {
      return futureSarimsak;
    }
    if (i == 14) {
      return futureSogan;
    }
  }
}
