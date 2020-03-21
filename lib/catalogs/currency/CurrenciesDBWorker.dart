import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';
import 'package:wfmoney6/db_provider.dart';
import 'package:wfmoney6/menus/menu_setings.dart';

class CurrenciesDBWorker {
  Currency currencyFromMap(Map inMap) {
    Currency currency = Currency(inMap[DBProvider.id], inMap[DBProvider.name]);
    //currency.id = inMap[DBProvider.id];
    //currency.title = inMap[DBProvider.name];
    return currency;
  }

  Map<String, dynamic> currencyToMap(Currency inCurrency) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[DBProvider.id] = inCurrency.id;
    map[DBProvider.name] = inCurrency.title;
    return map;
  }

  Future create(Currency inCurrency) async {
    Database db = await DBProvider.instance.database;
    var val = await db.rawQuery(
        "SELECT MAX(${DBProvider.id})+1 AS ${DBProvider.id} FROM ${DBProvider.tableNameCurrency}");
    int id = val.first[DBProvider.id];
    if (id == null) {
      id = 1;
    }
    return await db.rawInsert(
        "INSERT INTO ${DBProvider.tableNameCurrency} (${DBProvider.id}, ${DBProvider.name}) VALUES (?,?)",
        [inCurrency.id, inCurrency.title]);
  }

  Future<Currency> get(int inID) async {
    Database db = await DBProvider.instance.database;
    var rec = await db.query(DBProvider.tableNameCurrency,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
    return currencyFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await DBProvider.instance.database;
    var recs = await db.query(DBProvider.tableNameCurrency);
    var list =
        recs.isNotEmpty ? recs.map((m) => currencyFromMap(m)).toList() : [];
    return list;
  }

  Future update(Currency inCurrency) async {
    Database db = await DBProvider.instance.database;
    return await db.update(
        DBProvider.tableNameCurrency, currencyToMap(inCurrency),
        where: "${DBProvider.id}= ?", whereArgs: [inCurrency.id]);
  }

  Future delete(int inID) async {
    Database db = await DBProvider.instance.database;
    return await db.delete(DBProvider.tableNameCurrency,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
  }

  List<Widget> getListForSelection(BuildContext inContext) {
    List<Widget> ll = new List();
    getAll().then((listCurr) {
      //print(
      //    "===========================================${listCurr.toString()}");
      listCurr.forEach((f) {
        ll.add(new ListTile(
          title: Text(
            "${f.title}",
            style: sTextStyleSubtitle,
          ),
          onTap: () {
            Navigator.pop(inContext, f);
          },
        ));
        ll.add(Divider(
          color: Colors.white,
        ));
      });
    });
    return ll;
  }

  Currency import_fromJson(Map<String, dynamic> json) {
    return Currency(json['id'], json['shortName']);
  }
}
