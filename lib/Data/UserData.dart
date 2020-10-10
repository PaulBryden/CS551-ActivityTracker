import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'Day.dart';
import 'DayState.dart';
import 'Days.dart';
import 'Goal.dart';
import 'Goals.dart';
import 'Settings.dart';

class UserData {
  static final UserData _singleton = new UserData._internal();
  Goal m_defaultGoal = new Goal("Default", 10000);
  Goals m_goals = new Goals([]);
  Days m_days = new Days([]);
  Settings m_settings = new Settings(false, false, false);

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
        return file.writeAsString(jsonEncode(m_goals));
        break;
      case "days":
        final file = await _localFileDays;
        return file.writeAsString(jsonEncode(m_days));
        break;
      case "settings":
        final file = await _localFileSettings;
        return file.writeAsString(jsonEncode(m_settings));
        break;
      default:
        final file = await _localFileGoals;
        return file.writeAsString(m_goals.toJson().toString());
        break;
    }
  }

  void loadAllData() async {
    try {
      m_goals = Goals.fromJson(jsonDecode((await readFile("goals"))));
    } catch (e) {
      m_goals.m_goals.add(m_defaultGoal);
      writeFile("goals");
    }

    try {
      m_days = Days.fromJson(jsonDecode((await readFile("days"))));
    } catch (e) {
      writeFile("days");
    }

    try {
      m_settings = Settings.fromJson(jsonDecode((await readFile("settings"))));
    } catch (e) {
      writeFile("settings");
    }
    print(m_goals.toString() + m_days.toString() + m_settings.toString());
  }

  List<Goal> getGoals() {
    return m_goals.m_goals;
  }

  void addGoal(Goal) async {
    m_goals.m_goals.add(Goal);
    await writeFile("goals");
  }

  void removeGoal(goalVar) async {
    for (var eGoal in m_goals.m_goals) {
      if (eGoal.m_name == goalVar.m_name) {
        m_goals.m_goals.remove(eGoal);
        break;
      }
    }
    await writeFile("goals");
  }

  void updateGoal(var goalVar, var newGoal) async {
    bool found = false;
    for (var eGoal in m_goals.m_goals) {
      if (eGoal.m_name.compareTo(goalVar.m_name) == 0) {
        found = true;
        eGoal.m_name = newGoal.m_name;
        eGoal.m_target = newGoal.m_target;
        break;
      }
    }
    if (!found) {
      addGoal(newGoal);
    }
    await writeFile("goals");
  }

  void updateDay(dayVar) async {
    for (var eDay in m_days.m_days) {
      if (eDay.m_datetime == dayVar.m_datetime) {
        eDay = dayVar;
        break;
      }
    }
    await writeFile("days");
  }

  void updateGoalModification(modVar) async
  {
    m_settings.m_goalMod=modVar;
    await writeFile("settings");
  }

  void updateHistoryModification(modVar) async
  {
    m_settings.m_historyMod=modVar;
    await writeFile("settings");
  }

  void updateNotificationModification(modVar) async
  {
    m_settings.m_notificationsMod=modVar;
    await writeFile("settings");
  }

  bool getGoalModification()
  {
    return m_settings.m_goalMod;
  }

  bool getHistoryModification()
  {
    return m_settings.m_historyMod;
  }

  bool getNotificationModification()
  {
    return m_settings.m_notificationsMod;
  }

  Goal getGoal(String goalName) {
    Goal goal = null;
    for (var eGoal in m_goals.m_goals) {
      if (eGoal.m_name == goalName) {
        return eGoal;
      }
    }
    return new Goal("No Goal Selected", 0);
  }

  Day getDay(String datetime) {
    Day day = null;
    for (var eDay in m_days.m_days) {
      if (eDay.m_datetime == datetime) {
        day = eDay;
        break;
      }
    }
    if (day != null) {
      return day;
    } else {
      day = new Day(datetime, 0, new Goal("No Goal Selected", 0), DayState.NoGoal);
      m_days.m_days.add(day);
      writeFile("days");
      return day;
    }
  }

  Days getAllDays() {
    return m_days;
  }

  void updateAllDays(Days) async {
    m_days = Days;
    await writeFile("days");
  }

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}
