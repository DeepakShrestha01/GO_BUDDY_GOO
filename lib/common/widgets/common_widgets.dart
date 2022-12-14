import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../configs/theme.dart';

class BulletItemWidget extends StatelessWidget {
  const BulletItemWidget({Key? key, required this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("  •  ", style: TextStyle(fontSize: 14)),
        Expanded(
          child: Text(
            text ?? "",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class XLoadingWidget extends StatelessWidget {
  final Color? color;
  const XLoadingWidget({
    Key? key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}

class LoadingWidget extends StatelessWidget {
  final Color? color;
  const LoadingWidget({
    Key? key,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset("assets/json/gobuddygoo.json"),
    );
  }
}

class WideButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final Color? color;
  final BuildContext? context;
  final IconData? icon;
  final Color? textColor;
  final bool? shadow;
  final double? borderRadius;
  final double? widthMultiplier;

  const WideButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.context,
    required this.icon,
    this.textColor,
    this.shadow,
    this.borderRadius,
    this.widthMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: shadow == null
            ? 10.0
            : shadow!
                ? 10.0
                : 0.0,
        type: MaterialType.canvas,
        color: color?.withOpacity(0.95),
        // clipBehavior: Clip.antiAlias,
        shadowColor: color?.withOpacity(0.75),
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
        child: Container(
          width: MediaQuery.of(context).size.width * (widthMultiplier ?? 0.8),
          padding: const EdgeInsets.symmetric(vertical: 12.5),
          child: Center(
            child: Row(
              mainAxisAlignment: icon == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                icon != null
                    ? SizedBox(width: (widthMultiplier ?? 0.8) * 40 / 0.8)
                    : const SizedBox(),
                icon != null
                    ? Icon(
                        icon,
                        color: Colors.white,
                      )
                    : const SizedBox(),
                icon != null ? const SizedBox(width: 5) : const SizedBox(),
                Text(
                  text.toString(),
                  style: textColor == null
                      ? MyTheme.mainTextTheme.headlineMedium
                      : MyTheme.mainTextTheme.headlineMedium
                          ?.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showToast({required String? text, int? time}) {
  BotToast.showCustomText(
    align: Alignment.bottomCenter,
    clickClose: false,
    ignoreContentClick: true,
    enableKeyboardSafeArea: true,
    duration: Duration(seconds: time ?? 5),
    onlyOne: true,
    toastBuilder: (_) {
      return Container(
        padding: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        child: Card(
          elevation: 5.0,
          color: MyTheme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              text ?? "  ",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showSimpleNotifications({required String? text, int? time}) {
  BotToast.showSimpleNotification(
    title: text.toString(),
    duration: Duration(seconds: time ?? 2),
    align: Alignment.bottomCenter,
  );
}

final headerTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 12,
  color: Colors.grey.shade700,
);

const valueTextStyle = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 17,
);
