
import '../../../common/model/offer.dart';

class HotelOffer extends Offer {
  HotelOffer({
    int? id,
    String? name,
    String? description,
    double? discountRate,
    String? image,
    String? hotel,
    int? hotelId,
    String? startDate,
    String? endDate,
  }) : super(
          id: id,
          description: description,
          discountRate: discountRate,
          endDate: endDate,
          startDate: startDate,
          image: image,
          name: name,
          itemName: hotel,
          itemId: hotelId,
        );

  factory HotelOffer.fromJson(Map<String, dynamic> json) => HotelOffer(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        discountRate: double.parse(json["discount_rate"]),
        image: json["image"],
        hotel: json["hotel"],
        hotelId: json["hotel_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
      );
}
