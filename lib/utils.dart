/// ********************************************************************************************************************
/// A few global utility-type things needed by multiple places in the codebase.
/// ********************************************************************************************************************

import "dart:io";

/// The application's document directory for contact avatar image files and database files.
Directory docsDir;

String formatDate(String dateO) {
  //return dateO;
  print("dateO = $dateO");
  List<String> _dat = dateO.split(",");
  String _dd = _dat[2].length < 2 ? "0${_dat[2]}" : "${_dat[2]}";
  String _mm = _dat[1].length < 2 ? "0${_dat[1]}" : "${_dat[1]}";
  return "${_dd}. ${_mm}. ${_dat[0]}";
}

String formatDateToWrite(String dateO) {
  //return dateO;
  print("dateO = $dateO");
  List<String> _dat = dateO.split(",");
  String _dd = _dat[2].length < 2 ? "0${_dat[2]}" : "${_dat[2]}";
  String _mm = _dat[1].length < 2 ? "0${_dat[1]}" : "${_dat[1]}";
  return "${_dat[0]},${_mm},${_dd}";
}
