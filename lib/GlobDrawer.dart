import 'package:flutter/material.dart';

import 'ActivityPage.dart';
import 'GoalPage.dart';
import 'HomePage.dart';
import 'SettingsPage.dart';

class GlobDrawer extends Drawer {
  GlobDrawer();

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Activity Tracker'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(title: "Home Page"),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Activity'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityPage(title: "Activity Page"),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Goals'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalPage(title: "Goals Page"),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(title: "Settings Page"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
