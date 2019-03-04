import 'Goal.dart';

class Day {
  String m_datetime;
  int m_steps;
  Goal m_goal;
  int m_state;

  Day(this.m_datetime, this.m_steps, this.m_goal, this.m_state);

  factory Day.fromJson(Map<String, dynamic> parsedJson) {
    return new Day(parsedJson['datetime'], parsedJson['steps'], Goal.fromJson(parsedJson['goal']), parsedJson['state']);
  }

  Map<String, dynamic> toJson() => {'datetime': m_datetime, 'steps': m_steps, 'goal': m_goal, 'state': m_state};
}
