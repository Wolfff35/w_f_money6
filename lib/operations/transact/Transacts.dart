import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "TransactsEntry.dart";
import 'TransactsList.dart';
import "TransactsModel.dart" show TransactsModel, transactsModel;

/// ********************************************************************************************************************
/// The Transacts screen.
/// ********************************************************************************************************************
class Transacts extends StatelessWidget {
  int typeOper;

  /// Constructor.
  Transacts(int typeOper) {
    this.typeOper = typeOper;
    transactsModel.loadData(typeOper);
    transactsModel.setStackIndex(
        0); //!!чтоб не возвращаться на несохраненный открытый элемент
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    return Scaffold(
        appBar: AppBar(
          title: typeOper == 1 ? Text("Доходы") : Text("Расходы"),
        ),
        body: ScopedModel<TransactsModel>(
            model: transactsModel,
            child: ScopedModelDescendant<TransactsModel>(builder:
                    (BuildContext inContext, Widget inChild,
                        TransactsModel inModel) {
              return IndexedStack(index: inModel.stackIndex, children: [
                TransactsList(),
                TransactsEntry()
              ] /* End IndexedStack children. */
                  ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
                ) /* End ScopedModelDescendant. */
            )); /* End ScopedModel. */
  }
/* End build(). */

} /* End class. */
