import 'package:flutter/cupertino.dart';
import 'package:go_buddy_goo_mobile/modules/hotel/model/range.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'hotel.dart';
import 'hotel_booking_detail.dart';
import 'keyword_search_result.dart';

ValueNotifier<int> bookingsCount = ValueNotifier<int>(0);

class HotelBookingDetailParameters {
  Hotel? hotel;
  String? query;
  int? maxAdults;
  int? maxChildren;
  Range? dateRange;
  int? noOfRooms;
  bool isSearch = false;
  List<HotelBookingDetail> bookings = [];
  int? hotelId;
  KeywordSearchResult? selectedKeyword;
  LatLng? latLng;

  bool isInventoryInBooking(int inventoryId) {
    for (HotelBookingDetail bookingDetail in bookings) {
      if (bookingDetail.room?.inventoryId == inventoryId) {
        return true;
      }
    }
    return false;
  }

  int? minimumRequiredRoom(int inverntoryId) {
    if (hotel?.hotelInventoriesShort != null) {
      for (var x in hotel!.hotelInventoriesShort!) {
        if (x.id == inverntoryId) {
          return x.minimumNumberOfRoomRequired!;
        }
      }
    }

    return null;
  }

  /*

  function to add booking to booking list
  if booking is already found it will remove booking
  from booking list else it adds booking to the list

  */
  void addBooking(HotelBookingDetail booking) {
    int bookingFoundIndex = -1;
    for (int i = 0; i < bookings.length; i++) {
      if (booking.room?.inventoryId == bookings[i].room?.inventoryId) {
        bookingFoundIndex = i;
      }
    }

    if (bookingFoundIndex == -1) {
      booking.room?.addedToBooking.value = true;
      bookings.add(booking);
    } else {
      booking.room?.addedToBooking.value = false;
      bookings.removeAt(bookingFoundIndex);
    }

    bookingsCount.value = bookings.length;
  }

  void clearBookings() {
    bookings = [];
    bookingsCount.value = 0;
  }

  void clearAllField() {
    hotel = null;
    query = null;
    maxAdults = null;
    maxChildren = null;
    dateRange = null;
    noOfRooms = null;
    isSearch = false;
    hotelId = null;
    selectedKeyword = null;
    latLng = null;
    clearBookings();
  }

  void clearAllExceptKeyWordOrLatlng() {
    hotel = null;
    query = null;
    maxAdults = null;
    maxChildren = null;
    dateRange = null;
    noOfRooms = null;
    isSearch = false;
    hotelId = null;
    clearBookings();
  }

  static final HotelBookingDetailParameters _bookingDetailsParams =
      HotelBookingDetailParameters._internal();

  factory HotelBookingDetailParameters() {
    return _bookingDetailsParams;
  }

  HotelBookingDetailParameters._internal();
}
