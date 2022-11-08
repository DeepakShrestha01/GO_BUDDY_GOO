class BusPromotion {
  BusPromotion({
    this.promotionId,
    this.promotionName,
    this.description,
    this.pricingType,
    this.ratePercentage,
    this.amount,
    this.bannerImage,
  });

  int? promotionId;
  String? promotionName;
  String? description;
  String? pricingType;
  dynamic ratePercentage;
  String? amount;
  String? bannerImage;

  factory BusPromotion.fromJson(Map<String, dynamic> json) => BusPromotion(
        promotionId: json["promotion_id"],
        promotionName: json["promotion_name"],
        description: json["description"],
        pricingType: json["pricing_type"],
        ratePercentage: json["rate_percentage"],
        amount: json["amount"],
        bannerImage: json["banner_image"],
      );
}
