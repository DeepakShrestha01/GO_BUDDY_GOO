// import 'package:hive/hive.dart';
// part 'newuser.g.dart';

// @HiveType(typeId: 3)
// class NewUser {
//   NewUser({
//     this.id,
//     this.password,
//     this.email,
//     this.token,
//     this.contact,
//     this.referralCode,
//   });
//   @HiveField(0)
//   int? id;
//   @HiveField(1)
//   String? password;
//   @HiveField(2)
//   String? email;
//   @HiveField(3)
//   String? token;
//   @HiveField(4)
//   String? contact;
//   @HiveField(5)
//   String? referralCode;

//   factory NewUser.fromJson(Map<String, dynamic> json) => NewUser(
//         id: json["id"],
//         password: json["password"],
//         email: json["email"],
//         token: json["token"],
//         contact: json["contact"],
//         referralCode: json["referral_code"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "password": password,
//         "email": email,
//         "token": token,
//         "contact": contact,
//         "referral_code": referralCode,
//       };
// }
