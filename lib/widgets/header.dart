import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "InPhoMeeT" : titleText,
      style: TextStyle(
        color: isAppTitle ? Colors.black : Colors.black,
        fontFamily: isAppTitle ? "rage" : "keep",
        fontSize: isAppTitle ? 40.0 : 30.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
    //actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
  );
}
