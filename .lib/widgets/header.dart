import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String titleText}) {
  return AppBar(
    title: Text(
      isAppTitle ? "INPHOMEET" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "truelies" : "transformers",
        fontSize: isAppTitle ? 40.0 : 30.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
