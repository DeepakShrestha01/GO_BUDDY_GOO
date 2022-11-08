class RentalItem {
  RentalItem({
    this.id,
    this.image,
    this.name,
    this.status,
  });

  int? id;
  String? image;
  String? name;
  bool? status;

  factory RentalItem.fromJson(Map<String, dynamic> json) => RentalItem(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "status": status,
      };
}
