import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import 'package:wfmoney6/menus/menu_setings.dart';

import "CategoriesDBWorker.dart";
import "CategoriesModel.dart" show CategoriesModel, categoriesModel;

class CategoriesEntry extends StatelessWidget {
  /// Controllers for TextFields.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _describeEditingController =
      TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Constructor.
  CategoriesEntry() {
    _titleEditingController.addListener(() {
      categoriesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _describeEditingController.addListener(() {
      categoriesModel.entityBeingEdited.describe =
          _describeEditingController.text;
    });
  }

  /* End constructor. */

  Widget build(BuildContext inContext) {
    // Set value of controllers.
    if (categoriesModel.entityBeingEdited != null) {
      _titleEditingController.text = categoriesModel.entityBeingEdited.title;
      _describeEditingController.text =
          categoriesModel.entityBeingEdited.describe;
    }
    // Return widget.
    return ScopedModel(
        model: categoriesModel,
        child: ScopedModelDescendant<CategoriesModel>(builder:
            (BuildContext inContext, Widget inChild, CategoriesModel inModel) {
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
                              "  Отмена   ",
                              style: sTextStyleMenu,
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
                              "  Сохранить",
                              style: sTextStyleMenu,
                            ),
                          ],
                        ),
                        onPressed: () {
                          _save(inContext, categoriesModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
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
                                        hintText: "<Наименование> *"),
                                    controller: _titleEditingController,
                                    validator: (String inValue) {
                                      if (inValue.length == 0) {
                                        return "Введите наименование";
                                      }
                                      return null;
                                    })))),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.description,
                                  color: sIconColor,
                                ),
                                title: TextFormField(
                                  style: sTextStyleMenu,
                                  decoration: InputDecoration(
                                      hintStyle: sTextStyleHint,
                                      hintText: "<Описание>"),
                                  controller: _describeEditingController,
                                )))),

                    // Content.
                    Divider(),
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.edit,
                                  color: sIconColor,
                                ),
                                title: Row(children: <Widget>[
                                  Checkbox(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,

                                    value: categoriesModel.getIsDebet(),
                                    //categorysModel.entityBeingEdited.isDefault,
                                    onChanged: (value) {
                                      categoriesModel.setIsDebet(value);
                                    },
                                  ),
                                  Text(
                                    "Доход?",
                                    style: sTextStyleMenu,
                                  ),
                                  Checkbox(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: categoriesModel.getIsCredit(),
                                    onChanged: (value) {
                                      categoriesModel.setIsCredit(value);
                                    },
                                  ),
                                  Text(
                                    "Расход?",
                                    style: sTextStyleMenu,
                                  )
                                ])))),
                    /*                Container(
                        padding: EdgeInsets.fromLTRB(10, 1, 10, 0),
                        child: Card(
                            color: sCardColor,
                            borderOnForeground: true,
                            child: ListTile(
                                leading: Icon(
                                  Icons.edit,
                                  color: sIconColor,
                                ),
                                title: Row(children: <Widget>[
                                  Checkbox(
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: categoriesModel.getIsGroup(),
                                    onChanged: (value) {
                                      categoriesModel.setIsGroup(value);
                                    },
                                  ),
                                  Text(
                                    "ГРУППА?",
                                    style: sTextStyleMenu,
                                  )

                                ])))),
    */
                  ])));
        }));
  }

  void _save(BuildContext inContext, CategoriesModel inModel) async {
    // Abort if form isn't valid.
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == null) {
      await CategoriesDBWorker().create(categoriesModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      await CategoriesDBWorker().update(categoriesModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    categoriesModel.loadData();

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    Scaffold.of(inContext).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("Category saved")));
  }
/* End _save(). */
} /* End class. */
