class BeslenmeModel {
  List<String> aksam;
  List<String> ara;
  List<String> ogle;
  List<String> sabah;

  BeslenmeModel({this.aksam, this.ara, this.ogle, this.sabah});

  BeslenmeModel.fromJson(Map<dynamic, dynamic> json) {
    aksam = json['Aksam'].cast<String>();
    ara = json['Ara'].cast<String>();
    ogle = json['Ogle'].cast<String>();
    sabah = json['Sabah'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Aksam'] = this.aksam;
    data['Ara'] = this.ara;
    data['Ogle'] = this.ogle;
    data['Sabah'] = this.sabah;
    return data;
  }
}
