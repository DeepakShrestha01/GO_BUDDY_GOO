import 'package:flutter/material.dart';

void hideKeyboad(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
