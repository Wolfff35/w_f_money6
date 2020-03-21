import 'package:flutter/material.dart';

import 'menu_setings.dart';

class UtilitesMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return //Scaffold(
        //body:
        ListView(
      children: <Widget>[
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.import_export,
              color: sIconColor,
            ),
            title: Text(
              "Импорт данных",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/utilites_import"); //Currencies();
            },
          ),
          color: sCardColor,
        ),
      ],
    ); //);
  }
}
