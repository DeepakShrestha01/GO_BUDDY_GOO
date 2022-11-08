import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../common/functions/format_date.dart' as myDateFormatter;
import '../../../../common/services/get_it.dart';
import '../../../../common/widgets/network_image.dart';
import '../../../../configs/theme.dart';
import '../../model/bus_booking_detail_parameters.dart';
import '../../model/bus_offer.dart';

class SingleBusOfferWidget extends StatefulWidget {
  final BusOffer? busoffer;
  const SingleBusOfferWidget({Key? key, this.busoffer}) : super(key: key);

  @override
  _SingleBusOfferWidgetState createState() => _SingleBusOfferWidgetState();
}

class _SingleBusOfferWidgetState extends State<SingleBusOfferWidget> {
  DateTime? departureDate;

  String? departureDateS;

  selectDate(BuildContext context) async {
    DateTime currentDateTime = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: currentDateTime,
      initialDate: departureDate ?? currentDateTime,
      lastDate: currentDateTime.add(const Duration(days: 28)),
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

    departureDate = selectedDate;
    departureDateS =
        myDateFormatter.DateTimeFormatter.formatDate(departureDate!);

    BusBookingDetailParameters parameters =
        locator<BusBookingDetailParameters>();
    parameters.from = widget.busoffer?.busDetail?.busFrom?.name;
    parameters.fromId = widget.busoffer?.busDetail?.busFrom?.id;
    parameters.to = widget.busoffer?.busDetail?.busTo?.name;
    parameters.toId = widget.busoffer?.busDetail?.busTo?.id;
    parameters.departureDate = departureDate;
    parameters.shift = widget.busoffer?.busDetail?.busShift;

    Get.toNamed("/busList");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    return GestureDetector(
      onTap: () {
        selectDate(context);
      },
      child: Container(
        height: height * 0.15,
        // width: width,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: width * 0.3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  showNetworkImage(
                      widget.busoffer!.offer!.bannerImage.toString()),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      // width: 100,
                      // height: 35,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      decoration: const BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          // bottomLeft: Radius.circular(7.5),
                        ),
                      ),
                      child: AutoSizeText(
                        widget.busoffer?.offer?.discountPricingType == "amount"
                            ? "Rs. ${widget.busoffer?.offer?.amount} off"
                            : "${widget.busoffer?.offer?.rate} %off",
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7.5),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3, top: 3),
                        child: Text(
                          "Expires in: ${DateTimeFormat.relative(
                            myDateFormatter.DateTimeFormatter
                                .stringToDateServer(
                                    widget.busoffer!.offer!.endDate.toString()),
                            levelOfPrecision: 1,
                          )}",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.busoffer!.offer!.offerName.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "On ${widget.busoffer?.busDetail?.busTag}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Route: ${widget.busoffer?.busDetail?.busFrom?.name}-${widget.busoffer?.busDetail?.busTo?.name}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              widget.busoffer!.offer!.description.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
