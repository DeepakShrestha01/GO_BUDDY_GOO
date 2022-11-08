import 'dart:convert';

class BackendModuleCheckList {
  BackendModuleCheckList({this.moduleId});

  List<BackendModuleCheck>? moduleId;

  factory BackendModuleCheckList.fromJson(Map<String, dynamic> json) =>
      BackendModuleCheckList(
        moduleId: List<BackendModuleCheck>.from(
            json["module_id"].map((x) => BackendModuleCheck.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "module_id": List<dynamic>.from(moduleId!.map((x) => x.toJson())),
      };

  String moduleToJson() => json.encode(this.toJson());
}

class BackendModuleCheck {
  BackendModuleCheck({this.id});

  int? id;

  factory BackendModuleCheck.fromJson(Map<String, dynamic> json) =>
      BackendModuleCheck(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
