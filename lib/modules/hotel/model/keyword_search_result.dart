class KeywordSearchResult {
  KeywordSearchResult({
    this.id,
    this.name,
    this.type,
  });

  int? id;
  String? name;
  KeywordSearchType? type;

  factory KeywordSearchResult.fromJson(Map<String, dynamic> json) =>
      KeywordSearchResult(
        id: json["id"],
        name: json["name"],
        type: typeValues.map?[json["type"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": typeValues.reverse[type],
      };
}

enum KeywordSearchType { CITY, HOTEL, LANDMARK }

final typeValues = EnumValues({
  "city": KeywordSearchType.CITY,
  "hotel": KeywordSearchType.HOTEL,
  "landmark": KeywordSearchType.LANDMARK,
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap as Map<T, String>;
  }
}
