import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/Days.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.m_title}) : super(key: key);
  /*Data to be passed in on page creation for use by widgets on the page*/

  final String m_title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var m_dataPtr = new UserData();
  final m_snackBar = SnackBar(content: Text('Cleared History'));
  final GlobalKey<ScaffoldState> m_scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: m_scaffoldKey,
      appBar: AppBar(
        title: Text(widget.m_title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            new SwitchListTile(
              value: m_dataPtr.getHistoryModification(),
              onChanged: (bool value) {
                setState(() {
                  value:m_dataPtr.updateHistoryModification(value);
                });
              },
              title:
                  new Text('History Activity Recording', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new SwitchListTile(
              value: m_dataPtr.getGoalModification(),
              onChanged: (bool value) {
                setState(() {
                  value:m_dataPtr.updateGoalModification(value);
                });
              },
              title: new Text('Goal Editing', style: new TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
            ),
            new SwitchListTile(
              value: m_dataPtr.getNotificationModification(),
              onChanged: (bool value) {
                setState(() {
                  value:m_dataPtr.updateNotificationModification(value);
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
                  m_dataPtr.updateAllDays(new Days(new List<Day>()));
                  m_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Cleared History")));
                }),
          ],
        ),
      ),
      drawer: GlobDrawer(),
    );
  }
}
