import 'package:hive/hive.dart';

part 'user_detail.g.dart';

@HiveType(typeId: 2)
class UserDetail {
  @HiveField(0)
  String?name;
  @HiveField(1)
  String? contact;
  @HiveField(2)
  int? status;
  @HiveField(3)
  String?address;
  @HiveField(4)
  String?country;
  @HiveField(5)
  String? gender;
  @HiveField(6)
  String? dob;
  @HiveField(7)
  String? image;
  @HiveField(8)
  double ?reward;
  @HiveField(9)
  String? socialProfilePic;
  @HiveField(10)
  bool ?isVerified;

  UserDetail.init({
    this.name,
    this.contact,
    this.status,
    this.address,
    this.country,
    this.gender,
    this.dob,
    this.image,
    this.reward,
    this.isVerified,
    this.socialProfilePic,
  });

  static final UserDetail _userDetail = UserDetail._internal();

  factory UserDetail() {
    return _userDetail;
  }

  UserDetail._internal();

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail.init(
        name: json["name"],
        contact: json["contact"],
        status: json["status"],
        address: json["address"],
        country: json["country"],
        gender: json["gender"],
        dob: json["dob"],
        image: json["image"],
        reward: null,
        isVerified: json['is_verified'] ?? false,
        socialProfilePic: json["social_profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contact": contact,
        "status": status,
        "address": address,
        "country": country,
        "gender": gender,
        "dob": dob,
        "image": image,
        "reward": reward,
        "isVerified": isVerified,
        "social_profile_pic": socialProfilePic,
      };
}
