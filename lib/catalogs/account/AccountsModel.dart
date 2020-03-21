import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wfmoney6/catalogs/account/AccountsDBWorker.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';

class Account {
  int id;
  String title;
  Currency currency;

  //int currencyId;
  bool isDefault = false;
  Icon icon;
  String describe;
  double balance;

  String toString() {
    return "id=$id, title =$title,  ${currency}, balance - ${balance} |||";
  }
}

class AccountsModel extends Model {
  int stackIndex = 0;
  Account entityBeingEdited; //= new Account();
  List entityList = [];

  void loadData() async {
    await AccountsDBWorker().getAll().then((onValue) {
      print("LOAD DATA  ---------------- ${onValue.toString()}");
      entityList = onValue;
      notifyListeners();
    });
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }

  void setIsDefault(bool inDefault) {
    entityBeingEdited.isDefault = inDefault;
    notifyListeners();
  }

  bool getIsDefault() {
    try {
      return entityBeingEdited.isDefault;
    } catch (e) {
      return false;
    }
  }

  void setCurrency(Currency currency) {
    //entityBeingEdited.currencyId = currency.id;
    entityBeingEdited.currency = currency;
    notifyListeners();
  }

  Currency getCurrency() {
    try {
      return entityBeingEdited.currency;
    } catch (e) {
      return null;
    }
  }

  double getBalance() {
    try {
      return entityBeingEdited.balance;
    } catch (e) {
      return 0.00;
    }
  }
}

AccountsModel accountsModel = AccountsModel();
