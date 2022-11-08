class GiftCard {
  GiftCard({
    this.id,
    this.amount,
  });

  int? id;
  String? amount;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        id: json["id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
      };
}
