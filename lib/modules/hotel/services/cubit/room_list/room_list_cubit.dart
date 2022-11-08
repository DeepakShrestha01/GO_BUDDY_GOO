import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/hotel_inventory.dart';

part 'room_list_state.dart';

class RoomListCubit extends Cubit<RoomListState> {
  RoomListCubit() : super(RoomListInitial());

  List<HotelInventory> roomsList = [];

  getRoomTypes() async {
    emit(RoomListLoading());

    Future.delayed((const Duration(seconds: 2)), () {
      // roomsList.add(Room(
      //   id: 1,
      //   hotelId: 2,
      //   imageUrl: roomImages[0],
      //   title: "Standard Single Room",
      //   maxAdults: 1,
      //   maxChildren: 0,
      //   price: 4720,
      //   features: ["Free Wi-Fi", "Free Cancellation"],
      // ));

      roomsList.add(HotelInventory().generate());

      // roomsList.add(Room(
      //   id: 2,
      //   hotelId: 2,
      //   imageUrl: roomImages[1],
      //   title: "Standard Double Room",
      //   maxAdults: 2,
      //   maxChildren: 1,
      //   price: 5450,
      //   features: ["Free Wi-Fi", "Free Cancellation"],
      // ));

      // roomsList.add(Room(
      //   id: 3,
      //   hotelId: 2,
      //   imageUrl: roomImages[2],
      //   title: "Premium Single Room",
      //   maxAdults: 1,
      //   maxChildren: 0,
      //   price: 7000,
      //   features: ["Free Wi-Fi", "Free Cancellation"],
      // ));

      if (roomsList.isEmpty) {
        emit(RoomListError());
      } else {
        emit(RoomListLoaded());
      }
    });
  }
}
