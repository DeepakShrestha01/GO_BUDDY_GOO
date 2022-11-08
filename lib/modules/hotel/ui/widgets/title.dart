import 'package:flutter/material.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../model/value_notifier.dart';

class TitleWidget extends StatelessWidget {
  final Function()? onTap;

  const TitleWidget({Key? key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(
          //   Icons.search,
          //   size: 20,
          //   color: Colors.white,
          // ),

          const PNGIconWidget(asset: "assets/images/search.png"),
          const SizedBox(width: 5),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget? child) {
              return Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              );
            },
            valueListenable: searchHotelString,
          ),
        ],
      ),
    );
  }
}
