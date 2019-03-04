import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Pages/ActivityPage.dart';
import 'package:intl/intl.dart';

void main() => test().then((_) => runApp(MyApp()));
var s1 = new UserData();

Future test() async {
  /*When app loads, initialize the UserData*/
  await s1.loadAllData();
  return;
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( //Material Design Theme
        primarySwatch: Colors.blue,
      ),
      /*Pass current datetime to the Activity Page to identify Day vs Historical View*/
      home: ActivityPage(m_datetimePage: DateFormat('yyyy-MM-dd').format(DateTime.now()), m_title: 'Summary', m_isHome: true),
    );
  }
}
