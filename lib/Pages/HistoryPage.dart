import 'package:charts_flutter/flutter.dart' as charts;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Pages/ActivityPage.dart';
import 'package:flutter_app_test/Widgets/GaugeChart.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';
import 'package:flutter_app_test/Widgets/FlutterCalendar.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.m_title}) : super(key: key);
  /*Data to be passed in on page creation for use by widgets on the page*/

  final String m_title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final m_textController = TextEditingController();
  var m_dataPtr = new UserData();
  var m_now = new DateTime.now();
  var m_formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> m_ScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  @override
  Widget build(BuildContext context) {
    Day currentDay = m_dataPtr.getDay(m_formatter.format(m_now));
    return Scaffold(
      key: m_ScaffoldKey,
      appBar: AppBar(
        title: Text(widget.m_title),
      ),
      body: new Calendar(
        m_onSelectedRangeChange: (range) => print("Range is ${range.item1}, ${range.item2}"),
        m_isExpandable: true,
        m_dayBuilder: (BuildContext context, DateTime day) {
          Day dayVar = m_dataPtr.getDay(m_formatter.format(day));
          return new InkWell(
              onTap: () => (!day.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)))
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityPage(
                            m_datetimePage: DateFormat('yyyy-MM-dd').format(day),
                            m_title: 'Activity - ' + DateFormat('yyyy-MM-dd').format(day),
                            m_isHome: false),
                      ))
                  : m_ScaffoldKey.currentState
                      .showSnackBar(new SnackBar(content: new Text("Cannot select a date in the future"))),
              child: new IgnorePointer(
                  child: new GaugeChart(_createSampleData(dayVar), dayVar.m_steps, dayVar.m_goal.m_target, day.day,
                      m_animate: true)));
        },
      ),
      drawer: GlobDrawer(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData(Day currentDay) {
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
}
