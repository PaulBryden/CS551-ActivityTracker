import 'package:flutter_app_test/Data/Day.dart';

class Days {
  List<Day> m_days;

  Days(this.m_days);

  Days.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['days'] as List;
    print(list.runtimeType); //returns List<dynamic>

    List<Day> daysList = list.map((i) => Day.fromJson(i)).toList();
    m_days = daysList;
  }

  Map<String, dynamic> toJson() => {'days': m_days};
}
