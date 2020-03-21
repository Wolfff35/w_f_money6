import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wfmoney6/catalogs/account/AccountsDBWorker.dart';
import 'package:wfmoney6/catalogs/account/AccountsModel.dart';
import 'package:wfmoney6/catalogs/category/CategoriesDBWorker.dart';
import 'package:wfmoney6/catalogs/category/CategoriesModel.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesDBWorker.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';
import 'package:wfmoney6/operations/transact/TransactsDBWorker.dart';
import 'package:wfmoney6/operations/transact/TransactsModel.dart';

/// ********************************************************************************************************************
/// The Currencies screen.
/// ********************************************************************************************************************
class UtilitesImport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(children: [
        RaisedButton(
          child: Text("Импорт валют    "),
          elevation: 10,
          onPressed: () {
            _import_currency(context);
          },
        ),
        RaisedButton(
          child: Text("Импорт кошельков"),
          elevation: 10,
          onPressed: () {
            _import_account(context);
          },
        ),
        RaisedButton(
          child: Text("Импорт статей доходов/расходов"),
          elevation: 10,
          onPressed: () {
            _import_category(context);
          },
        ),
        RaisedButton(
          child: Text("Импорт транзакций"),
          elevation: 10,
          onPressed: () {
            _import_transact(context);
          },
        ),
      ]),
    );
  }

  Future<void> _import_currency(inContext) async {
    String _path = "/storage/emulated/0/import_temp";
    String _file = "financePM.data";
    try {
      File _fil = File("$_path/$_file");
      await _fil.readAsString().then((contents) {
        //print("!!! = = $contents");
        Map<String, dynamic> d = json.decode(contents.trim());
        List<Currency> list = List<Currency>.from(d['currencies']
            .map((x) => CurrenciesDBWorker().import_fromJson(x)));
        print("######## ${list.toString()}");
        list.forEach((item) {
          try {
            CurrenciesDBWorker().create(item);
          } catch (e) {
            CurrenciesDBWorker().update(item);
          }
        });
      });
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Валюты загружены")));
    } catch (e) {
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content:
              Text("Нужно дать приложению разрешение на чтение из хранилища")));
    }
  }

  Future<void> _import_account(inContext) async {
    String _path = "/storage/emulated/0/import_temp";
    String _file = "financePM.data";
    try {
      File _fil = File("$_path/$_file");
      await _fil.readAsString().then((contents) {
        Map<String, dynamic> d = json.decode(contents.trim());
        List<Account> list = List<Account>.from(
            d['accounts'].map((x) => AccountsDBWorker().import_fromJson(x)));
        //print("######## ${list.toString()}");
        list.forEach((item) {
          if (item != null) {
            try {
              AccountsDBWorker().create(item);
            } catch (e) {
              AccountsDBWorker().update(item);
            }
          }
        });
      });
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Кошельки загружены")));
    } catch (e) {
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content:
              Text("Нужно дать приложению разрешение на чтение из хранилища")));
    }
  }

  Future<void> _import_category(inContext) async {
    String _path = "/storage/emulated/0/import_temp";
    String _file = "financePM.data";
    try {
      File _fil = File("$_path/$_file");
      await _fil.readAsString().then((contents) {
        Map<String, dynamic> _d = json.decode(contents.trim());
        List<Category> _list = List<Category>.from(_d['categories']
            .map((x) => CategoriesDBWorker().import_fromJson(x)));
        print("########  ITEMS = ${_list.length}");
        _list.forEach((_item) {
          print("########  ITEM = ${_item}");

          if (_item != null) {
            print("########  ITEM NOT NULL");
            try {
              print("########  ITEM CREATE");
              CategoriesDBWorker().create(_item);
            } catch (e) {
              print("########  ITEM ERROR ");
              print("########  $e");

              CategoriesDBWorker().update(_item);
            }
          }
        });
      });
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Статьи загружены")));
    } catch (e) {
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content:
              Text("Нужно дать приложению разрешение на чтение из хранилища")));
    }
  }

  Future<void> _import_transact(inContext) async {
    String _path = "/storage/emulated/0/import_temp";
    String _file = "financePM.data";
    try {
      File _fil = File("$_path/$_file");
      await _fil.readAsString().then((contents) {
        Map<String, dynamic> d = json.decode(contents.trim());
        List<Transact> list = List<Transact>.from(d['transactions']
            .map((x) => TransactsDBWorker().import_fromJson(x)));
        //print("######## ${list.toString()}");
        list.forEach((item) {
          if (item != null) {
            try {
              TransactsDBWorker().create(item);
            } catch (e) {
              TransactsDBWorker().update(item);
            }
          }
        });
      });
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          content: Text("Кошельки загружены")));
    } catch (e) {
      print("ERRORRRRRRR $e");
      Scaffold.of(inContext).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content:
              Text("Нужно дать приложению разрешение на чтение из хранилища")));
    }
  }
} /* End class. */
