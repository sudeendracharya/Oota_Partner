import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 40,
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return const TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}
