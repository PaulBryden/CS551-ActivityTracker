import 'package:charts_flutter/flutter.dart' as charts;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ActivityPage.dart';
import 'GaugeChart.dart';
import 'GlobDrawer.dart';
import 'GoalPage.dart';
import 'Day.dart';
import 'UserData.dart';
import 'flutter_calendar.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime selectedDate = DateTime.now();
  String dropdown1Value = 'Goal One';
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };
  final textController = TextEditingController();
  var dataInst = new UserData();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  @override
  Widget build(BuildContext context) {
    Day currentDay = dataInst.getDay(formatter.format(now));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Calendar(
        onSelectedRangeChange: (range) =>
            print("Range is ${range.item1}, ${range.item2}"),
        isExpandable: true,
        dayBuilder: (BuildContext context, DateTime day) {
          Day dayVar = dataInst.getDay(formatter.format(day));
          return new InkWell(
              onTap: ()  => (!day.isAfter(DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day)))?
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(
                            datetimePage:
                            DateFormat('yyyy-MM-dd').format(day),
                            title: 'Activity - ' +
                                DateFormat('yyyy-MM-dd').format(day), isHome: false),
                  )):_scaffoldKey.currentState.showSnackBar(new SnackBar(
    content: new Text("Cannot select a date in the future"))),
              child:
              new IgnorePointer(
                child:new GaugeChart(_createSampleData(dayVar), dayVar.steps,
                  dayVar.goal.target, day.day,
                  animate: true)));
        },
      ),
      drawer: GlobDrawer(),
    );
  }

  void incrementSteps(UserData userData, Day day) {
    day.steps += int.parse(textController.text);
    userData.updateDay(day);

    setState(() => this.didChangeDependencies());
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData(
      Day currentDay) {
    final data = [
      new GaugeSegment(
          'Complete',
          (currentDay.goal.target - currentDay.steps) > 0
              ? (currentDay.goal.target - currentDay.steps)
              : 0),
      new GaugeSegment('ToGo', currentDay.steps),
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
}
