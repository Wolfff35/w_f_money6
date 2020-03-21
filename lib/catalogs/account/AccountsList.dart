import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "AccountsDBWorker.dart";
import "AccountsModel.dart" show Account, AccountsModel, accountsModel;

class AccountsList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    //accountsModel.notifyListeners();
    // Return widget.
    return ScopedModel<AccountsModel>(
        model: accountsModel,
        child: ScopedModelDescendant<AccountsModel>(builder:
            (BuildContext inContext, Widget inChild, AccountsModel inModel) {
          return Scaffold(
              // Add account.
              floatingActionButton: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    accountsModel.entityBeingEdited = Account();
                    accountsModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: accountsModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Account account = accountsModel.entityList[inIndex];
                    //accountsModel.notifyListeners();
                    return Container(
                        //color: Colors.black,
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Удалить",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      _deleteAccount(inContext, account))
                            ],
                            child: Card(
                                elevation: 8,
                                color: sCardColor,
                                child: ListTile(
                                    title: Row(children: [
                                      Text(
                                        "${account.title}",
                                        style: account.isDefault
                                            ? sTextStyleMenuRed
                                            : sTextStyleMenu,
                                      ),
                                      Spacer(),
                                      account.balance == null
                                          ? Text(
                                              "0.00 ",
                                              style: sTextStyleMenu,
                                            )
                                          : Text(
                                              "${account.balance} ",
                                              style: sTextStyleMenu,
                                            ),
                                      account.currency == null
                                          ? Text(
                                              "",
                                              style: sTextStyleMenu,
                                            )
                                          : Text(
                                              "${account.currency.title} ",
                                              style: sTextStyleMenu,
                                            ),
                                    ]),
                                    subtitle: account.describe == null
                                        ? Text("")
                                        : Text(
                                            "${account.describe}",
                                            style: sTextStyleSubtitle,
                                          ),
                                    onTap: () {
                                      accountsModel.entityBeingEdited =
                                          accountsModel.entityList[inIndex];
                                      print(
                                          "РЕДАКТИРУЕМ ЭЛЕМЕНТ - ${accountsModel.entityBeingEdited}");
                                      accountsModel.setStackIndex(1);
                                    }))));
                  }));
        }));
  }

  /* End build(). */

  Future _deleteAccount(BuildContext inContext, Account inAccount) async {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Удаление кошелька"),
              content: Text("Точно удалить ${inAccount.title}?"),
              actions: [
                FlatButton(
                    child: Text("Отмена"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }),
                FlatButton(
                    child: Text("Удалить"),
                    onPressed: () async {
                      try {
                        // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                        await AccountsDBWorker().delete(inAccount.id);
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Text("Кошелек удален")));
                      } catch (e) {
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content:
                                Text("Не удалось. Есть ссылки на кошелек")));
                      }
                      // Reload data from database to update list.
                      accountsModel.loadData();
                    })
              ]);
        });
  }
/* End _deleteAccount(). */

} /* End class. */
