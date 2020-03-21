import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:wfmoney6/catalogs/account/AccountsModel.dart';
import 'package:wfmoney6/catalogs/category/CategoriesModel.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';
import 'package:wfmoney6/catalogs/people/PeoplesModel.dart';
import 'package:wfmoney6/db_provider.dart';
import 'package:wfmoney6/utils.dart' as utils;

import 'TransactsModel.dart';

class TransactsDBWorker {
  Transact transactFromMap(Map inMap) {
    Transact transact = Transact(inMap[DBProvider.typeOper]);
    transact.id = inMap[DBProvider.id];
    transact.title = inMap[DBProvider.name];
    transact.describe = inMap[DBProvider.describe];
    transact.summa = inMap[DBProvider.summa];

    transact.account = new Account();
    transact.account.id = inMap[DBProvider.accountId];
    transact.account.title = inMap["accountName"];
    //transact.accountId = inMap[DBProvider.accountId];
    transact.account.currency =
        new Currency(inMap["currencyId"], inMap["currencyName"]);

    transact.category = new Category();
    transact.category.id = inMap[DBProvider.categoryId];
    transact.category.title = inMap["categoryName"];
    //transact.categoryId = inMap[DBProvider.categoryId];

    transact.people =
        new People(inMap[DBProvider.categoryId], inMap["peopleName"]);
    //transact.peopleId = inMap[DBProvider.peopleId];

    transact.dateOper = inMap[DBProvider.dateOper];
    transact.dateCreation = inMap[DBProvider.dateCreation];

    //transact.typeOper = inMap[DBProvider.typeOper];
    print("transactFromMap - - - - - - - - ${transact.toString()}");

    return transact;
  }

  Map<String, dynamic> transactToMap(Transact inTransact) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[DBProvider.id] = inTransact.id;
    map[DBProvider.name] = inTransact.title;
    map[DBProvider.describe] = inTransact.describe;
    map[DBProvider.accountId] = inTransact.account.id;
    map[DBProvider.categoryId] = inTransact.category.id;
    map[DBProvider.peopleId] = inTransact.people.id;
    map[DBProvider.summa] = inTransact.summa;

    map[DBProvider.dateOper] = inTransact.dateOper;
    map[DBProvider.dateCreation] = inTransact.dateCreation;

    map[DBProvider.typeOper] = inTransact.typeOper;
    //print("transactToMap - - - - - - - - ${inTransact.toString()}");
    return map;
  }

  Future create(Transact inTransact) async {
    DateTime _dt = DateTime.now();
    inTransact.dateCreation = "${_dt.year},${_dt.month},${_dt.day}";
    //print("CREATE - - - - - - - - ${inTransact.toString()}");
    Database db = await DBProvider.instance.database;
    var val = await db.rawQuery(
        "SELECT MAX(${DBProvider.id})+1 AS ${DBProvider.id} FROM ${DBProvider.tableNameTransact}");
    int id = val.first[DBProvider.id];
    if (id == null) {
      id = 1;
    }
    return await db.rawInsert(
        "INSERT INTO ${DBProvider.tableNameTransact} ("
        "${DBProvider.id}, "
        "${DBProvider.name}, "
        "${DBProvider.describe}, "
        "${DBProvider.accountId}, "
        "${DBProvider.categoryId}, "
        "${DBProvider.peopleId}, "
        "${DBProvider.dateOper}, "
        "${DBProvider.typeOper}, "
        "${DBProvider.dateCreation}, "
        "${DBProvider.summa}"
        ") VALUES (?,?,?,?,?,?,?,?,?,?)",
        [
          inTransact.id,
          inTransact.title,
          inTransact.describe,
          inTransact.account.id,
          inTransact.category.id,
          inTransact.people.id,
          inTransact.dateOper,
          inTransact.typeOper,
          inTransact.dateCreation,
          inTransact.summa
        ]);
  }

  Future<Transact> get(int inID) async {
    Database db = await DBProvider.instance.database;
    var rec = await db.query(DBProvider.tableNameTransact,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
    return transactFromMap(rec.first);
  }

  Future<List> getAll(int typeOper) async {
    Database db = await DBProvider.instance.database;
    var list = [];
    String textSQL = "SELECT cred.${DBProvider.id},"
        "cred.${DBProvider.name},"
        "cred.${DBProvider.describe},"
        "cred.${DBProvider.summa}, "
        "cred.${DBProvider.accountId}, "
        "cred.${DBProvider.typeOper}, "
        "cred.${DBProvider.dateOper}, "
        "cred.${DBProvider.dateCreation}, "
        "cred.${DBProvider.categoryId}, "
        "cred.${DBProvider.peopleId}, "
        "acc.${DBProvider.name} AS accountName, "
        "acc.${DBProvider.currencyId} AS currencyId, "
        "curr.${DBProvider.name} AS currencyName, "
        "categ.${DBProvider.name} AS categoryName, "
        "people.${DBProvider.name} AS peopleName "
        "FROM ${DBProvider.tableNameTransact} cred "
        "LEFT JOIN ${DBProvider.tableNameAccount} acc "
        "ON cred.${DBProvider.accountId} = acc.${DBProvider.id} "
        "LEFT JOIN ${DBProvider.tableNameCategory} categ "
        "ON cred.${DBProvider.categoryId} = categ.${DBProvider.id} "
        "LEFT JOIN ${DBProvider.tableNameCurrency} curr "
        "ON acc.${DBProvider.currencyId} = curr.${DBProvider.id} "
        "LEFT JOIN ${DBProvider.tableNamePeople} people "
        "ON cred.${DBProvider.peopleId} = people.${DBProvider.id} ";
    if (typeOper > 0) {
      textSQL = textSQL + " WHERE cred.${DBProvider.typeOper}=$typeOper";
    }
    textSQL = textSQL +
        " ORDER BY cred.${DBProvider.dateOper} DESC, cred.${DBProvider.id} DESC ";

    await db.rawQuery(textSQL).then((onValue) {
      if (onValue.isNotEmpty) {
        list = onValue.map((m) => transactFromMap(m)).toList();
      }
    });
    return list;
  }

  Future update(Transact inTransact) async {
    Database db = await DBProvider.instance.database;
    return await db.update(
        DBProvider.tableNameTransact, transactToMap(inTransact),
        where: "${DBProvider.id}= ?", whereArgs: [inTransact.id]);
  }

  Future delete(int inID) async {
    Database db = await DBProvider.instance.database;
    return await db.delete(DBProvider.tableNameTransact,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
  }

  Transact import_fromJson(Map<String, dynamic> json) {
    //return
    Transact _oper = new Transact(1);
    _oper.id = int.parse(json['id']);
    _oper.title = json['name'];
    _oper.describe = json['description'];

    _oper.account = new Account();
    _oper.account.id = json["accountId"];
    _oper.category = new Category();
    _oper.category.id = json["categoryId"];
    _oper.people = new People(1, "");
    _oper.summa = double.parse(json["sum"]);
    _oper.typeOper = json["type"];
    DateTime _dat =
        DateTime.fromMillisecondsSinceEpoch(int.parse(json["date"]));
    //_oper.dateOper = DateFormat.yMMMMd("en_US").format(_dat.toLocal());
    ///print(
    //   "###### #### ### ## # - $_dat - ${_dat.toLocal()} - ${DateFormat.yMMMMd("en_US").format(_dat.toLocal())}");
    _oper.dateOper =
        utils.formatDateToWrite("${_dat.year},${_dat.month},${_dat.day}");
    //_acc.isDefault = json["isDef"] == 1;
    if (json["available"] == 1 && json["source"] == 0) {
      return _oper;
    } else {
      return null;
    }
  }
}
