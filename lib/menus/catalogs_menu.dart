import 'package:flutter/material.dart';

import 'menu_setings.dart';

class CatalogsMenu extends StatelessWidget {
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
              Icons.euro_symbol,
              color: sIconColor,
            ),
            title: Text(
              "Валюты",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/currency"); //Currencies();
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.account_balance_wallet,
              color: sIconColor,
            ),
            title: Text(
              "Кошельки",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/account");
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.done_all,
              color: sIconColor,
            ),
            title: Text(
              "Статьи доходов/расходов",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/category");
            },
          ),
          color: sCardColor,
        ),
        Card(
          elevation: sCardElevation,
          child: ListTile(
            leading: Icon(
              Icons.group,
              color: sIconColor,
            ),
            title: Text(
              "Объекты учета",
              style: sTextStyleMenu,
            ),
            trailing: Icon(
              sTrailingIcon,
              color: sIconColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, "/people");
            },
          ),
          color: sCardColor,
        ),
      ],
    ); //);
  }
}
