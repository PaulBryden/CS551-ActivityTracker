import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'GaugeChart.dart';
import 'BarChart.dart';
import 'AddStepsPage.dart';
import 'GlobDrawer.dart';

class ActivityPage extends StatefulWidget {
  ActivityPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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

          children: <Widget>[
            Text(
              '500/100 Steps',
              textAlign: TextAlign.center,

            ),
            new Container(
              width: 300.0,
              height: 300.0,
              child: new GaugeChart(_createSampleData(), animate: true),
            ),
        new Container(

          width: 300.0,
          height: 300.0,
            child: SimpleBarChart.withSampleData(),

        ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
              new RaisedButton(
              child: const Text('Day'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              elevation: 4.0,
              splashColor: Colors.blue,
              onPressed: () {
                // Perform some action
              },
            ),
              new RaisedButton(
                child: const Text('Month'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                elevation: 4.0,
                splashColor: Colors.blue,
                onPressed: () {
                  // Perform some action
                },
              ),
              new RaisedButton(
                child: const Text('Year'),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                elevation: 4.0,
                splashColor: Colors.blue,
                onPressed: () {
                  // Perform some action
                },
              )]),

          ],

        ),

      drawer: GlobDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStepsPage(title: "Add Steps Page"),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Complete', 100),
      new GaugeSegment('ToGo', 100),
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
