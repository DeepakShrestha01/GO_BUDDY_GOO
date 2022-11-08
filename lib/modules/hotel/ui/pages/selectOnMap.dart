import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/model/user_location.dart';
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/common_widgets.dart';
import '../../../../configs/theme.dart';
import '../../model/hotel_booking_detail_parameters.dart';

class SelectOnMapPage extends StatefulWidget {
  const SelectOnMapPage({super.key});

  @override
  _SelectOnMapPageState createState() => _SelectOnMapPageState();
}

class _SelectOnMapPageState extends State<SelectOnMapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition _currentLocation = const CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 10,
  );

  setCurrentLocation() async {
    UserLocation? userLocation = locator<UserLocation>();

    if (userLocation != null) {
      _currentLocation = CameraPosition(
        target: LatLng(userLocation.latitude!, userLocation.longitude!),
        zoom: 12.5,
      );

      final GoogleMapController controller = await _controller.future;

      controller
          .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));

      setState(() {});
    } else {
      showToast(text: "Enable location for better experience.", time: 5);
    }
  }

  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  LatLng? selectedLocation;

  String? selectedLocationString;

  HotelBookingDetailParameters? parameters;

  @override
  void initState() {
    super.initState();
    parameters = locator<HotelBookingDetailParameters>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _currentLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setCurrentLocation();
            },
            markers: _markers,
            circles: _circles,
            onTap: (position) async {
              selectedLocation = position;
              _markers.clear();
              _circles.clear();
              _markers.add(
                Marker(
                  markerId: MarkerId(selectedLocation.toString()),
                  position: selectedLocation!,
                  infoWindow: InfoWindow(
                    title:
                        'Your Selected Location ${selectedLocation.toString()}',
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                ),
              );
              _circles.add(
                Circle(
                  circleId: CircleId(selectedLocation.toString()),
                  center: selectedLocation!,
                  fillColor: MyTheme.primaryColor.withOpacity(0.1),
                  strokeWidth: 0,
                  radius: 10 * 1000.0,
                ),
              );
              _circles.add(
                Circle(
                  circleId: CircleId(selectedLocation!.latitude.toString()),
                  center: selectedLocation!,
                  fillColor: MyTheme.primaryColor.withOpacity(0.2),
                  strokeWidth: 0,
                  radius: 8 * 1000.0,
                ),
              );
              setState(() {});

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  selectedLocation!.latitude, selectedLocation!.longitude);
              selectedLocationString =
                  placemarks.reversed.last.subAdministrativeArea.toString();
            },
          ),
          Positioned(
            top: 5,
            left: 5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                parameters?.latLng = selectedLocation;
                parameters?.query = selectedLocationString;

                Get.back();
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: MyTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
              width: MediaQuery.of(context).size.width,
              color: MyTheme.primaryColor,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tap on map to select a destination",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _markers.clear();
                      _circles.clear();
                      selectedLocationString = null;
                      setState(() {});
                    },
                    child: Row(
                      children: const [
                        Icon(
                          CupertinoIcons.multiply_circle,
                          color: MyTheme.primaryColor,
                        ),
                        Text(
                          "Clear",
                          style: TextStyle(color: MyTheme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
