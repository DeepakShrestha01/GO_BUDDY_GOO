class City {
  City({
    this.id,
    this.name,
    this.type,
  });

  int? id;
  String? name;
  String? type;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}
