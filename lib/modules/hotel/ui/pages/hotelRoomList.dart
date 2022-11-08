import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../../common/widgets/common_widgets.dart';
import '../../services/cubit/room_list/room_list_cubit.dart';

class HotelRoomListPage extends StatelessWidget {
  const HotelRoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RoomListCubit(),
      child: const HotelRoomListBody(),
    );
  }
}

class HotelRoomListBody extends StatefulWidget {
  const HotelRoomListBody({super.key});

  @override
  _HotelRoomListBodyState createState() => _HotelRoomListBodyState();
}

class _HotelRoomListBodyState extends State<HotelRoomListBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<RoomListCubit>(context).getRoomTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Room Type",
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<RoomListCubit, RoomListState>(
        builder: (BuildContext context, state) {
          if (state is RoomListLoaded) {}
          return const LoadingWidget();
        },
      ),
    );
  }
}
