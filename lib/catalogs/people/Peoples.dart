import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "PeoplesEntry.dart";
import "PeoplesList.dart";
import "PeoplesModel.dart" show PeoplesModel, peoplesModel;

/// ********************************************************************************************************************
/// The Peoples screen.
/// ********************************************************************************************************************
class Peoples extends StatelessWidget {
  /// Constructor.
  Peoples() {
    print("## Peoples.constructor");

    // Initial load of data.
    peoplesModel.loadData();
    peoplesModel.setStackIndex(
        0); //!!чтоб не возвращаться на несохраненный открытый элемент
  }

  /* End constructor. */

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## Peoples.build()");

    return Scaffold(
        appBar: AppBar(
          title: Text("Валюты"),
        ),
        body: ScopedModel<PeoplesModel>(
            model: peoplesModel,
            child: ScopedModelDescendant<PeoplesModel>(builder:
                    (BuildContext inContext, Widget inChild,
                        PeoplesModel inModel) {
              return IndexedStack(index: inModel.stackIndex, children: [
                PeoplesList(),
                PeoplesEntry()
              ] /* End IndexedStack children. */
                  ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
                ) /* End ScopedModelDescendant. */
            )); /* End ScopedModel. */
  }
/* End build(). */

} /* End class. */
