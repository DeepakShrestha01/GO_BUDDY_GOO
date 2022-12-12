class NewCity {
  NewCity({
    this.label,
    this.value,
  });

  String? label;
  String ?value;

  factory NewCity.fromJson(Map<String, dynamic> json) => NewCity(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
