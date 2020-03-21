import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "CategoriesDBWorker.dart";
import "CategoriesModel.dart" show Category, CategoriesModel, categoriesModel;

class CategoriesList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    return ScopedModel<CategoriesModel>(
        model: categoriesModel,
        child: ScopedModelDescendant<CategoriesModel>(builder:
            (BuildContext inContext, Widget inChild, CategoriesModel inModel) {
          return Scaffold(
              // Add category.
              floatingActionButton: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    categoriesModel.entityBeingEdited = Category();
                    categoriesModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: categoriesModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Category category = categoriesModel.entityList[inIndex];
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 1, 20, 0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Удалить",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () =>
                                      _deleteCategory(inContext, category))
                            ],
                            child: Card(
                                elevation: 8,
                                color: sCardColor,
                                child: ListTile(
                                    title: Row(children: [
                                      Text(
                                        "${category.title}",
                                        style: sTextStyleMenu,
                                      ),
                                      Spacer(),
                                      category.isDebet
                                          ? Text(
                                              "+ ",
                                              style: sTextStyleMenu,
                                            )
                                          : Text(
                                              "",
                                              style: sTextStyleMenu,
                                            ),
                                      category.isCredit
                                          ? Text(
                                              "-",
                                              style: sTextStyleMenu,
                                            )
                                          : Text(
                                              "",
                                              style: sTextStyleMenu,
                                            ),
                                    ]),
                                    subtitle: category.describe == null
                                        ? Text("")
                                        : Text(
                                            "${category.describe}",
                                            style: sTextStyleSubtitle,
                                          ),
                                    onTap: () {
                                      categoriesModel.entityBeingEdited =
                                          categoriesModel.entityList[inIndex];
                                      categoriesModel.setStackIndex(1);
                                    }))));
                  }));
        }));
  }

  /* End build(). */

  Future _deleteCategory(BuildContext inContext, Category inCategory) async {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Удаление статьи"),
              content: Text("Точно удалить ${inCategory.title}?"),
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
                        await CategoriesDBWorker().delete(inCategory.id);
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Text("Статья удалена")));
                      } catch (e) {
                        Navigator.of(inAlertContext).pop();
                        Scaffold.of(inContext).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                            content: Text("Не удалось.Есть ссылки на статью")));
                      }
                      // Reload data from database to update list.

                      categoriesModel.loadData();
                    })
              ]);
        });
  }
/* End _deleteCategory(). */

} /* End class. */
