import 'package:charts_flutter/flutter.dart' as charts;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'GaugeChart.dart';
import 'GlobDrawer.dart';
import 'GoalPage.dart';
import 'Day.dart';
import 'UserData.dart';
class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
  @override
  Widget build(BuildContext context) {
    Day currentDay = dataInst.getDay(formatter.format(now));
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        // Column is also layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
          padding: EdgeInsets.all(10),
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.golf_course),
                title:  Text(currentDay.goal.name),
                subtitle:  Text(currentDay.goal.target.toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalPage(title: "Goals",currentDay: currentDay),
                    ),
                  );
                  /* react to the tile being tapped */
                }),
            new Container(
              height: 250,
              child:
              new GaugeChart(_createSampleData(currentDay),currentDay.steps,currentDay.goal.target, animate: true),
            ),DateTimePickerFormField(
              inputType: InputType.date,
              format: formats[InputType.date],
              editable: false,
              initialValue: now,
              decoration: InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Date',
                  hasFloatingPlaceholder: false),
              onChanged: (dt) => setState(() => now=dt),

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
              onPressed: ()
              {
                incrementSteps(dataInst,currentDay);
              },
            ),
          ]),

      drawer: GlobDrawer(),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void incrementSteps(UserData userData, Day day)
  {
    day.steps+=int.parse(textController.text);
    userData.updateDay(day);


    setState(() => this.didChangeDependencies());


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData(
      Day currentDay) {
    final data = [
      new GaugeSegment('Complete', (currentDay.goal.target-currentDay.steps)>0?(currentDay.goal.target-currentDay.steps):0),
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
