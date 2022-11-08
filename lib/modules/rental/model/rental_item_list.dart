
import 'package:go_buddy_goo_mobile/modules/rental/model/rental_item.dart';

class RentalItemList {
  List<RentalItem> rentalItems = [];

  static final RentalItemList _rentalItemList = RentalItemList._internal();

  RentalItemList._internal();

  factory RentalItemList() {
    return _rentalItemList;
  }
}
