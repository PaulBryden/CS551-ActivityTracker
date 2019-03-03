import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/Days.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';

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
  final snackBar = SnackBar(content: Text('Cleared History'));
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            new SwitchListTile(
              value: dataInst.settings.historyMod,
              onChanged: (bool value) {
                setState(() {
                  dataInst.settings.historyMod = value;
                  dataInst.writeFile("settings");
                });
              },
              title:
                  new Text('History Activity Recording', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new SwitchListTile(
              value: dataInst.settings.goalMod,
              onChanged: (bool value) {
                setState(() {
                  value:
                  dataInst.settings.goalMod = value;
                  dataInst.writeFile("settings");
                });
              },
              title: new Text('Goal Editing', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new SwitchListTile(
              value: dataInst.settings.notificationsMod,
              onChanged: (bool value) {
                setState(() {
                  dataInst.settings.notificationsMod = value;
                  dataInst.writeFile("settings");
                });
              },
              title:
              new Text('Enable Notifications', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
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
                }),
          ],
        ),
      ),
      drawer: GlobDrawer(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
