import 'Goal.dart';

class Goals {
  List<Goal> goals;

  Goals(this.goals);

  Goals.fromJson(Map<String, dynamic> json) {
    var list = json['goals'] as List;

    List<Goal> goalsList = list.map((i) => Goal.fromJson(i)).toList();
    goals = goalsList;
  }

  Map<String, dynamic> toJson() => {'goals': goals};
}
