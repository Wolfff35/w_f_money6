import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "CurrenciesDBWorker.dart";
import "CurrenciesModel.dart" show Currency, CurrenciesModel, currenciesModel;

/// ****************************************************************************
/// The Currencies List sub-screen.
/// ****************************************************************************
class CurrenciesList extends StatelessWidget {
  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## CurrenciesList.build()");

    // Return widget.
    return ScopedModel<CurrenciesModel>(
        model: currenciesModel,
        child: ScopedModelDescendant<CurrenciesModel>(builder:
                (BuildContext inContext, Widget inChild,
                    CurrenciesModel inModel) {
          return Scaffold(
              // Add currency.
              floatingActionButton: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    currenciesModel.entityBeingEdited = Currency(null, null);
                    currenciesModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: currenciesModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Currency currency = currenciesModel.entityList[inIndex];
                    // Determine currency background color (default to white if none was selected).
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Удалить",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      _deleteCurrency(inContext, currency))
                            ],
                            child: Card(
                                elevation: sCardElevation,
                                color: sCardColor,
                                child: ListTile(
                                    title: Text(
                                      "${currency.title}",
                                      style: sTextStyleMenu,
                                    ),
                                    //     subtitle: Text("${currency.content}"),
                                    // Edit existing currency.
                                    onTap: () {
                                      //async {
                                      // Get the data from the database and send to the edit view.
                                      //currenciesModel.entityBeingEdited =
                                      //    await CurrenciesDBWorker()
                                      //        .get(currency.id);
                                      //currenciesModel.setColor(currenciesModel
                                      //    .entityBeingEdited.color);
                                      currenciesModel.entityBeingEdited =
                                          currenciesModel.entityList[inIndex];
                                      print(
                                          "===== === === === === === EDIT ${currenciesModel.entityList[inIndex].toString()}");
                                      currenciesModel.setStackIndex(1);
                                    })) /* End Card. */
                            ) /* End Slidable. */
                        ); /* End Container. */
                  } /* End itemBuilder. */
                  ) /* End End ListView.builder. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder. */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  }

  /* End build(). */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext The BuildContext of the parent Widget.
  /// @param  inCurrency    The currency (potentially) being deleted.
  /// @return           Future.
  Future _deleteCurrency(BuildContext inContext, Currency inCurrency) async {
    print("## CurrenciestList._deleteCurrency(): inCurrency = $inCurrency");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Удаление валюты"),
              content: Text("Точно удалить ${inCurrency.title}?"),
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
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      try {
                        await CurrenciesDBWorker().delete(inCurrency.id);
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Text("Валюта удалена")));
                      } catch (e) {
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content:
                                Text("Не удалось. Есть ссылки на валюту")));
                      }
                      // Reload data from database to update list.

                      currenciesModel.loadData();
                    })
              ]);
        });
  }
/* End _deleteCurrency(). */

} /* End class. */
