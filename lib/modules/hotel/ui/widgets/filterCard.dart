import 'package:flutter/material.dart';

import 'customExpansionTile.dart';

class ExpandedTileWidget extends StatelessWidget {
  final Widget titleWidget;
  final Widget? subtitleWidget;
  final List<Widget> expandedWidgets;
  final Widget? leadingWidget;
  final bool? initiallyExpanded;
  final EdgeInsets? childrenPadding;
  final EdgeInsets? titlePadding;
  final Color? backgroundColor;

  const ExpandedTileWidget({
    super.key,
    required this.expandedWidgets,
    required this.titleWidget,
    this.subtitleWidget,
    this.leadingWidget,
    this.initiallyExpanded,
    this.childrenPadding,
    this.titlePadding,
    this.backgroundColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: CustomExpansionTile(
        title: titleWidget,
        leading: leadingWidget,
        subtitle: subtitleWidget,
        maintainState: true,
        initiallyExpanded: initiallyExpanded ?? false,
        tilePadding: titlePadding ?? const EdgeInsets.symmetric(horizontal: 20),
        childrenPadding: childrenPadding,
        backgroundColor: backgroundColor ?? Colors.transparent,
        children: expandedWidgets,
      ),
    );
  }
}
