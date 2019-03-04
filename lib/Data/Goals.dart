import 'package:flutter_app_test/Data/Goal.dart';

class Goals {
  List<Goal> m_goals;

  Goals(this.m_goals);

  Goals.fromJson(Map<String, dynamic> json) {
    var list = json['goals'] as List;

    List<Goal> goalsList = list.map((i) => Goal.fromJson(i)).toList();
    m_goals = goalsList;
  }

  Map<String, dynamic> toJson() => {'goals': m_goals};
}
