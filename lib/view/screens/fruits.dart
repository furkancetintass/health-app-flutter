import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/constants/constants.dart';

class Fruits extends StatefulWidget {
  @override
  _FruitsState createState() => _FruitsState();
}

class _FruitsState extends State<Fruits> {
  Future futureAnanas,
      futureElma,
      futureErik,
      futureIncir,
      futureKarpuz,
      futureKavun,
      futureKayisi,
      futureKiraz,
      futureMandalina,
      futureMango,
      futureNar,
      futureSeftali,
      futureUzum,
      futureYeni;
  @override
  void initState() {
    futureAnanas = _getImage(context, "fruits/ananas.jpg");
    futureElma = _getImage(context, "fruits/elma.jpg");
    futureErik = _getImage(context, "fruits/erik.jpg");
    futureIncir = _getImage(context, "fruits/incir.jpg");
    futureKarpuz = _getImage(context, "fruits/karpuz.jpg");
    futureKavun = _getImage(context, "fruits/kavun.jpg");
    futureKayisi = _getImage(context, "fruits/kayisi.jpg");
    futureKiraz = _getImage(context, "fruits/kiraz.jpg");
    futureMandalina = _getImage(context, "fruits/mandalina.jpg");
    futureMango = _getImage(context, "fruits/mango.jpg");
    futureNar = _getImage(context, "fruits/nar.jpg");
    futureSeftali = _getImage(context, "fruits/seftali.jpg");
    futureUzum = _getImage(context, "fruits/uzum.jpg");
    futureYeni = _getImage(context, "fruits/yeni_dunya.jpg");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meyveler'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Constants.fruitImageList.length,
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
          buildFutureBuilder(context, Constants.fruitImageList[index], index),
          //  Image.asset('assets/images/fruits.PNG'),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              Constants.fruitTitle[index],
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeGreen),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(Constants.fruitContent[index],),
          ),
        ],
      ),
    );
  }

  Widget buildFutureBuilder(
      BuildContext context, String fruit, int index) {
    return Container(
      height:Get.height*0.34,
      child: FutureBuilder(
        future: checkFuture(index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Container(
              child: snapshot.data,
            );

          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
                // width: Get.width,
                // height: 250,
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
    if (i==0) {
      return futureAnanas;
    }
    if (i==1) {
      return futureElma;
    }
    if (i==2) {
      return futureErik;
    }
    if (i==3) {
      return futureIncir;
    }
    if (i==4) {
      return futureKarpuz;
    }
    if (i==5) {
      return futureKavun;
    }
    if (i==6) {
      return futureKayisi;
    }
    if (i==7) {
      return futureKiraz;
    }
    if (i==8) {
      return futureMandalina;
    }
    if (i==9) {
      return futureMango;
    }
    if (i==10) {
      return futureNar;
    }
    if (i==11) {
      return futureSeftali;
    }
    if (i==12) {
      return futureUzum;
    }
    if (i==13) {
      return futureYeni;
    }
  }
}
