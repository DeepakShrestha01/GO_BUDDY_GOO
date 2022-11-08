class PackageTheme {
  PackageTheme({
    this.id,
    this.title,
    this.image,
  });

  int ?id;
  String? title;
  String ?image;

  factory PackageTheme.fromJson(Map<String, dynamic> json) => PackageTheme(
        id: json["id"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}

class PackageThemeList {
  List<PackageTheme> themes = [];

  static final PackageThemeList _x = PackageThemeList._internal();

  PackageThemeList._internal();

  factory PackageThemeList() {
    return _x;
  }

  getThemeName(int id) {
    List<PackageTheme> searchTheme = themes.where((x) => id == x.id).toList();
    if (searchTheme.length != 1) {
      return "";
    } else {
      return searchTheme.first.title;
    }
  }

  getPatternTheme(String pattern) {
    List<PackageTheme> filteredThemes = [];

    for (PackageTheme theme in themes) {
      if (theme.title!.toLowerCase().contains(pattern.toLowerCase())) {
        filteredThemes.add(theme);
      }
    }
    return filteredThemes;
  }

  getThemeId(String theme) {
    for (PackageTheme pt in themes) {
      if (pt.title!.toLowerCase() == theme.toLowerCase()) {
        return pt.id;
      }
    }

    return null;
  }
}
