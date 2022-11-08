import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? email;
  @HiveField(4)
  String? token;
  @HiveField(5)
  bool ?isVerified;
  @HiveField(6)
  String? phone;

  static final User _user = User._internal();

  factory User() {
    return _user;
  }

  User._internal();

  User.init(
      {this.id,
      this.name,
      this.image,
      this.email,
      this.token,
      this.phone,
      this.isVerified});

  @override
  String toString() {
    return 'User(id: $id, name: $name, image: $image, email: $email, token: $token, isVerified: $isVerified)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User.init(
        id: int.parse(json["id"]),
        email: json["email"],
        token: json["token"],
        name: json["name"],
        image: json["image"],
        phone: json["phone"],
        isVerified: json["is_verified"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "email": email,
        "token": token,
        "name": name,
        "image": image,
        "phone": phone,
        "isVerified": isVerified,
      };
}
