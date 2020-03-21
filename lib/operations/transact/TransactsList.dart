import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import 'package:intl/intl.dart';
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';
import 'package:wfmoney6/utils.dart' as utils;

import "TransactsDBWorker.dart";
import "TransactsModel.dart" show Transact, TransactsModel, transactsModel;

class TransactsList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return ScopedModel<TransactsModel>(
        model: transactsModel,
        child: ScopedModelDescendant<TransactsModel>(builder:
            (BuildContext inContext, Widget inChild, TransactsModel inModel) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    transactsModel.entityBeingEdited = Transact(1);
                    //transactsModel.setDateOper(DateFormat.yMMMMd("en_US")
                    //    .format(DateTime.now().toLocal()));
                    transactsModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: transactsModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Transact transact = transactsModel.entityList[inIndex];
                    return Container(
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(children: <Widget>[
                        Divider(
                          color: Colors.white,
                        ),
                        Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Удалить",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      _deleteTransact(inContext, transact))
                            ],
                            child: ListTile(
                                title: Row(children: [
                                  Text(
                                    "${transact.title}",
                                    style: sTextStyleMenu,
                                  ),
                                  Spacer(),
                                  transact.summa == null
                                      ? Text(
                                          "0.00",
                                          style: sTextStyleMenu,
                                        )
                                      : Text(
                                          "${NumberFormat.decimalPattern("ru").format(transact.summa)} ",
                                          style: sTextStyleMenu,
                                        ),
                                  transact.account == null
                                      ? Text(
                                          "",
                                          style: sTextStyleMenu,
                                        )
                                      //    : transact.account.currency == null
                                      //        ? Text("")
                                      : Text(
                                          "${transact.account.currency.title} ",
                                          style: sTextStyleMenu,
                                        ),
                                ]),
                                subtitle: Row(children: [
                                  Text(
                                    "${transact.category.title} ",
                                    style: sTextStyleSubtitle,
                                    softWrap: true,
                                  ),
                                  //    transact.describe == null
                                  //        ? Text("")
                                  //        : Text(
                                  //            "(${transact.describe})",
                                  //            style: sTextStyleSubtitle,
                                  //          ),
                                  Spacer(),
                                  Text(
                                    "${utils.formatDate(transact.dateOper)}",
                                    style: sTextStyleSubtitle,
                                  )
                                ]),
                                onTap: () {
                                  transactsModel.entityBeingEdited =
                                      transactsModel.entityList[inIndex];
                                  print(
                                      "РЕДАКТИРУЕМ ЭЛЕМЕНТ - ${transactsModel.entityBeingEdited} = ${transactsModel.entityBeingEdited.typeOper}");
                                  transactsModel.setStackIndex(1);
                                })),
                        //Divider(
                        //  color: Colors.white,
                        //),
                      ]),
                    );
                  }));
        }));
  }

  /* End build(). */

  Future _deleteTransact(BuildContext inContext, Transact inTransact) async {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Delete Transact"),
              content:
                  Text("Are you sure you want to delete ${inTransact.title}?"),
              actions: [
                FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }),
                FlatButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await TransactsDBWorker().delete(inTransact.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Transact deleted")));
                      // Reload data from database to update list.
                      transactsModel.loadData(1);
                    })
              ]);
        });
  }
/* End _deleteTransact(). */

} /* End class. */
