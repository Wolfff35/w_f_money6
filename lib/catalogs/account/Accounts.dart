import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "AccountsEntry.dart";
import "AccountsList.dart";
import "AccountsModel.dart" show AccountsModel, accountsModel;

/// ********************************************************************************************************************
/// The Accounts screen.
/// ********************************************************************************************************************
class Accounts extends StatelessWidget {
  /// Constructor.
  Accounts() {
    accountsModel.loadData();
    accountsModel.setStackIndex(
        0); //!!чтоб не возвращаться на несохраненный открытый элемент
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Кошельки"),
        ),
        body: ScopedModel<AccountsModel>(
            model: accountsModel,
            child: ScopedModelDescendant<AccountsModel>(builder:
                    (BuildContext inContext, Widget inChild,
                        AccountsModel inModel) {
              return IndexedStack(index: inModel.stackIndex, children: [
                AccountsList(),
                AccountsEntry()
              ] /* End IndexedStack children. */
                  ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
                ) /* End ScopedModelDescendant. */
            )); /* End ScopedModel. */
  }
/* End build(). */

} /* End class. */
