import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  final String _dbName = "WFMoneyDB.db";
  static final _databaseVersion = 2;

  static final String tableNameAccount = "t_account";
  static final String tableNameCurrency = "t_currency";
  static final String tableNameCategory = "t_category";
  static final String tableNamePeople = "t_people";
  static final String tableNameTransact = "t_transact";

  static final String id = "_id";
  static final String name = "_name";
  static final String describe = "_describe";

  static final String balance = "_balance";
  static final String currencyId = "_id_currency";
  static final String isDefault = "_is_default";
  static final String iconId = "_id_icon";

  static final String isDebet = "_is_debet";
  static final String isCredit = "_is_credit";
  static final String idGroup = "_idGroup";
  static final String isGroup = "_isGroup";
  static final String groupLevel = "_groupLevel";

  static final String accountId = "_id_account";
  static final String categoryId = "_id_category";
  static final String peopleId = "_id_people";
  static final String summa = "_summa";
  static final String dateOper = "_date_oper";
  static final String dateCreation = "_date_creation";
  static final String typeOper = "_type_operation";

  DBProvider._privateConstructor();

  static final DBProvider instance = DBProvider._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await _initDB();
    debugPrint("======== GETTING DB ===========");
    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path,
        version: _databaseVersion,
        onOpen: (db) {
          db.execute("PRAGMA foreign_keys=ON");
        },
        onCreate: (Database db, int version) => _onCreateDb(db, version));
  }

  void _onCreateDb(Database db, int version) async {
    //if (version < 2) {
    await db.execute('CREATE TABLE $tableNameAccount('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT,'
        '$describe TEXT,'
        '$currencyId INTEGER,'
        '$isDefault INTEGER,'
        '$iconId TEXT,'
        '$balance REAL, '
        'FOREIGN KEY ($currencyId) REFERENCES $tableNameCurrency ($id) '
        'ON DELETE RESTRICT'
        ')');
    await db.execute('CREATE TABLE $tableNameCurrency('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT'
        ')');
    //}
    await db.execute('CREATE TABLE $tableNameCategory('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT,'
        '$describe TEXT,'
        '$idGroup INTEGER,'
        '$isGroup INTEGER,'
        '$groupLevel INTEGER,'
        '$isDebet INTEGER,'
        '$isCredit INTEGER'
        ')');
    await db.execute('CREATE TABLE $tableNamePeople('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT'
        ')');

    await db.execute('CREATE TABLE $tableNameTransact('
        '$id INTEGER PRIMARY KEY,'
        '$name TEXT,'
        '$describe TEXT,'
        '$dateOper TEXT,'
        '$dateCreation TEXT,'
        '$accountId INTEGER,'
        '$typeOper INTEGER,' //0 - ВСЕ, 1 - доход, 2 - расход, 3 - перемещение доход, 4 - перемещение расход, 5 = взаиморасчеты доход, 6  - взаиморасчеты расход

        '$categoryId INTEGER,'
        '$peopleId INTEGER,'
        '$summa REAL,'
        'FOREIGN KEY ($accountId) REFERENCES $tableNameAccount ($id) '
        'ON DELETE RESTRICT, '
        'FOREIGN KEY ($categoryId) REFERENCES $tableNameCategory ($id) '
        'ON DELETE RESTRICT, '
        'FOREIGN KEY ($peopleId) REFERENCES $tableNamePeople ($id) '
        'ON DELETE RESTRICT'
        ')');
  }
}
