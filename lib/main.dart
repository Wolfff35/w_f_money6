import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wfmoney6/catalogs/account/Accounts.dart';
import 'package:wfmoney6/catalogs/currency/Currencies.dart';
import 'package:wfmoney6/utilites/UtilitesImport.dart';

import 'catalogs/category/Categories.dart';
import 'catalogs/people/Peoples.dart';
import 'menus/catalogs_menu.dart';
import 'menus/operations_menu.dart';
import 'menus/reports_menu.dart';
import 'operations/transact/Transacts.dart';
import 'utils.dart' as utils;

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory dDir = await getApplicationDocumentsDirectory();
    utils.docsDir = dDir;
    runApp(Finance());
  }

  startMeUp();
}

class Finance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Start(),
        '/currency': (BuildContext context) => Currencies(),
        '/account': (BuildContext context) => Accounts(),
        '/category': (BuildContext context) => Categories(),
        '/people': (BuildContext context) => Peoples(),
        '/debet': (BuildContext context) => Transacts(1),
        '/credit': (BuildContext context) => Transacts(2),
        '/balance': (BuildContext context) => Peoples(),
        '/move': (BuildContext context) => Peoples(),
        '/utilites_import': (BuildContext context) => UtilitesImport(),
      },
      initialRoute: '/',
      theme: Themes.kDefaultTheme,
    );
  }
}

Widget Start() {
  return DefaultTabController(
    length: 5,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Личные финансы'),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.airplay), text: "Главная"),
            Tab(icon: Icon(Icons.category), text: "Справочники"),
            Tab(icon: Icon(Icons.open_in_new), text: "Операции"),
            Tab(icon: Icon(Icons.reorder), text: "Отчеты"),
            Tab(icon: Icon(Icons.settings), text: "Обработки"),
          ],
          onTap: (int tt) {
            print("TAPPPPED - $tt");
          },
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          Logo(),
          //Logo(),
          CatalogsMenu(),
          OperationsMenu(),
          ReportsMenu(),
          UtilitesImport(),
        ],
      ),
    ),
  );
}

class Themes {
  static ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  static ThemeData kDefaultTheme = new ThemeData(
    primaryColor: Colors.black,
    canvasColor: Colors.grey,
    dialogBackgroundColor: Colors.grey,
    unselectedWidgetColor: Colors.white,
  );
//primarySwatch: Colors.black,
//accentColor: Colors.grey[100],
//primaryColorBrightness: Brightness.dark);
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset("images/logo.jpg");
  }
}
