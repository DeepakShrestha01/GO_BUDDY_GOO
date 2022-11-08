class HotelPromotion {
  HotelPromotion({
    this.promotionId,
    this.promotionName,
    this.description,
    this.rate,
    this.percentageStatus,
    this.bannerImage,
  });

  int ?promotionId;
  String? promotionName;
  String? description;
  String? rate;
  bool? percentageStatus;
  String ?bannerImage;

  factory HotelPromotion.fromJson(Map<String, dynamic> json) => HotelPromotion(
        promotionId: json["promotion_id"],
        promotionName: json["promotion_name"],
        description: json["description"],
        rate: json["rate"],
        percentageStatus: json["percentage_status"],
        bannerImage: json["banner_image"],
      );

  Map<String, dynamic> toJson() => {
        "promotion_id": promotionId,
        "promotion_name": promotionName,
        "description": description,
        "rate": rate,
        "percentage_status": percentageStatus,
        "banner_image": bannerImage,
      };
}
