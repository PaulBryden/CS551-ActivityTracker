import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/DayState.dart';
import 'package:flutter_app_test/Data/Goal.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Notifications/MotivationNotification.dart';
import 'package:flutter_app_test/Widgets/GaugeChart.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';
import 'package:intl/intl.dart';

class ActivityPage extends StatefulWidget {
  ActivityPage({Key key, this.m_title, this.m_datetimePage, this.m_isHome}) : super(key: key);
  /*Data to be passed in on page creation for use by widgets on the page*/
  final String m_title;
  String m_datetimePage;
  bool m_isHome;

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  /*Persistent Variables across rebuilds*/
  final m_textController = TextEditingController();
  var m_dataPtr = new UserData();
  var m_now = new DateTime.now();
  var m_formatter = new DateFormat('yyyy-MM-dd');
  Day m_currentDay;
  List<Goal> m_currGoals;
  String m_selectedGoal;
  List<DropdownMenuItem<String>> m_dropDownGoals;
  MotivationNotification m_notificationWrap = new MotivationNotification();
  final GlobalKey<ScaffoldState> m_scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    /*Variables that need to be initialized on every refresh, as data is not static.*/
    m_currentDay = m_dataPtr.getDay(widget.m_datetimePage);
    m_selectedGoal = m_currentDay.m_goal.m_name;
    m_dropDownGoals = getDropDownGoals();
    return new Scaffold(
      key: m_scaffoldKey,
      drawer: widget.m_isHome ? GlobDrawer() : new Container(),
      appBar: !widget.m_isHome
          ? AppBar(
              title: Text(widget.m_title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
          : AppBar(
              title: Text(widget.m_title),
            ),
      body: ListView(padding: EdgeInsets.all(10), children: <Widget>[
        new Column(children: <Widget>[
          //If The day is current, provide a dropdown menu, else provide the contents within a fixed Row.
          !DateTime.parse(widget.m_datetimePage)
                      .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) ||
                  m_currentDay.m_state == DayState.NoGoal
              ? new DropdownButton(value: m_selectedGoal, items: m_dropDownGoals, onChanged: changedDropDownItem)
              : new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  m_currentDay.m_state == DayState.ModifiedGoal
                      ? new Icon(
                          Icons.edit,
                          size: 15,
                        )
                      : new Container(),
                  new Icon(
                    Icons.golf_course,
                    size: 25,
                  ),
                  new Text(m_currentDay.m_goal.m_name),
                  new Text(" - " + m_currentDay.m_goal.m_target.toString() + " Steps")
                ])
        ]),
        new Container(
          height: 245,
          child: m_currentDay.m_state != 0
              ? new GaugeChart(generateGaugeData(m_currentDay), m_currentDay.m_steps, m_currentDay.m_goal.m_target, 0,
                  m_animate: true)
              : new Text("Please choose a goal."),
        ),
        new Row(children: <Widget>[
          new Flexible(
              child: new TextFormField(
              controller: m_textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
              hintText: m_currentDay.m_goal.m_target.toString(),
              labelText: "Steps:" + m_currentDay.m_steps.toString(),
            ),
          )),
          new Container(
              height: 30,
              margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
              child: new FlatButton(
                child: const Text('Add'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                splashColor: Colors.blue,
                onPressed: () {
                  /*If you're allowed to modify history, or it is today*/
                  if (m_dataPtr.getHistoryModification() ||
                      !DateTime.parse(widget.m_datetimePage)
                          .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
                    incrementSteps(m_dataPtr, m_currentDay);
                  } else {
                    /*Notify User the date they are trying to modify is in the past*/
                    m_scaffoldKey.currentState
                        .showSnackBar(new SnackBar(content: new Text("History Modification Disabled")));
                  }
                },
              ))
        ]),
      ]),
    );
    //);
  }

  /*Add steps using input validation and update the backend data source*/
  void incrementSteps(UserData userData, Day day) {
    bool isHalfGoalAchieved = ((day.m_steps / day.m_goal.m_target) >= 0.5);
    try {
      int.parse(m_textController.text);
    } catch (e) {
      m_scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
      return;
    }
    if (int.parse(m_textController.text) < 1) {
      m_scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
      return;
    }
    day.m_steps += int.parse(m_textController.text);
    if (((day.m_steps / day.m_goal.m_target) >= 0.5) &&
        !isHalfGoalAchieved &&
        !DateTime.parse(widget.m_datetimePage)
            .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) &&
        m_dataPtr.getNotificationModification()) {
      m_notificationWrap.showNotification();
    }
    userData.updateDay(day);
    FocusScope.of(context).requestFocus(new FocusNode());
    m_textController.text = "";
    setState(() => this.didChangeDependencies());
  }

  /// Create one series with step data.
  static List<charts.Series<GaugeSegment, String>> generateGaugeData(Day currentDay) {
    final data = [
      new GaugeSegment('ToGo', currentDay.m_steps),
      new GaugeSegment('Complete',
          (currentDay.m_goal.m_target - currentDay.m_steps) > 0 ? (currentDay.m_goal.m_target - currentDay.m_steps) : 0),
    ];
    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  List<DropdownMenuItem<String>> getDropDownGoals() {
    m_currGoals = m_dataPtr.getGoals();
    List<String> currGoalsNames = new List<String>();
    if (m_currentDay.m_state == DayState.NoGoal) {
      currGoalsNames.add("No Goal Selected"); /*If No Goal Selected, add this "temporary goal" to list */
    } /*Need to use string types instead of classes due to weird behaviour in Flutter 1.0*/
    for (Goal element in m_currGoals) {
      currGoalsNames.add(element.m_name);
    }
    List<DropdownMenuItem<String>> items = new List();
    for (String element in currGoalsNames) {
      items.add(new DropdownMenuItem(
          value: element,
          child: new Row(children: <Widget>[
            new Icon(
              Icons.golf_course,
              size: 25,
            ),
            new Text(element),
            new Text(" - " + m_dataPtr.getGoal(element).m_target.toString() + " Steps")
          ])));
    }
    return items;
  }

  void changedDropDownItem(String selectedGoal) {
    setState(() {
      m_currentDay.m_goal = m_dataPtr.getGoal(selectedGoal);
      if (m_currentDay.m_goal.m_target != 0) {
        m_currentDay.m_state = m_currentDay.m_state == DayState.SelectedGoal || m_currentDay.m_state == DayState.ModifiedGoal
            ? DayState.ModifiedGoal
            : DayState.SelectedGoal;
        m_dataPtr.updateDay(m_currentDay);
      }
    });
  }
}
