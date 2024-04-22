class UserModel {
  String name;
  String phoneNumber;
  String pinCode;
  String address;
  String uid;

  UserModel(
      {required this.name,
        required this.phoneNumber,
        required this.pinCode,
        required this.address,
        required this.uid});

  //to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'pinCode': pinCode,
      'address': address,
    };
  }

  //from Json to object back

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      pinCode: json['pinCode'],
      address: json['address'],
    );
  }
}
