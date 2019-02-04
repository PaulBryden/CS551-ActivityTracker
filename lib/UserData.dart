import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'Day.dart';
import 'Days.dart';
import 'Goal.dart';
import 'Goals.dart';
import 'Settings.dart';

class UserData {

  static final UserData _singleton = new UserData._internal();
  Goal defaultGoal = new Goal("Default",10000);
  Goals goals = new Goals([]);
  Days days = new Days([]);
  Settings settings = new Settings(false, false);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileGoals async {
    final path = await _localPath;
    return File('$path/goals.json');
  }

  Future<File> get _localFileSettings async {
    final path = await _localPath;
    return File('$path/settings.json');
  }

  Future<File> get _localFileDays async {
    final path = await _localPath;
    return File('$path/days.json');
  }

  Future<String> readFile(String filename) async {
    //final file = await _localFileDays;
    switch (filename) {
      case "goals":
        final file = await _localFileGoals;
        return await file.readAsString();
        break;
      case "days":
        final file = await _localFileDays;
        return await file.readAsString();
        break;
      case "settings":
        final file = await _localFileSettings;
        return await file.readAsString();
        break;
      default:
        final file = await _localFileDays;
        return await file.readAsString();
        break;
    }
  }

  Future<File> writeFile(String filename) async {
    switch (filename) {
      case "goals":
        final file = await _localFileGoals;
        return file.writeAsString(jsonEncode(goals));
        break;
      case "days":
        final file = await _localFileDays;
        return file.writeAsString(jsonEncode(days));
        break;
      case "settings":
        final file = await _localFileSettings;
        return file.writeAsString(jsonEncode(settings));
        break;
      default:
        final file = await _localFileGoals;
        return file.writeAsString(goals.toJson().toString());
        break;
    }
  }

  void loadAllData() async {
    try {
      goals = Goals.fromJson(jsonDecode((await readFile("goals"))));
    } catch (e) {
      goals.goals.add(defaultGoal);
      writeFile("goals");
    }

    try {
      days = Days.fromJson(jsonDecode((await readFile("days"))));
    } catch (e) {
      writeFile("days");
    }

    try {
      settings = Settings.fromJson(jsonDecode((await readFile("settings"))));
    } catch (e) {
      writeFile("settings");
    }
    print(goals.toString() + days.toString() + settings.toString());
  }

  List<Goal> getGoals() {
    return new List<Goal>();
  }

  void addGoal(Goal) async {
    goals.goals.add(Goal);
    await writeFile("goals");
  }

  void removeGoal(goalVar) async {
    for (var eGoal in goals.goals) {
      if (eGoal.name == goalVar.name) {
        goals.goals.remove(eGoal);
        break;
      }
    }
    await writeFile("goals");
  }

  void updateGoal(goalVar) async {
    for (var eGoal in goals.goals) {
      if (eGoal.name == goalVar.name) {
        eGoal = goalVar;
        break;
      }
    }
    await writeFile("goals");
  }

  void updateDay(dayVar) async {
    for (var eDay in days.days) {
      if (eDay.datetime == dayVar.datetime) {
        eDay = dayVar;
        break;
      }
    }
    await writeFile("days");
  }

  Day getDay(String datetime) {
    Day day = null;
    for (var eDay in days.days) {
      if (eDay.datetime == datetime) {
        day = eDay;
        break;
      }
    }
    if (day != null) {
      return day;
    }
    else
      {
      day = new Day(datetime,0,defaultGoal);
      days.days.add(day);
      writeFile("days");
      return day;
    }
  }

  Days getAllDays() {
    return days;
  }

  void updateAllDays(Days) async {
    days = Days;
    await writeFile("days");
  }

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}
