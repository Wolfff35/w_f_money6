import 'package:scoped_model/scoped_model.dart';

import 'CategoriesDBWorker.dart';

class Category {
  int id;
  String title;
  String describe;
  bool isDebet = false;
  bool isCredit = false;
  bool isGroup = false;
  Category group;
  int groupLevel;

  String toString() {
    return "id=$id, title =$title, credit - ${isCredit}, debet - ${isDebet} |||";
  }
}

class CategoriesModel extends Model {
  int stackIndex = 0;
  Category entityBeingEdited;
  List entityList = [];

  void loadData() async {
    await CategoriesDBWorker().getAll().then((onValue) {
      print("LOAD DATA  ---------------- ${onValue.toString()}");
      entityList = onValue;
      notifyListeners();
    });
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }

  void setIsDebet(bool inDebet) {
    entityBeingEdited.isDebet = inDebet;
    if (inDebet) {
      entityBeingEdited.isGroup = false;
    }
    notifyListeners();
  }

  bool getIsDebet() {
    try {
      return entityBeingEdited.isDebet;
    } catch (e) {
      return false;
    }
  }

  void setIsCredit(bool inCredit) {
    entityBeingEdited.isCredit = inCredit;
    if (inCredit) {
      entityBeingEdited.isGroup = false;
    }
    notifyListeners();
  }

  bool getIsCredit() {
    try {
      return entityBeingEdited.isCredit;
    } catch (e) {
      return false;
    }
  }

  void setGroup(Category group) {
    entityBeingEdited.group = group;
    if (group != null) {
      entityBeingEdited.groupLevel = group.groupLevel + 1;
    } else {
      entityBeingEdited.groupLevel = 0;
    }
    notifyListeners();
  }

  Category getGroup() {
    try {
      return entityBeingEdited.group;
    } catch (e) {
      return null;
    }
  }

  void setIsGroup(bool isGroup) {
    entityBeingEdited.isGroup = isGroup;
    if (isGroup) {
      entityBeingEdited.isDebet = false;
      entityBeingEdited.isCredit = false;
    }
    notifyListeners();
  }

  bool getIsGroup() {
    try {
      return entityBeingEdited.isGroup;
    } catch (e) {
      return false;
    }
  }
}

CategoriesModel categoriesModel = CategoriesModel();
