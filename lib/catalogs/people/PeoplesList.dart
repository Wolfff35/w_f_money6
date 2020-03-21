import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "PeoplesDBWorker.dart";
import "PeoplesModel.dart" show People, PeoplesModel, peoplesModel;

class PeoplesList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    // Return widget.
    return ScopedModel<PeoplesModel>(
        model: peoplesModel,
        child: ScopedModelDescendant<PeoplesModel>(builder:
                (BuildContext inContext, Widget inChild, PeoplesModel inModel) {
          return Scaffold(
              // Add people.
              floatingActionButton: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    peoplesModel.entityBeingEdited = People(null, null);
                    peoplesModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: peoplesModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    People people = peoplesModel.entityList[inIndex];
                    // Determine people background color (default to white if none was selected).
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
                                  onTap: () => _deletePeople(inContext, people))
                            ],
                            child: Card(
                                elevation: sCardElevation,
                                color: sCardColor,
                                child: ListTile(
                                    title: Text(
                                      "${people.title} - ${people.id}",
                                      style: sTextStyleMenu,
                                    ),
                                    onTap: () {
                                      peoplesModel.entityBeingEdited =
                                          peoplesModel.entityList[inIndex];
                                      peoplesModel.setStackIndex(1);
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

  Future _deletePeople(BuildContext inContext, People inPeople) async {
    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(
              title: Text("Удаление объекта учета"),
              content: Text("Точно удалить ${inPeople.title}?"),
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
                      await PeoplesDBWorker().delete(inPeople.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Объект учета удален")));
                      // Reload data from database to update list.
                      peoplesModel.loadData();
                    })
              ]);
        });
  }
/* End _deletePeople(). */

} /* End class. */
