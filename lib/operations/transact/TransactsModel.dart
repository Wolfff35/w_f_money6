import 'package:scoped_model/scoped_model.dart';
import 'package:wfmoney6/catalogs/account/AccountsModel.dart';
import 'package:wfmoney6/catalogs/category/CategoriesModel.dart';
import 'package:wfmoney6/catalogs/people/PeoplesModel.dart';

import 'TransactsDBWorker.dart';

class Transact {
  int id;
  String title;

  String describe;

  Account account;

  //int accountId;

  double summa;

  Category category;

  //int categoryId;

  People people;

  //int peopleId;

  String dateOper;
  String dateCreation;
  int typeOper;

  Transact(int typeOper) {
    this.typeOper = typeOper;
    if (this.summa == null) this.summa = 0.00;
  }

  String toString() {
    return "# id - $id, "
            "# title - $title, "
            //"# describe      - $describe, "
            "# account       - ${account.toString()}, "
        //"# category      - ${category.toString()}, "
        //"# people        - ${people.toString()}, "
        //"# summa - ${summa}, "
        //"# dateOper      - ${dateOper}, "
        //"# dateCreation  - ${dateCreation}, "
        //"# typeOper - ${typeOper}"
        ;
  }
}

class TransactsModel extends Model {
  int stackIndex = 0;
  Transact entityBeingEdited; //= new Account();
  List entityList = [];

  void loadData(int typeOper) async {
    await TransactsDBWorker().getAll(typeOper).then((onValue) {
      entityList = onValue;
      print("++++++++++++++++++++++++++++++++++++++ - ${entityList.length}");
      notifyListeners();
    });
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }

  void setAccount(Account account) {
    //entityBeingEdited.accountId = account.id;
    entityBeingEdited.account = account;
    notifyListeners();
  }

  Account getAccount() {
    try {
      return entityBeingEdited.account;
    } catch (e) {
      return null;
    }
  }

  double getSumma() {
    try {
      return entityBeingEdited.summa;
    } catch (e) {
      return 0.00;
    }
  }

  void setCategory(Category category) {
    // entityBeingEdited.categoryId = category.id;
    entityBeingEdited.category = category;
    notifyListeners();
  }

  Category getCategory() {
    try {
      return entityBeingEdited.category;
    } catch (e) {
      return null;
    }
  }

  void setPeople(People people) {
    //entityBeingEdited.peopleId = people.id;
    entityBeingEdited.people = people;
    notifyListeners();
  }

  People getPeople() {
    try {
      return entityBeingEdited.people;
    } catch (e) {
      return null;
    }
  }

  void setDateOper(String dateOper) {
    entityBeingEdited.dateOper = dateOper;
    notifyListeners();
  }

  String getDateOper() {
    try {
      return entityBeingEdited.dateOper;
    } catch (e) {
      return "";
    }
  }

  void setTypeOper(int typeOper) {
    entityBeingEdited.typeOper = typeOper;
  }
}

TransactsModel transactsModel = TransactsModel();
