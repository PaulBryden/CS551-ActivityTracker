import 'Goal.dart';

class Day {
  String datetime;
  int steps;
  Goal goal;

  Day(this.datetime, this.steps, this.goal);

/*
  Day.fromJson(Map<String, dynamic> json)
      : datetime = json['datetime'],
        steps = json['steps'],
        goal = json['goal'];*/
  factory Day.fromJson(Map<String, dynamic> parsedJson) {
    return new Day(parsedJson['datetime'], parsedJson['steps'],
        Goal.fromJson(parsedJson['goal']));
  }

  Map<String, dynamic> toJson() =>
      {'datetime': datetime, 'steps': steps, 'goal': goal};
}
