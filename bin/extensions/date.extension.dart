///
/// Date extension
///
extension Date on DateTime {
  ///
  /// Get the date without time
  ///
  DateTime dateWithoutTime(){
    return DateTime(year, month, day);
  }
}