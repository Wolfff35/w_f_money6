import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "CurrenciesEntry.dart";
import "CurrenciesList.dart";
import "CurrenciesModel.dart" show CurrenciesModel, currenciesModel;

/// ********************************************************************************************************************
/// The Currencies screen.
/// ********************************************************************************************************************
class Currencies extends StatelessWidget {
  /// Constructor.
  Currencies() {
    print("## Currencies.constructor");

    // Initial load of data.
    currenciesModel.loadData();
    currenciesModel.setStackIndex(
        0); //!!чтоб не возвращаться на несохраненный открытый элемент
  }

  /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## Currencies.build()");

    return Scaffold(
        appBar: AppBar(
          title: Text("Валюты"),
        ),
        body: ScopedModel<CurrenciesModel>(
            model: currenciesModel,
            child: ScopedModelDescendant<CurrenciesModel>(builder:
                    (BuildContext inContext, Widget inChild,
                        CurrenciesModel inModel) {
              return IndexedStack(index: inModel.stackIndex, children: [
                CurrenciesList(),
                CurrenciesEntry()
              ] /* End IndexedStack children. */
                  ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
                ) /* End ScopedModelDescendant. */
            )); /* End ScopedModel. */
  }
/* End build(). */

} /* End class. */
