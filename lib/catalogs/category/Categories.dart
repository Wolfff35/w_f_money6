import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";

import "CategoriesEntry.dart";
import "CategoriesList.dart";
import "CategoriesModel.dart" show CategoriesModel, categoriesModel;

/// ********************************************************************************************************************
/// The Categorys screen.
/// ********************************************************************************************************************
class Categories extends StatelessWidget {
  /// Constructor.
  Categories() {
    categoriesModel.loadData();
    categoriesModel.setStackIndex(
        0); //!!чтоб не возвращаться на несохраненный открытый элемент
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Кошельки"),
        ),
        body: ScopedModel<CategoriesModel>(
            model: categoriesModel,
            child: ScopedModelDescendant<CategoriesModel>(builder:
                    (BuildContext inContext, Widget inChild,
                        CategoriesModel inModel) {
              return IndexedStack(index: inModel.stackIndex, children: [
                CategoriesList(),
                CategoriesEntry()
              ] /* End IndexedStack children. */
                  ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
                ) /* End ScopedModelDescendant. */
            )); /* End ScopedModel. */
  }
/* End build(). */

} /* End class. */
