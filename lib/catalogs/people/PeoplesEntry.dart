import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "PeoplesDBWorker.dart";
import "PeoplesModel.dart" show PeoplesModel, peoplesModel;

/// ****************************************************************************
/// The Notes Entry sub-screen.
/// ****************************************************************************
class PeoplesEntry extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  PeoplesEntry() {
    print("## PeoplesEntry.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      peoplesModel.entityBeingEdited.title = _titleEditingController.text;
    });
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    print("## PeoplesEntry.build()");

    // Set value of controllers.
    if (peoplesModel.entityBeingEdited != null) {
      _titleEditingController.text = peoplesModel.entityBeingEdited.title;
    }

    // Return widget.
    return ScopedModel(
        model: peoplesModel,
        child: ScopedModelDescendant<PeoplesModel>(builder:
            (BuildContext inContext, Widget inChild, PeoplesModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(children: [
                    FlatButton(
                        color: sCardColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.cancel,
                              color: sIconColor,
                            ),
                            Text(
                              "Отмена   ",
                              style: sTextStyleSubtitle,
                            ),
                          ],
                        ),
                        onPressed: () {
                          // Hide soft keyboard.
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          // Go back to the list view.
                          inModel.setStackIndex(0);
                        }),
                    Spacer(),
                    FlatButton(
                        color: sCardColor,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.save,
                              color: sIconColor,
                            ),
                            Text(
                              "Сохранить",
                              style: sTextStyleSubtitle,
                            ),
                          ],
                        ),
                        onPressed: () {
                          _save(inContext, peoplesModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.title,
                                  color: sIconColor,
                                ),
                                title: TextFormField(
                                    style: sTextStyleMenu,
                                    decoration: InputDecoration(
                                      hintStyle: sTextStyleSubtitle,
                                      hintText: "<Наименование> *",
                                      // enabledBorder: UnderlineInputBorder(
                                      //     borderSide:
                                      //         BorderSide(color: Colors.white)),
                                    ),
                                    controller: _titleEditingController,
                                    validator: (String inValue) {
                                      if (inValue.length == 0) {
                                        return "Введите наименование";
                                      }
                                      return null;
                                    })))),
                    // Content.
                  ])));
        }));
  }

  void _save(BuildContext inContext, PeoplesModel inModel) async {
    print("## PeoplesEntry._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == null) {
      print("## PeoplesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await PeoplesDBWorker().create(peoplesModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      print("## PeoplesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await PeoplesDBWorker().update(peoplesModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    peoplesModel.loadData();

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("People saved")));
  }
/* End _save(). */

} /* End class. */
