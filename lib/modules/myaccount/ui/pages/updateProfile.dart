import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

import '../../../../common/functions/format_date.dart';
import '../../../../common/functions/getInitials.dart';
import '../../../../common/model/country_list.dart';
import '../../../../common/model/user.dart';
import '../../../../common/model/user_detail.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../common/widgets/divider.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../services/cubit/update_profile/update_profile_cubit.dart';
import '../../services/hive/hive_user.dart';
import '../widgets/extendedSingleTile.dart';
import '../widgets/singleTile.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UpdateProfileCubit(),
      child: const UpdateProfileBody(),
    );
  }
}

class UpdateProfileBody extends StatefulWidget {
  const UpdateProfileBody({super.key});

  @override
  _UpdateProfileBodyState createState() => _UpdateProfileBodyState();
}

class _UpdateProfileBodyState extends State<UpdateProfileBody> {
  UserDetail? userDetail;

  UpdateProfileCubit? updateProfileCubit;

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();

  int? countryId;

  String? gender;
  String? dob;

  List<String> genderList = ["Male", "Female", "Others"];

  File? _image;
  final picker = ImagePicker();

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  compressAndUploadImage(String imagePath) async {
    Directory tempDir = await getTemporaryDirectory();
    File? compressedimage = await FlutterImageCompress.compressAndGetFile(
      _image!.path.toString(),
      "${tempDir.path}/GBG_${randomAlphaNumeric(10)}.jpg",
      minHeight: 500,
      minWidth: 500,
    );

    updateProfileCubit?.updateImage(compressedimage!.path.toString(), u: user);
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    await retrieveLostData();
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await compressAndUploadImage(_image!.path);
    }
    setState(() {});
  }

// https://test-gbg.ktm.yetiappcloud.com/booking/api_v_1/profile_update_front_end_user_for_web/111

  selectDate(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();

    DateTime initialDate =
        currentDateTime.subtract(const Duration(hours: 24 * 365 * 25));

    initialDate = DateTimeFormatter.stringToDateServer(dob.toString());

    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate:
          currentDateTime.subtract(const Duration(hours: 24 * 365 * 100)),
      initialDate: initialDate,
      lastDate: currentDateTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: MyTheme.primaryColor),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            highlightColor: MyTheme.primaryColor,
            textTheme: MyTheme.mainTextTheme,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: MyTheme.primaryColor,
            ),
          ),
          child: child as Widget,
        );
      },
    );

    dob = DateTimeFormatter.formatDateServer(selectedDate);

    setState(() {});
  }

  showGenderMenu(BuildContext context, Offset offset) async {
    return showMenu(
      context: context,
      items: List<PopupMenuEntry>.generate(genderList.length, (i) {
        return PopupMenuItem(
          value: i,
          child: Text(genderList[i]),
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

  GlobalKey<AnimatorWidgetState>? _keyFullName,
      _keyCountry,
      _keyAddress,
      _keyPhone;

  User? user;

  CountryList? countryList;

  @override
  void initState() {
    super.initState();

    userDetail = HiveUser.getUserDetail();
    print(userDetail?.toJson());
    user = Get.arguments;
    if (user == null) {
      user = HiveUser.getUser();
      user?.isVerified = userDetail?.isVerified;
    }
    print(user);
    print('------user from arguments------');
    countryList = locator<CountryList>();
    nameController.text = userDetail!.name.toString();
    addressController.text = userDetail!.address.toString();
    countryController.text = userDetail!.country.toString();
    gender = userDetail?.gender;
    dob = userDetail?.dob;

    phoneController.text = userDetail?.contact == null
        ? user!.phone.toString()
        : userDetail!.contact!.split("-").last;

    gender ??= "Male";
    dob ??= DateTimeFormatter.formatDateServer(DateTime.now());

    updateProfileCubit = BlocProvider.of<UpdateProfileCubit>(context);

    updateProfileCubit?.oldPhNumber = phoneController.text;

    _keyFullName = GlobalKey<AnimatorWidgetState>();
    _keyCountry = GlobalKey<AnimatorWidgetState>();
    _keyAddress = GlobalKey<AnimatorWidgetState>();
    _keyPhone = GlobalKey<AnimatorWidgetState>();
  }

  @override
  Widget build(BuildContext context) {
    print('main builder');
    String? userImage = userDetail!.image.toString();
    if (userImage.isEmpty) {
      userImage = userDetail!.image.toString();
      if (!userImage.contains("https")) {
        userImage = backendServerUrlImage + userImage;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is UpdateProfileLoading,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: MyTheme.primaryColor,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Note: Make sure you are providing your accurate information. We won't be responsible for any inconvenience caused by wrong information provided by you.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: CircularProfileAvatar(
                            "",
                            onTap: () {
                              pickImage();
                            },
                            cacheImage: true,
                            elevation: 4,
                            initialsText: Text(
                              getUserInitials(userDetail!.name.toString(), ''),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            borderWidth: 2.5,
                            borderColor: MyTheme.primaryColor,
                            // imageBuilder: (context, provider) {
                            //   return Image.network(provider.loa);
                            // },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _image == null
                                      ? userImage == null
                                          ? const AssetImage(
                                              "assets/images/profileb.png")
                                          : NetworkImage(userImage)
                                              as ImageProvider
                                      : FileImage(_image!),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 5, left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.75),
                                  ),
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ExtendedSingleTile(
                          header: "Name",
                          icon: CupertinoIcons.person_fill,
                          controller: nameController,
                          hintText: "Enter full name",
                          tag: "name",
                          shakeKey: _keyFullName!,
                        ),
                        divider(),
                        Shake(
                          preferences: const AnimationPreferences(
                              autoPlay: AnimationPlayStates.None),
                          key: _keyCountry,
                          child: ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.public,
                              color: MyTheme.primaryColor,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Country",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                TypeAheadField(
                                  autoFlipDirection: true,
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    autofocus: false,
                                    controller: countryController,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 17,
                                    ),
                                    cursorColor: MyTheme.primaryColor,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      hintText: "Select country",
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return countryList
                                        ?.getPatternCountries(pattern);
                                  },
                                  itemBuilder: (context, dynamic suggestion) {
                                    return ListTile(
                                      title: Text(suggestion.name),
                                    );
                                  },
                                  onSuggestionSelected: (dynamic suggestion) {
                                    countryController.text = suggestion.name;
                                    countryId = suggestion.id;

                                    setState(() {});
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "No country found",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        divider(),
                        StatefulBuilder(
                          builder: (BuildContext ctx, setState) {
                            return Row(
                              children: [
                                Expanded(
                                  child: ExtendedSingleTile(
                                    header: "Phone number",
                                    icon: Icons.phone,
                                    controller: phoneController,
                                    hintText: "Enter phone number",
                                    tag: "phone",
                                    shakeKey: _keyPhone!,
                                    onChanged: (x) {
                                      print('set state internal');
                                      setState(() {
                                        updateProfileCubit?.newPhNumber = x;
                                      });
                                    },
                                  ),
                                ),
                                if (!user!.isVerified! ||
                                    (updateProfileCubit?.newPhNumber !=
                                            user?.phone &&
                                        updateProfileCubit?.newPhNumber !=
                                            null))
                                  ElevatedButton(
                                    onPressed: () {
                                      if (phoneController.text.isNotEmpty) {
                                        updateProfileCubit?.sendOtp(
                                          phoneController.text,
                                          user!,
                                        );

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              final otpController =
                                                  TextEditingController();
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        "Enter OTP that has been sent to your phone below,"),
                                                    TextField(
                                                      controller: otpController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "OTP",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      updateProfileCubit
                                                          ?.checkOtp(
                                                        otpController.text,
                                                        phoneController.text,
                                                        user!,
                                                      );
                                                    },
                                                    child: const Text("Verify"),
                                                  )
                                                ],
                                              );
                                            });
                                      } else {
                                        _keyPhone?.currentState?.forward();
                                      }
                                    },
                                    child: const Text("Verify"),
                                  ),
                              ],
                            );
                          },
                        ),
                        divider(),
                        ExtendedSingleTile(
                          header: "Address",
                          icon: Icons.place,
                          controller: addressController,
                          hintText: "Enter address",
                          tag: "address",
                          shakeKey: _keyAddress!,
                        ),
                        divider(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTapDown: (TapDownDetails details) async {
                            int selectedGenderIndex = await showGenderMenu(
                                context, details.globalPosition);
                            gender = genderList[selectedGenderIndex];
                            setState(() {});
                          },
                          child: SingleTile(
                            header: "Gender",
                            icon: Icons.face,
                            value: gender.toString(),
                          ),
                        ),
                        divider(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            selectDate(context);
                          },
                          child: SingleTile(
                            header: "Date of Birth",
                            icon: Icons.celebration,
                            value: dob.toString(),
                          ),
                        ),
                        divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed("/updatePassword");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.primaryColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Change Password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      _keyFullName?.currentState?.forward();
                    } else if (countryController.text.isEmpty ||
                        countryList?.getCountryId(countryController.text) ==
                            null) {
                      _keyCountry?.currentState?.forward();
                    } else if (phoneController.text.isEmpty) {
                      _keyPhone?.currentState?.forward();
                    } else if (!updateProfileCubit!
                        .phoneNumberVerified(phoneController.text)) {
                      _keyPhone?.currentState?.forward();
                      showToast(text: "Phone number not verified");
                    } else if (addressController.text.isEmpty) {
                      _keyAddress?.currentState?.forward();
                    } else {
                      countryId =
                          countryList?.getCountryId(countryController.text);
                      if (user!.isVerified! ||
                          updateProfileCubit?.newPhNumber == user?.phone) {
                        updateProfileCubit?.emailVerified(user!.isVerified!);
                      }
                      updateProfileCubit?.updateDetails(
                        fullName: nameController.text,
                        address: addressController.text,
                        countryId: countryId,
                        dob: dob,
                        gender: gender,
                        u: user,
                      );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: MyTheme.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.5),
                    child: Center(
                      child:
                          BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                        builder: (context, state) {
                          if (state is UpdateProfileLoading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          }

                          return Text("Update",
                              style: MyTheme.mainTextTheme.headlineMedium
                                  ?.copyWith(color: Colors.white));
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        },
      ),
    );
  }
}
