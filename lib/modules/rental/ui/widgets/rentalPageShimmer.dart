import 'package:flutter/material.dart';

import '../../../../common/widgets/png_icon_widget.dart';
import '../../../../common/widgets/shimmer.dart';
import '../../../../configs/theme.dart';

class RentalPageShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              child: Text(
                "Choose your vehicle",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ShimmerWidget(
              child: Container(
                width: double.infinity,
                height: 55.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10.0),
                decoration: const ShapeDecoration(
                  color: MyTheme.accentTextColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: MyTheme.primaryDimColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15, top: 30),
              child: Text(
                "Choose pickup location",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ShimmerWidget(
              child: Container(
                width: double.infinity,
                height: 48.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10.0),
                decoration: const ShapeDecoration(
                  color: MyTheme.accentTextColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: MyTheme.primaryDimColor),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 13,
              thickness: 1,
            ),
            const SizedBox(height: 10.0),
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: MyTheme.primaryColor,
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      PNGIconWidget(
                        asset: "assets/images/search.png",
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 35,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
