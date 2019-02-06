import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'GaugeChart.dart';
import 'GlobDrawer.dart';
import 'GoalPage.dart';
import 'UserData.dart';
import 'package:intl/intl.dart';
import 'Day.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.datetimePage, this.isHome})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  String datetimePage;
  bool isHome;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  var dataInst = new UserData();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Day currentDay = dataInst.getDay(widget.datetimePage);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      key: _scaffoldKey,
      drawer: widget.isHome ? GlobDrawer() : new Container(),
      appBar: !widget.isHome
          ? AppBar(
              title: Text(widget.title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
          : AppBar(
              title: Text(widget.title),
            ),
      body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            new Container(
              child: new ListTile(
                  leading: const Icon(Icons.golf_course),
                  title: Text(currentDay.goal.name),
                  subtitle: Text(currentDay.goal.target.toString()),
                  onTap: () {
                    if (!DateTime.parse(widget.datetimePage).isBefore(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day))) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GoalPage(title: "Goals", currentDay: currentDay),
                        ),
                      );
                      /* react to the tile being tapped */
                    }
                  }),
              color: Color.alphaBlend(Colors.black12, Colors.white),
            ),
            new Container(
              height: 245,
              child: new GaugeChart(_createSampleData(currentDay),
                  currentDay.steps, currentDay.goal.target, 0,
                  animate: true),
            ),
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a number';
                }
              },
              decoration: InputDecoration(
                hintText: currentDay.goal.target.toString(),
                labelText: "Steps:" + currentDay.steps.toString(),
              ),
            ),
            new RaisedButton(
              child: const Text('Add'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              elevation: 4.0,
              splashColor: Colors.blue,
              onPressed: () {
                if (dataInst.settings.historyMod ||
                    !DateTime.parse(widget.datetimePage).isBefore(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day))) {
                  incrementSteps(dataInst, currentDay);
                } else {
                  _scaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: new Text("History Modification Disabled")));
                }
              },
            ),
          ]),
    );
    //);
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
