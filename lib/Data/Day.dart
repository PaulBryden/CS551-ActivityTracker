import 'Goal.dart';

class Day {
  String datetime;
  int steps;
  Goal goal;
  int state;

  Day(this.datetime, this.steps, this.goal, this.state);

  factory Day.fromJson(Map<String, dynamic> parsedJson) {
    return new Day(parsedJson['datetime'], parsedJson['steps'], Goal.fromJson(parsedJson['goal']), parsedJson['state']);
  }

  Map<String, dynamic> toJson() => {'datetime': datetime, 'steps': steps, 'goal': goal, 'state': state};
}
