class UserModel {
  String name;
  String surname;
  String phone;
  String email;
  String avatar;

  UserModel({this.name, this.surname, this.phone, this.email, this.avatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    surname = json['Surname'];
    phone = json['Phone'];
    email = json['Email'];
    avatar = json['Avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Surname'] = this.surname;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['Avatar'] = this.avatar;
    return data;
  }
}
