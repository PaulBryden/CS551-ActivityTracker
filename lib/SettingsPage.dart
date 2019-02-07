import 'package:flutter/material.dart';
import 'UserData.dart';
import 'GlobDrawer.dart';
import 'Days.dart';
import 'Day.dart';
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var dataInst = new UserData();
  final snackBar = SnackBar(
      content: Text('Cleared History'));
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
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
            new SwitchListTile(
              value: dataInst.settings.historyMod,
              onChanged: (bool value) { setState(() { dataInst.settings.historyMod=value; dataInst.writeFile("settings"); }); },

              title: new Text('History Editing',
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new SwitchListTile(
              value: dataInst.settings.goalMod,
              onChanged: (bool value) { setState(() {
                value: dataInst.settings.goalMod=value; dataInst.writeFile("settings"); }); },

              title: new Text('Goal Editing',
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new RaisedButton(
              child: const Text('Clear History'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              elevation: 4.0,
              splashColor: Colors.blue,
              onPressed: () {
                dataInst.days = new Days(new List<Day>());
                dataInst.writeFile("days");
                _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Cleared History")));
              }
            ),

          ],

        ),
      ),
      drawer: GlobDrawer(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
