import 'package:flutter_app_test/Data/Day.dart';

class Days {
  List<Day> days;

  Days(this.days);

  Days.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['days'] as List;
    print(list.runtimeType); //returns List<dynamic>

    List<Day> daysList = list.map((i) => Day.fromJson(i)).toList();
    days = daysList;
  }

  Map<String, dynamic> toJson() => {'days': days};
}
