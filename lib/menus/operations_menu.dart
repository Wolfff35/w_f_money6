import 'package:flutter/material.dart';

import 'menu_setings.dart';

class OperationsMenu extends StatelessWidget {
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
              Icons.add_box,
              color: sIconColor,
            ),
            title: Text(
              "Доходы",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/debet");
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.indeterminate_check_box,
              color: sIconColor,
            ),
            title: Text(
              "Расходы",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/credit");
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.account_box,
              color: sIconColor,
            ),
            title: Text(
              "Взаиморасчеты",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/balance");
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.move_to_inbox,
              color: sIconColor,
            ),
            title: Text(
              "Перемещения",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/move");
            },
          ),
          color: sCardColor,
        ),
      ],
    ); //);
  }
}
