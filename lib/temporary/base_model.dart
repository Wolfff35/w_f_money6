/*class BaseModel extends Model {
  int stackIndex = 0;
  var entityBeingEdited;
  List entityList = [];
  String chosenDate;

  /// For display of the date chosen by the user.
  ///
  /// @param inDate The date in MM/DD/YYYY form.
  void setChosenDate(String inDate) {
    print("## BaseModel.setChosenDate(): inDate = $inDate");

    chosenDate = inDate;
    notifyListeners();
  } /* End setChosenDate(). */

  void loadData(dynamic inDatabase) async {
    //void loadData(String inEntityType, dynamic inDatabase) async {
    print("################################ " + inDatabase.toString());
    entityList = await inDatabase.getAll(DBProvider.tableNameCurrency);
    notifyListeners();
  }

  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }
}*/
