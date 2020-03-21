import 'package:scoped_model/scoped_model.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesDBWorker.dart';

class Currency {
  int id;
  String title;

  //Currency(){};
  Currency(int id, String title) {
    this.id = id;
    this.title = title;
  }

  String toString() {
    return " CURRENCY - {id=$id, title=$title}";
  }
}

class CurrenciesModel extends Model {
  int stackIndex = 0;
  var entityBeingEdited;
  List entityList = [];

  void loadData() async {
    //void loadData(String inEntityType, dynamic inDatabase) async {
    entityList = await CurrenciesDBWorker().getAll();
    notifyListeners();
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }
}

CurrenciesModel currenciesModel = CurrenciesModel();
