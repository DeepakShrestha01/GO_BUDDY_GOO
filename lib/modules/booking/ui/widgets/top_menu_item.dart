import 'package:flutter/material.dart';

import '../../../../configs/theme.dart';
import 'enum_booking_selected.dart';

class TopMenuItem extends StatelessWidget {
  final Function()? onTap;
  final BookingSelected? mainbookingSelected;
  final BookingSelected? bookingSelected;
  final String? title;

  const TopMenuItem({
    Key? key,
    this.onTap,
    this.mainbookingSelected,
    this.bookingSelected,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Text(
              title.toString(),
              style: TextStyle(
                color: mainbookingSelected == bookingSelected
                    ? MyTheme.primaryColor
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 75,
              child: Divider(
                color: mainbookingSelected == bookingSelected
                    ? MyTheme.primaryColor
                    : Colors.transparent,
                height: 5,
                thickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
