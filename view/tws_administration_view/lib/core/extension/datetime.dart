extension DateTimeExtension on DateTime{
  /// [dateOnlyString] set a 'DateOnly' format.
  String get dateOnlyString  => "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  
}