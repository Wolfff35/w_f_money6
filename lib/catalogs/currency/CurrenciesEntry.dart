import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "CurrenciesDBWorker.dart";
import "CurrenciesModel.dart" show CurrenciesModel, currenciesModel;

/// ****************************************************************************
/// The Notes Entry sub-screen.
/// ****************************************************************************
class CurrenciesEntry extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  CurrenciesEntry() {
    print("## CurrenciesEntry.constructor");

    // Attach event listeners to controllers to capture entries in model.
    _titleEditingController.addListener(() {
      currenciesModel.entityBeingEdited.title = _titleEditingController.text;
    });
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    print("## CurrenciesEntry.build()");

    // Set value of controllers.
    if (currenciesModel.entityBeingEdited != null) {
      _titleEditingController.text = currenciesModel.entityBeingEdited.title;
    }

    // Return widget.
    return ScopedModel(
        model: currenciesModel,
        child: ScopedModelDescendant<CurrenciesModel>(builder:
            (BuildContext inContext, Widget inChild, CurrenciesModel inModel) {
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
                          _save(inContext, currenciesModel);
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

  void _save(BuildContext inContext, CurrenciesModel inModel) async {
    print("## CurrenciesEntry._save()");

    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == null) {
      print(
          "## CurrenciesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await CurrenciesDBWorker().create(currenciesModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      print(
          "## CurrenciesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await CurrenciesDBWorker().update(currenciesModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    currenciesModel.loadData();

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Currency saved")));
  }
/* End _save(). */

} /* End class. */
