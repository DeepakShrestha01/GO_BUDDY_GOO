import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_buddy_goo_mobile/configs/theme.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/list_selected_seats.dart';
import 'package:go_buddy_goo_mobile/modules/bus_new/model/new_bus_search_list_response.dart';

import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../myaccount/services/hive/hive_user.dart';
import '../../services/cubit/new_bus_search_result/bus_search_list_cubit.dart';

class NewBusBoardingPoints extends StatefulWidget {
  const NewBusBoardingPoints({super.key});

  @override
  State<NewBusBoardingPoints> createState() => _NewBusBoardingPointsState();
}

class _NewBusBoardingPointsState extends State<NewBusBoardingPoints> {
  String? valueChange;

  List<String>? listboarding;
  List<String>? selectedSeats = Get.arguments[1];
  var listofFormFields = <Widget>[];
  List<dynamic> listofSelectedSeats = [];

  String? selectedLocation;
  showTitleMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(listboarding!.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(listboarding![i]),
        );
      }),
      position: RelativeRect.fromLTRB(
        50,
        offset.dy,
        MediaQuery.of(context).size.height,
        MediaQuery.of(context).size.width,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  GlobalKey<AnimatorWidgetState>? _keyEmail;
  final locationController = TextEditingController();
  final contactNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  User? user;
  UserDetail? userDetail;

  @override
  void initState() {
    user = HiveUser.getUser();
    userDetail = HiveUser.getUserDetail();
    super.initState();
    listboarding ??= listboarding;
  }

  @override
  Widget build(BuildContext context) {
    // ListofSelectedSeats? listofSelectedSeats =  ListofSelectedSeats();
    listofSelectedSeats = selectedSeats!.map((e) {
      return {
        'seat': e,
        'name_of_passenger': " ",
        'age': null,
      };
    }).toList();
    Buses bus = Get.arguments[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buses Boarding Points',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Enter Your Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Contact Name",
                      style: headerTextStyle,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: contactNameController
                        ..text = userDetail!.name.toString(),
                      style: const TextStyle(fontSize: 14),
                      cursorColor: MyTheme.primaryColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                divider(),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: headerTextStyle,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: phoneNumberController
                        ..text = userDetail!.contact.toString(),
                      style: const TextStyle(fontSize: 14),
                      cursorColor: MyTheme.primaryColor,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // hintText: "Enter your password",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        errorStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                divider(),
                const SizedBox(height: 10),
                Shake(
                  key: _keyEmail,
                  preferences: const AnimationPreferences(
                      autoPlay: AnimationPlayStates.None),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: headerTextStyle,
                      ),
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(fontSize: 14),
                        cursorColor: MyTheme.primaryColor,
                        validator: (x) {
                          if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(x.toString())) {
                            // _keyEmail?.currentState?.forward();

                            return "Enter your valid email";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your Email Address",
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          errorStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                divider(),
                const SizedBox(height: 10),
                BlocBuilder<BusSearchListCubit, BusSearchListState>(
                  builder: (context, state) {
                    if (state is SelectBusSuccessState) {
                      listboarding = state.response.detail?.boardingPoint;

                      return GestureDetector(
                        onTapDown: (details) async {
                          int index = await showTitleMenu(
                              context, details.globalPosition);
                          selectedLocation = listboarding![index];
                          locationController.text = selectedLocation!;
                        },
                        child: TextField(
                          style: const TextStyle(fontSize: 14),
                          enabled: false,
                          cursorColor: MyTheme.primaryColor,
                          controller: locationController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Select Boarding Point",
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      );
                    } else {
                      return TextField(
                        style: valueTextStyle,
                        enabled: false,
                        cursorColor: MyTheme.primaryColor,
                        controller: locationController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Boarding Point",
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      );
                    }
                  },
                ),
                divider(),
                const SizedBox(height: 20),
                const Text('---------- Enter Passenger Details ---------',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedSeats?.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/seat_selected_2.png",
                          color: Colors.purple,
                          scale: 2.5,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Full Name",
                                style: headerTextStyle,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  // listofSelectedSeats.nameOfPassenger = value;
                                  // ListofSelectedSeats(nameOfPassenger: value);
                                  listofSelectedSeats[index] = {
                                    ...listofSelectedSeats[index],
                                    'age': 12
                                  }['name_of_passenger'] = value;
                                  setState(() {});
                                },
                                // controller: emailController,
                                style: const TextStyle(fontSize: 12),
                                cursorColor: MyTheme.primaryColor,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Full Name",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  errorStyle: TextStyle(fontSize: 12),
                                ),
                              ),
                              divider()
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Age",
                                  style: headerTextStyle,
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    // listofSelectedSeats.age= int.tryParse(value);
                                    ListofSelectedSeats(
                                        age: int.tryParse(value));
                                    listofSelectedSeats[index]['age'] = value;
                                    setState(() {});
                                  },
                                  controller: emailController,
                                  style: const TextStyle(fontSize: 12),
                                  cursorColor: MyTheme.primaryColor,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter Age",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    errorStyle: TextStyle(fontSize: 12),
                                  ),
                                ),
                                divider()
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: MyTheme.primaryColor),
            onPressed: () {
              print('lll :$listofSelectedSeats');
              // BlocProvider.of<BusSearchListCubit>(context).passengerDetails(
              //   phoneNumberController.text,
              //   emailController.text,
              //   contactNameController.text,
              //   bus.dateEn,
              // );
            },
            child: Text('Proceed'.toUpperCase())),
      ),
    );
  }
}
