import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/theme.dart';
import '../../modules/hotel/model/hotel.dart';
import 'network_image.dart';

class Facility extends StatelessWidget {
  final HotelFacility facility;

  const Facility({Key? key, required this.facility}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Tooltip(
        message: facility.name,
        preferBelow: false,
        child: Container(
          height: 30,
          width: 30,
          padding: const EdgeInsets.all(3),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            // color: Colors.grey.shade100,
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: facility.image?.split(".").last == "svg"
              ? SvgImageWidget(url: facility.image.toString())
              : showNetworkImageSmall(facility.image.toString()),
        ),
      ),
    );
  }
}

class SvgImageWidget extends StatelessWidget {
  const SvgImageWidget({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url.contains("http") ? url : backendServerUrlImage + url,
      placeholderBuilder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(2.0),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyTheme.primaryColor),
          )),
    );
  }
}
