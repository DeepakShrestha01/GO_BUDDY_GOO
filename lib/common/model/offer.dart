abstract class Offer {
  int ?id;
  String? name;
  String? description;
  double?discountRate;
  String?image;
  String? startDate;
  String ?endDate;
  String ?itemName;
  int ?itemId;
  Offer({
    this.id,
    this.name,
    this.description,
    this.discountRate,
    this.image,
    this.startDate,
    this.endDate,
    this.itemName,
    this.itemId,
  });
}
