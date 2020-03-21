import 'dart:async';

import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/catalogs/account/AccountsDBWorker.dart';
import 'package:wfmoney6/catalogs/account/AccountsModel.dart';
import 'package:wfmoney6/catalogs/category/CategoriesDBWorker.dart';
import 'package:wfmoney6/catalogs/category/CategoriesModel.dart';
import 'package:wfmoney6/catalogs/people/PeoplesDBWorker.dart';
import 'package:wfmoney6/catalogs/people/PeoplesModel.dart';
import 'package:wfmoney6/menus/menu_setings.dart';
import 'package:wfmoney6/utils.dart' as utils;

import "TransactsDBWorker.dart";
import "TransactsModel.dart" show TransactsModel, transactsModel;

class TransactsEntry extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _describeEditingController =
      TextEditingController();
  final TextEditingController _summaEditingController = TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  TransactsEntry() {
    _titleEditingController.addListener(() {
      transactsModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _describeEditingController.addListener(() {
      transactsModel.entityBeingEdited.describe =
          _describeEditingController.text;
    });
    _summaEditingController.addListener(() {
      transactsModel.entityBeingEdited.summa =
          double.parse(_summaEditingController.text);
    });
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    // Set value of controllers.
    if (transactsModel.entityBeingEdited != null) {
      _titleEditingController.text = transactsModel.entityBeingEdited.title;
      _describeEditingController.text =
          transactsModel.entityBeingEdited.describe;
      try {
        _summaEditingController.text =
            transactsModel.entityBeingEdited.summa.toString();
      } catch (e) {
        _summaEditingController.text = "0.00";
      }
    }

    // Return widget.
    return ScopedModel(
        model: transactsModel,
        child: ScopedModelDescendant<TransactsModel>(builder:
            (BuildContext inContext, Widget inChild, TransactsModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(children: [
                    FlatButton(
                        color: sCardColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.cancel,
                              color: sIconColor,
                            ),
                            Text(
                              "  Отмена   ",
                              style: sTextStyleMenu,
                            ),
                          ],
                        ),
                        onPressed: () {
                          // Hide soft keyboard.
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          // Go back to the list view.
                          inModel.setStackIndex(0);
                        }),
                    Spacer(),
                    FlatButton(
                        color: sCardColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.save,
                              color: sIconColor,
                            ),
                            Text(
                              "  Сохранить",
                              style: sTextStyleMenu,
                            ),
                          ],
                        ),
                        onPressed: () {
                          _save(inContext, transactsModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.title,
                                  color: sIconColor,
                                ),
                                title: TextFormField(
                                    style: sTextStyleMenu,
                                    decoration: InputDecoration(
                                        hintStyle: sTextStyleSubtitle,
                                        hintText: "<Наименование> *"),
                                    controller: _titleEditingController,
                                    validator: (String inValue) {
                                      if (inValue.length == 0) {
                                        return "Введите наименование";
                                      }
                                      return null;
                                    })))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.description,
                                  color: sIconColor,
                                ),
                                title: TextFormField(
                                  style: sTextStyleMenu,
                                  decoration: InputDecoration(
                                      hintStyle: sTextStyleHint,
                                      hintText: "<Описание>"),
                                  controller: _describeEditingController,
                                )))),

                    Container(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                      child: Card(
                        color: sCardColor,
                        borderOnForeground: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.calendar_today,
                            color: sIconColor,
                          ),
                          title: Row(children: <Widget>[
                            Text(
                              "Дата",
                              style: sTextStyleMenu,
                            ),
                            Spacer(),
                            transactsModel.getDateOper() == ""
                                ? Text("")
                                : Text(
                                    "${transactsModel.entityBeingEdited.dateOper}",
                                    style: sTextStyleMenu,
                                  ),
                          ]),
                          onTap: () async {
                            String _selectedDate = await _selectDate(
                                inContext,
                                transactsModel,
                                transactsModel.entityBeingEdited.dateOper);
                            if (_selectedDate != null) {
                              transactsModel.setDateOper(_selectedDate);
                            }
                          },
                        ),
                      ),
                    ),
                    // Content.
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                      child: Card(
                        color: sCardColor,
                        borderOnForeground: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.euro_symbol,
                            color: sIconColor,
                          ),
                          title: Row(children: <Widget>[
                            Text(
                              "Кошелек",
                              style: sTextStyleMenu,
                            ),
                            Spacer(),
                            transactsModel.getAccount() == null
                                ? Text("")
                                : Text(
                                    "${transactsModel.getAccount().title}",
                                    style: sTextStyleMenu,
                                  ),
                          ]),
                          onTap: () {
                            _selectAccount(inContext, transactsModel);
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                      child: Card(
                        color: sCardColor,
                        borderOnForeground: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.euro_symbol,
                            color: sIconColor,
                          ),
                          title: Row(children: <Widget>[
                            Text(
                              "Статья",
                              style: sTextStyleMenu,
                            ),
                            Spacer(),
                            transactsModel.getCategory() == null
                                ? Text("")
                                : Text(
                                    "${transactsModel.getCategory().title}",
                                    style: sTextStyleMenu,
                                  ),
                          ]),
                          onTap: () {
                            _selectCategory(inContext, transactsModel);
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                      child: Card(
                        color: sCardColor,
                        borderOnForeground: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.euro_symbol,
                            color: sIconColor,
                          ),
                          title: Row(children: <Widget>[
                            Text(
                              "Объект учета",
                              style: sTextStyleMenu,
                            ),
                            Spacer(),
                            transactsModel.getPeople() == null
                                ? Text("")
                                : Text(
                                    "${transactsModel.getPeople().title}",
                                    style: sTextStyleMenu,
                                  ),
                          ]),
                          onTap: () {
                            _selectPeople(inContext, transactsModel);
                          },
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.title,
                                  color: sIconColor,
                                ),
                                title: TextFormField(
                                    style: sTextStyleMenu,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintStyle: sTextStyleSubtitle,
                                        hintText: "<Сумма> *"),
                                    controller: _summaEditingController,
                                    validator: (String inValue) {
                                      if (double.parse(inValue) == null) {
                                        return "Введите сумму";
                                      }
                                      if (double.parse(inValue) == 0.0) {
                                        return "Введите сумму";
                                      }

                                      return null;
                                    })))),
                  ])));
        }));
  }

  void _save(BuildContext inContext, TransactsModel inModel) async {
    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == null) {
      await TransactsDBWorker().create(transactsModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      await TransactsDBWorker().update(transactsModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    transactsModel.loadData(1);

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Transact saved")));
  }

  /* End _save(). */

  Future _selectAccount(BuildContext inContext, TransactsModel inModel) async {
    Account _selectedAccount = await showDialog(
        context: inContext,
        child: new SimpleDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Выбор кошелька",
            style: sTextStyleMenu,
          ),
          children: AccountsDBWorker().getListForSelection(inContext),
        ));
    inModel.setAccount(_selectedAccount);
  }

  Future _selectCategory(BuildContext inContext, TransactsModel inModel) async {
    Category _selectedCategory = await showDialog(
        context: inContext,
        child: new SimpleDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Выбор статьи",
            style: sTextStyleMenu,
          ),
          children: CategoriesDBWorker().getListForSelection(inContext),
        ));
    inModel.setCategory(_selectedCategory);
  }

  Future _selectPeople(BuildContext inContext, TransactsModel inModel) async {
    People _selectedPeople = await showDialog(
        context: inContext,
        child: new SimpleDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Выбор объекта учета",
            style: sTextStyleMenu,
          ),
          children: PeoplesDBWorker().getListForSelection(inContext),
        ));
    inModel.setPeople(_selectedPeople);
  }

  Future _selectDate(BuildContext inContext, TransactsModel inModel,
      String inDateString) async {
    print("## globals.selectDate()");

    // Default to today's date, assuming we're adding.
    DateTime initialDate = DateTime.now();

    // If editing, set the initialDate to the current birthday, if any.
    if (inDateString != null) {
      List dateParts = inDateString.split(",");
      // Create a DateTime using the year, month and day from dateParts.
      initialDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));
    }

    // Now request the date.
    DateTime picked = await showDatePicker(
        context: inContext,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));

    // If they didn't cancel, update it in the model so it shows on the screen and return the string form.
    if (picked != null) {
      inModel.setDateOper("${picked.year},${picked.month},${picked.day}");
      //inModel.setDateOper(DateFormat.yMMMMd("en_US").format(picked.toLocal()));
      return utils
          .formatDateToWrite("${picked.year},${picked.month},${picked.day}");
    }
  }
} /* End class. */
