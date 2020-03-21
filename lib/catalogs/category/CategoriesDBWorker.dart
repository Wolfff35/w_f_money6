import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wfmoney6/db_provider.dart';
import 'package:wfmoney6/menus/menu_setings.dart';

import 'CategoriesModel.dart';

class CategoriesDBWorker {
  Category categoryFromMap(Map inMap) {
    Category category = Category();
    category.id = inMap[DBProvider.id];
    category.title = inMap[DBProvider.name];
    category.describe = inMap[DBProvider.describe];

    category.isDebet = (inMap[DBProvider.isDebet] == 1);
    category.isCredit = (inMap[DBProvider.isCredit] == 1);

    category.isGroup = (inMap[DBProvider.isGroup] == 1);
    category.groupLevel = inMap[DBProvider.groupLevel];
    category.group = new Category();
    category.group.id = inMap["group_id"];
    category.group.title = inMap["group_title"];
    category.group.groupLevel = inMap["group_level"];

    return category;
  }

  Map<String, dynamic> categoryToMap(Category inCategory) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[DBProvider.id] = inCategory.id;
    map[DBProvider.name] = inCategory.title;
    map[DBProvider.describe] = inCategory.describe;
    map[DBProvider.isDebet] = inCategory.isDebet ? 1 : 0;
    map[DBProvider.isCredit] = inCategory.isCredit ? 1 : 0;

    map[DBProvider.isGroup] = inCategory.isGroup ? 1 : 0;
    map[DBProvider.groupLevel] = inCategory.groupLevel;
    map[DBProvider.idGroup] =
        inCategory.group == null ? 0 : (inCategory.group.id);
    return map;
  }

  Future create(Category inCategory) async {
    Database db = await DBProvider.instance.database;
    var val = await db.rawQuery(
        "SELECT MAX(${DBProvider.id})+1 AS ${DBProvider.id} FROM ${DBProvider.tableNameCategory}");
    int id = val.first[DBProvider.id];
    if (id == null) {
      id = 1;
    }
    return await db.rawInsert(
        "INSERT INTO ${DBProvider.tableNameCategory} (${DBProvider.id},"
        "${DBProvider.name},"
        "${DBProvider.describe},"
        "${DBProvider.isDebet},"
        "${DBProvider.isCredit},"
        "${DBProvider.idGroup},"
        "${DBProvider.isGroup},"
        "${DBProvider.groupLevel}"
        ") VALUES (?,?,?,?,?,?,?,?)",
        [
          inCategory.id,
          inCategory.title,
          inCategory.describe,
          inCategory.isDebet ? 1 : 0,
          inCategory.isCredit ? 1 : 0,
          inCategory.group == null ? 0 : inCategory.group.id,
          inCategory.group == null ? 0 : inCategory.groupLevel
        ]);
  }

  Future<Category> get(int inID) async {
    Database db = await DBProvider.instance.database;
    var rec = await db.query(DBProvider.tableNameCategory,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
    return categoryFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await DBProvider.instance.database;
    var recs = await db.query(DBProvider.tableNameCategory);
    var list =
        recs.isNotEmpty ? recs.map((m) => categoryFromMap(m)).toList() : [];
    print("############### GET ALL COUNT ${list.length}");
    return list;
  }

  Future update(Category inCategory) async {
    Database db = await DBProvider.instance.database;
    return await db.update(
        DBProvider.tableNameCategory, categoryToMap(inCategory),
        where: "${DBProvider.id}= ?", whereArgs: [inCategory.id]);
  }

  Future delete(int inID) async {
    Database db = await DBProvider.instance.database;
    return await db.delete(DBProvider.tableNameCategory,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
  }

  List<Widget> getListForSelection(BuildContext inContext) {
    List<Widget> ll = new List();
    getAll().then((listCateg) {
      //print(
      //    "===========================================${listCurr.toString()}");
      listCateg.forEach((f) {
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

  Category import_fromJson(Map<String, dynamic> json) {
    //return
    Category _item = new Category();
    _item.id = json['id'];
    _item.title = json['name'];
    _item.group = new Category();
    _item.group.id = json["parentId"];
    _item.isDebet = json["type"] == 1;
    _item.isCredit = json["type"] == 2;
    if (json["available"] == 1) {
      return _item;
    } else {
      return null;
    }
  }
}
