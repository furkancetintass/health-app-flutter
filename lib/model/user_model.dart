class UserModel {
  String email;
  String id;
  String lastLogin;
  String phone;
  String platform;
  String username;

  UserModel(
      {this.email,
      this.id,
      this.lastLogin,
      this.phone,
      this.platform,
      this.username});

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    email = json['email'];
    id = json['id'];
    lastLogin = json['lastLogin'];
    phone = json['phone'];
    platform = json['platform'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['id'] = this.id;
    data['lastLogin'] = this.lastLogin;
    data['phone'] = this.phone;
    data['platform'] = this.platform;
    data['username'] = this.username;
    return data;
  }
}
