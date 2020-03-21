import 'dart:async';

import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/catalogs/currency/CurrenciesDBWorker.dart';
import 'package:wfmoney6/catalogs/currency/CurrenciesModel.dart';
import 'package:wfmoney6/menus/menu_setings.dart';

import "AccountsDBWorker.dart";
import "AccountsModel.dart" show AccountsModel, accountsModel;

class AccountsEntry extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _describeEditingController =
      TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  AccountsEntry() {
    _titleEditingController.addListener(() {
      accountsModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _describeEditingController.addListener(() {
      accountsModel.entityBeingEdited.describe =
          _describeEditingController.text;
    });
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    // Set value of controllers.
    if (accountsModel.entityBeingEdited != null) {
      _titleEditingController.text = accountsModel.entityBeingEdited.title;
      _describeEditingController.text =
          accountsModel.entityBeingEdited.describe;
    }

    // Return widget.
    return ScopedModel(
        model: accountsModel,
        child: ScopedModelDescendant<AccountsModel>(builder:
            (BuildContext inContext, Widget inChild, AccountsModel inModel) {
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
                          _save(inContext, accountsModel);
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
                              "Валюта",
                              style: sTextStyleMenu,
                            ),
                            Spacer(),
                            accountsModel.getCurrency() == null
                                ? Text("")
                                : Text(
                                    "${accountsModel.getCurrency().title}",
                                    style: sTextStyleMenu,
                                  ),
                          ]),
                          onTap: () {
                            _selectCurrency(inContext, accountsModel);
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
                                Icons.account_balance_wallet,
                                color: sIconColor,
                              ),
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    "Сумма",
                                    style: sTextStyleMenu,
                                  ),
                                  Spacer(),
                                  (accountsModel.getBalance() == null
                                      ? Text(
                                          "0.00",
                                          style: sTextStyleMenu,
                                        )
                                      : Text(
                                          "${accountsModel.getBalance()}",
                                          style: sTextStyleMenu,
                                        )),
                                ],
                                //Text(
                                //"Сумма: ${accountsModel.getBalance()}",
                                //style: s_TextStyleMenu,
                              ),
                            ))),
                    Divider(),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.edit,
                                  color: sIconColor,
                                ),
                                title: Row(children: <Widget>[
                                  Checkbox(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,

                                    value: accountsModel.getIsDefault(),
                                    //accountsModel.entityBeingEdited.isDefault,
                                    onChanged: (value) {
                                      accountsModel.setIsDefault(value);
                                    },
                                  ),
                                  Text(
                                    "По умолчанию?",
                                    style: sTextStyleMenu,
                                  )
                                ])))),
                  ])));
        }));
  }

  void _save(BuildContext inContext, AccountsModel inModel) async {
    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == null) {
      await AccountsDBWorker().create(accountsModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      await AccountsDBWorker().update(accountsModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    accountsModel.loadData();

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Account saved")));
  }

  /* End _save(). */

  Future _selectCurrency(BuildContext inContext, AccountsModel inModel) async {
    Currency _selectedCurrency = await showDialog(
        context: inContext,
        child: new SimpleDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Выбор валюты",
            style: sTextStyleMenu,
          ),
          children: CurrenciesDBWorker().getListForSelection(inContext),
        ));
    inModel.setCurrency(_selectedCurrency);
  }
} /* End class. */
