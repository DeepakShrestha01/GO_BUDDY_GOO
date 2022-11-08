class Notification {
  Notification({
    this.notificationHeader,
    this.notificationDescription,
    this.promotionId,
    this.bannerImage,
    this.module,
  });

  String? notificationHeader;
  String? notificationDescription;
  int? promotionId;
  String? bannerImage;
  String ?module;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
      notificationHeader: json["notification_header"],
      notificationDescription: json["notification_description"],
      promotionId: json["promotion_id"],
      bannerImage: json["banner_image"],
      module: json["module"]);

  Map<String, dynamic> toJson() => {
        "notification_header": notificationHeader,
        "notification_description": notificationDescription,
        "promotion_id": promotionId,
        "banner_image": bannerImage,
        "module": module,
      };
}
