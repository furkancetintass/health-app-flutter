import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/constants/constants.dart';

class MilkProducts extends StatefulWidget {
  @override
  _MilkProductsState createState() => _MilkProductsState();
}

class _MilkProductsState extends State<MilkProducts> {
  Future futurePeynir, futureSut, futureYogurt;

  @override
  void initState() {
    futurePeynir = _getImage(context, "milk_products/peynir.jpg");
    futureSut = _getImage(context, "milk_products/sut.jpg");
    futureYogurt= _getImage(context, "milk_products/yogurt.jpg");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Süt Ürünleri'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
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
              Constants.milksTitle[index],
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
              Constants.milksContent[index],
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
      return futurePeynir;
    }
    if (i == 1) {
      return futureSut;
    }
    if (i == 2) {
      return futureYogurt;
    }
   
  }
}
