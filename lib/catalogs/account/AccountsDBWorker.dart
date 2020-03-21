import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';
import 'package:wfmoney6/db_provider.dart';
import 'package:wfmoney6/menus/menu_setings.dart';

import 'AccountsModel.dart';

class AccountsDBWorker {
  Account accountFromMap(Map inMap) {
    Account account = Account();
    account.id = inMap[DBProvider.id];
    account.title = inMap[DBProvider.name];
    account.isDefault = (inMap[DBProvider.isDefault] == 1);
    account.icon = Icon(Icons.edit); //TODO!!!
    account.describe = inMap[DBProvider.describe];
    account.balance = inMap[DBProvider.balance];
    account.currency =
        new Currency(inMap[DBProvider.currencyId], inMap["currencyName"]);
    //account.currencyId = inMap[DBProvider.currencyId];
    return account;
  }

  Map<String, dynamic> accountToMap(Account inAccount) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[DBProvider.id] = inAccount.id;
    map[DBProvider.name] = inAccount.title;
    map[DBProvider.currencyId] = inAccount.currency.id;
    map[DBProvider.isDefault] = inAccount.isDefault ? 1 : 0;
    map[DBProvider.iconId] = 0; //TODO!!!
    map[DBProvider.describe] = inAccount.describe;
    map[DBProvider.balance] = inAccount.balance;

    return map;
  }

  Future create(Account inAccount) async {
    Database db = await DBProvider.instance.database;
    var val = await db.rawQuery(
        "SELECT MAX(${DBProvider.id})+1 AS ${DBProvider.id} FROM ${DBProvider.tableNameAccount}");
    int id = val.first[DBProvider.id];
    if (id == null) {
      id = 1;
    }
    return await db.rawInsert(
        "INSERT INTO ${DBProvider.tableNameAccount} (${DBProvider.id}, ${DBProvider.name}, ${DBProvider.currencyId}, ${DBProvider.isDefault}, ${DBProvider.iconId}, ${DBProvider.describe}, ${DBProvider.balance}) VALUES (?,?,?,?,?,?,?)",
        [
          inAccount.id,
          inAccount.title,
          inAccount.currency.id,
          inAccount.isDefault ? 1 : 0,
          0,
          inAccount.describe,
          inAccount.balance
        ]);
  }

  Future<Account> get(int inID) async {
    Database db = await DBProvider.instance.database;
    var rec = await db.query(DBProvider.tableNameAccount,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
    return accountFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await DBProvider.instance.database;
    var list = [];
    await db
        .rawQuery("SELECT acc.${DBProvider.id},"
            "acc.${DBProvider.name},"
            "acc.${DBProvider.isDefault},"
            "acc.${DBProvider.iconId},"
            "acc.${DBProvider.describe},"
            "acc.${DBProvider.balance}, "
            "acc.${DBProvider.currencyId}, "
            "curr.${DBProvider.name} AS currencyName "
            "FROM ${DBProvider.tableNameAccount} acc "
            "LEFT JOIN ${DBProvider.tableNameCurrency} curr "
            "ON acc.${DBProvider.currencyId} = curr.${DBProvider.id}")
        .then((onValue) {
      if (onValue.isNotEmpty) {
        list = onValue.map((m) => accountFromMap(m)).toList();
      }
    });
    return list;
  }

  Future update(Account inAccount) async {
    Database db = await DBProvider.instance.database;
    return await db.update(DBProvider.tableNameAccount, accountToMap(inAccount),
        where: "${DBProvider.id}= ?", whereArgs: [inAccount.id]);
  }

  Future delete(int inID) async {
    Database db = await DBProvider.instance.database;
    return await db.delete(DBProvider.tableNameAccount,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
  }

  List<Widget> getListForSelection(BuildContext inContext) {
    List<Widget> ll = new List();
    getAll().then((listAcc) {
      //print(
      //    "===========================================${listCurr.toString()}");
      listAcc.forEach((f) {
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

  Account import_fromJson(Map<String, dynamic> json) {
    //return
    Account _acc = new Account();
    _acc.id = json['id'];
    _acc.title = json['name'];
    _acc.currency = new Currency(json["currencyId"], "");
    _acc.isDefault = json["isDef"] == 1;
    if (json["active"] == 1) {
      return _acc;
    } else {
      return null;
    }
  }
}
