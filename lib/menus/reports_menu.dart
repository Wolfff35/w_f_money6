import 'package:flutter/material.dart';

class ReportsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Отчет 1"),
          onTap: () {
            print("1");
          },
        ),
        ListTile(
          title: Text("отчет 2"),
          onTap: () {
            print("2");
          },
        ),
        ListTile(
          title: Text("Отчет 3"),
          onTap: () {
            print("3");
          },
        ),
        ListTile(
          title: Text("Отчет 4"),
          onTap: () {
            print("4");
          },
        ),
      ],
    );
  }
}
