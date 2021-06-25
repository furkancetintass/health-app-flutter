import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_health/constants/constants.dart';
import 'package:my_health/service/database_service.dart';
import 'package:provider/provider.dart';

class CreateData extends StatefulWidget {
  CreateData(
      {this.height,
      this.weight,
      this.age,
      this.gender,
      this.movement,
      this.isUpdate});
  String weight, height, gender, age, movement;
  bool isUpdate;
  @override
  _CreateDataState createState() => _CreateDataState();
}

enum SingingCharacter { erkek, kadin }
enum SingingCharacterMovement { yok, az, orta, cok }

class _CreateDataState extends State<CreateData> {
  SingingCharacter _character = SingingCharacter.erkek;
  SingingCharacterMovement _characterMovement = SingingCharacterMovement.yok;

  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController movementController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  int selectedRadioTile;
  int selectedWeight;
  int selectedHeight;

  @override
  Widget build(BuildContext context) {
    var dbProvider = Provider.of<Database>(context);
    if (widget.isUpdate == true) {
      genderController.text =
          genderController.text == '' ? widget.gender : genderController.text;
      ageController.text =
          ageController.text == '' ? widget.age : ageController.text;
      movementController.text = movementController.text == ''
          ? widget.movement
          : movementController.text;
      weightController.text =
          weightController.text == '' ? widget.weight : weightController.text;
      heightController.text =
          heightController.text == '' ? widget.height : heightController.text;
    }
    saveInfo() async {
      if (widget.isUpdate == true) {
        if (ageController.text == widget.age &&
            genderController.text == widget.gender &&
            movementController.text == widget.movement &&
            heightController.text == widget.height &&
            weightController.text == widget.weight) {
          Get.snackbar(
            'Hata',
            'Güncelleme yapmak için en az bir değişiklik yapmalısınız',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        }
        else{
           await dbProvider.createCalori(
              genderController.text,
              ageController.text,
              movementController.text,
              heightController.text,
              weightController.text);

          Get.back();
        }
      } else {
        if (ageController.text == '' ||
            genderController.text == '' ||
            movementController.text == '' ||
            heightController.text == '' ||
            weightController.text == '') {
          Get.snackbar(
            'Hata',
            'Lütfen bütün bilgilerinizi eksiksiz girin',
            backgroundColor: Colors.red,
            colorText: Get.theme.snackBarTheme.actionTextColor,
            backgroundGradient:
                LinearGradient(colors: [Colors.red[900], Colors.redAccent]),
          );
        } else {
          await dbProvider.createCalori(
              genderController.text,
              ageController.text,
              movementController.text,
              heightController.text,
              weightController.text);

          Get.back();
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Kalori Hesabı'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: genderController,
                onTap: () {
                  Get.bottomSheet(StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    return Container(
                        height: Get.height < 500
                            ? Get.height * 0.4
                            : Get.height * 0.2,
                        color: Get.theme.scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            RadioListTile(
                              title: Text('Erkek'),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacter.erkek,
                              groupValue: _character,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  genderController.text = 'Erkek';
                                  setModalState(() {
                                    Get.back();
                                    _character = value;
                                  });
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text('Kadın'),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacter.kadin,
                              groupValue: _character,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  genderController.text = 'Kadın';
                                  setModalState(() {
                                    Get.back();
                                    _character = value;
                                  });
                                });
                              },
                            ),
                          ],
                        ));
                  }));
                },
                decoration: InputDecoration(labelText: 'Cinsiyet'),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: ageController,
                onTap: () {
                  Get.bottomSheet(StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    return Container(
                      height: Get.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          index++;
                          return RadioListTile(
                            title: Text('$index'),
                            value: index,
                            groupValue: selectedRadioTile,
                            activeColor: Get.theme.accentColor,
                            onChanged: (val) {
                              setModalState(() {
                                selectedRadioTile = val;
                              });
                              setState(() {
                                ageController.text = '$index';
                              });
                              Future.delayed(Duration(milliseconds: 150), () {
                                Get.back();
                              });
                            },
                          );
                        },
                      ),
                    );
                  }), backgroundColor: Get.theme.scaffoldBackgroundColor);
                },
                decoration: InputDecoration(labelText: 'Yaş'),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: movementController,
                onTap: () {
                  Get.bottomSheet(StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    return Container(
                        height: Get.height < 500
                            ? Get.height * 0.6
                            : Get.height * 0.4,
                        color: Get.theme.scaffoldBackgroundColor,
                        child: Column(
                          children: [
                            RadioListTile(
                              title: Text(Constants.movementList[0]),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacterMovement.yok,
                              groupValue: _characterMovement,
                              onChanged: (SingingCharacterMovement value) {
                                setState(() {
                                  movementController.text =
                                      Constants.movementList[0];
                                  setModalState(() {
                                    Get.back();
                                    _characterMovement = value;
                                  });
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text(Constants.movementList[1]),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacterMovement.az,
                              groupValue: _characterMovement,
                              onChanged: (SingingCharacterMovement value) {
                                setState(() {
                                  movementController.text =
                                      Constants.movementList[1];
                                  setModalState(() {
                                    Get.back();
                                    _characterMovement = value;
                                  });
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text(Constants.movementList[2]),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacterMovement.orta,
                              groupValue: _characterMovement,
                              onChanged: (SingingCharacterMovement value) {
                                setState(() {
                                  movementController.text =
                                      Constants.movementList[2];
                                  setModalState(() {
                                    Get.back();
                                    _characterMovement = value;
                                  });
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text(Constants.movementList[3]),
                              activeColor: Get.theme.accentColor,
                              value: SingingCharacterMovement.cok,
                              groupValue: _characterMovement,
                              onChanged: (SingingCharacterMovement value) {
                                setState(() {
                                  movementController.text =
                                      Constants.movementList[3];
                                  setModalState(() {
                                    Get.back();
                                    _characterMovement = value;
                                  });
                                });
                              },
                            ),
                          ],
                        ));
                  }));
                },
                decoration: InputDecoration(labelText: 'Çalışma Biçimi'),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: heightController,
                onTap: () {
                  Get.bottomSheet(StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    return Container(
                      height: Get.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 170,
                        itemBuilder: (context, index) {
                          index += 50;
                          return RadioListTile(
                            title: Text('$index'),
                            value: index,
                            groupValue: selectedHeight,
                            activeColor: Get.theme.accentColor,
                            onChanged: (val) {
                              setModalState(() {
                                selectedHeight = val;
                              });
                              setState(() {
                                heightController.text = '$index';
                              });
                              Future.delayed(Duration(milliseconds: 150), () {
                                Get.back();
                              });
                            },
                          );
                        },
                      ),
                    );
                  }), backgroundColor: Get.theme.scaffoldBackgroundColor);
                },
                decoration: InputDecoration(labelText: 'Boy'),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: weightController,
                onTap: () {
                  Get.bottomSheet(StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    return Container(
                      height: Get.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 200,
                        itemBuilder: (context, index) {
                          index++;
                          return RadioListTile(
                            title: Text('$index'),
                            value: index,
                            groupValue: selectedWeight,
                            activeColor: Get.theme.accentColor,
                            onChanged: (val) {
                              setModalState(() {
                                selectedWeight = val;
                              });
                              setState(() {
                                weightController.text = '$index';
                              });
                              Future.delayed(Duration(milliseconds: 150), () {
                                Get.back();
                              });
                            },
                          );
                        },
                      ),
                    );
                  }), backgroundColor: Get.theme.scaffoldBackgroundColor);
                },
                decoration: InputDecoration(labelText: 'Kilo'),
              ),
              Container(
                width: Get.width,
                height: Get.height * 0.07,
                child: RaisedButton(
                  onPressed: saveInfo,
                  color: CupertinoColors.activeGreen,
                  child: Text(
                    'Kaydet',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
