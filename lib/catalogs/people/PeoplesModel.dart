import 'package:scoped_model/scoped_model.dart';
import 'package:wfmoney6/catalogs/people/PeoplesDBWorker.dart';

class People {
  int id;
  String title;

  //People(){};
  People(int id, String title) {
    this.id = id;
    this.title = title;
  }

  String toString() {
    return " PEOPLE - {id=$id, title=$title}";
  }
}

class PeoplesModel extends Model {
  int stackIndex = 0;
  var entityBeingEdited;
  List entityList = [];

  void loadData() async {
    //void loadData(String inEntityType, dynamic inDatabase) async {
    entityList = await PeoplesDBWorker().getAll();
    notifyListeners();
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }
}

PeoplesModel peoplesModel = PeoplesModel();
