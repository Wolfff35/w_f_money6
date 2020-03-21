import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wfmoney6/catalogs/people/PeoplesModel.dart';
import 'package:wfmoney6/db_provider.dart';
import 'package:wfmoney6/menus/menu_setings.dart';

class PeoplesDBWorker {
  People peopleFromMap(Map inMap) {
    People people = People(inMap[DBProvider.id], inMap[DBProvider.name]);
    return people;
  }

  Map<String, dynamic> peopleToMap(People inPeople) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[DBProvider.id] = inPeople.id;
    map[DBProvider.name] = inPeople.title;
    return map;
  }

  Future create(People inPeople) async {
    Database db = await DBProvider.instance.database;
    var val = await db.rawQuery(
        "SELECT MAX(${DBProvider.id})+1 AS ${DBProvider.id} FROM ${DBProvider.tableNamePeople}");
    int id = val.first[DBProvider.id];
    if (id == null) {
      id = 1;
    }
    return await db.rawInsert(
        "INSERT INTO ${DBProvider.tableNamePeople} (${DBProvider.id}, ${DBProvider.name}) VALUES (?,?)",
        [inPeople.id, inPeople.title]);
  }

  Future<People> get(int inID) async {
    Database db = await DBProvider.instance.database;
    var rec = await db.query(DBProvider.tableNamePeople,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
    return peopleFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await DBProvider.instance.database;
    var recs = await db.query(DBProvider.tableNamePeople);
    var list =
        recs.isNotEmpty ? recs.map((m) => peopleFromMap(m)).toList() : [];
    return list;
  }

  Future update(People inPeople) async {
    Database db = await DBProvider.instance.database;
    return await db.update(DBProvider.tableNamePeople, peopleToMap(inPeople),
        where: "${DBProvider.id}= ?", whereArgs: [inPeople.id]);
  }

  Future delete(int inID) async {
    Database db = await DBProvider.instance.database;
    return await db.delete(DBProvider.tableNamePeople,
        where: "${DBProvider.id}= ?", whereArgs: [inID]);
  }

  List<Widget> getListForSelection(BuildContext inContext) {
    List<Widget> ll = new List();
    PeoplesDBWorker().getAll().then((listCurr) {
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
}
