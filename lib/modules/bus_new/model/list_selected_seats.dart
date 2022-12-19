class ListofSelectedSeats {
  String? seat;
  String? nameOfPassenger;
  int? age;

  ListofSelectedSeats({
    this.seat,
    this.nameOfPassenger,
    this.age,
  });

  // ListofSelectedSeats.fromJson(Map<String, dynamic> json) {
  //   seat = json['seat'];
  //   nameOfPassenger = json['name_of_passenger'];
  //   age = json['age'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['seat'] = seat;
  //   data['name_of_passenger'] = nameOfPassenger;
  //   data['age'] = age;
  //   return data;
  // }
}
