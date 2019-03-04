import 'package:flutter/material.dart';
import 'package:flutter_app_test/Pages/ActivityPage.dart';
import 'package:flutter_app_test/Pages/GoalListPage.dart';
import 'package:flutter_app_test/Pages/HistoryPage.dart';
import 'package:flutter_app_test/Pages/SettingsPage.dart';
import 'package:intl/intl.dart';

class GlobDrawer extends Drawer {
  GlobDrawer(); /*Default Constructor*/

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Activity Tracker',
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            margin: EdgeInsets.all(0),
          ),
          /*Navigate to Summary Page*/
          ListTile(
            title: Text('Summary'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityPage(
                      m_datetimePage: DateFormat('yyyy-MM-dd').format(DateTime.now()), m_title: 'Summary', m_isHome: true),
                ),
              );
            },
          ),
          ListTile(
            title: Text('History'),
            onTap: () {
              /*Navigate to History Page*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(m_title: "History"),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Manage Goals'),
            onTap: () {
              /*Navigate to Goals Page*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalListPage(m_title: "Manage Goals"),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              /*Navigate to Settings Page*/
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(m_title: "Settings"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
