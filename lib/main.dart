import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'ActivityPage.dart';
import 'UserData.dart';
import 'package:intl/intl.dart';

void main() =>  test().then((_)=>runApp(MyApp()));
var s1 = new UserData();

Future<int> test() async {
  await s1.loadAllData();
  return 0;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(datetimePage: DateFormat('yyyy-MM-dd').format(DateTime.now()),title:  'Summary',isHome: true),
    );
  }
}
