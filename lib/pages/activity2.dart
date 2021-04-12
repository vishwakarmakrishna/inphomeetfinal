import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:inphomeet/pages/nearify.dart';
import 'package:inphomeet/widgets/header.dart';

class Activity2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SimpleHiddenDrawer(
        menu: header(""),
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent;

          switch (position) {
            case 0:
              screenCurrent = Nearify();
              break;
            case 1:
              screenCurrent = Nearify();
              break;
            case 2:
              screenCurrent = Nearify();
              break;
          }

          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    controller.toggle();
                  }),
            ),
            body: screenCurrent,
          );
        },
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<Menu> {
  SimpleHiddenDrawerController controller;

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.cyan,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                controller.setSelectedMenuPosition(0);
              },
              child: Text("Menu 1"),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                controller.setSelectedMenuPosition(1);
              },
              child: Text("Menu 2"),
            )
          ],
        ),
      ),
    );
  }
}
