class UserInfoModel {
  String age;
  int dailyCalori;
  String gender;
  String height;
  String movement;
  String weight;
  String vki;

  UserInfoModel(
      {this.age,
      this.dailyCalori,
      this.gender,
      this.height,
      this.movement,
      this.weight,
      this.vki});

  UserInfoModel.fromJson(Map<dynamic, dynamic> json) {
    age = json['age'];
    dailyCalori = json['dailyCalori'];
    gender = json['gender'];
    height = json['height'];
    movement = json['movement'];
    weight = json['weight'];
    vki = json['vki'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['dailyCalori'] = this.dailyCalori;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['movement'] = this.movement;
    data['weight'] = this.weight;
    data['vki'] = this.vki;

    return data;
  }
}
