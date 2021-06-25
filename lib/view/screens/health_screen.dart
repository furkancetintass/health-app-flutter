import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/view/screens/fruits.dart';
import 'package:my_health/view/screens/legumes.dart';
import 'package:my_health/view/screens/meats.dart';
import 'package:my_health/view/screens/milk_products.dart';
import 'package:my_health/view/screens/vegetables.dart';

class HealthScreen extends StatefulWidget {
  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sağlık'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:5),
              buildDivider('Meyveler'),
              SizedBox(height:5),
              GestureDetector(
                onTap: ()=>Get.to(Fruits()),
                child: Card(child: Image.asset('assets/images/fruits.PNG'))),
              SizedBox(height:5),
              buildDivider('Sebzeler'),
              SizedBox(height:5),
              GestureDetector(
                onTap: ()=>Get.to(Vegetables()),
                child: Card(child: Image.asset('assets/images/vegetables.jpg'))),
              SizedBox(height:5),
              buildDivider('Baklagiller'),
              SizedBox(height:5),
              GestureDetector(
                onTap: ()=>Get.to(Legumes()),
                child: Card(child: Image.asset('assets/images/legumes.PNG'))),
              SizedBox(height:5),
              buildDivider('Et'),
              SizedBox(height:5),
              GestureDetector(
                onTap: ()=>Get.to(Meats()),
                child: Card(child: Image.asset('assets/images/meat.jpg'))),
              SizedBox(height:5),
              buildDivider('Süt Ürünleri'),
              SizedBox(height:5),
              GestureDetector(
                onTap: ()=>Get.to(MilkProducts()),
                child: Card(child: Image.asset('assets/images/milk_products.jpg'))),
            ],
          ),
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
            color: Get.theme.accentColor, fontWeight: FontWeight.bold),
      ),
      Expanded(
          child: Divider(
        indent: 20,
      )),
    ]);
  }
}
