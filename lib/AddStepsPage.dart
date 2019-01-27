import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStepsPage extends StatefulWidget {
  AddStepsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AddStepsPageState createState() => _AddStepsPageState();
}

class _AddStepsPageState extends State<AddStepsPage> {
  DateTime selectedDate = DateTime.now();
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  // Changeable in demo
  bool editable = true;
  DateTime date;
  DateTime time;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            // The widget.
            //
            DateTimePickerFormField(
              inputType: InputType.date,
              format: formats[InputType.date],
              editable: false,
              decoration: InputDecoration(
                  icon: Icon(Icons.date_range),
                  labelText: 'Date',
                  hasFloatingPlaceholder: false),
              onChanged: (dt) => setState(() => date = dt),
            ),

            DateTimePickerFormField(
              inputType: InputType.time,
              format: formats[InputType.time],
              editable: false,
              decoration: InputDecoration(
                  icon: Icon(Icons.access_time),
                  labelText: 'Time',
                  hasFloatingPlaceholder: false),
              onChanged: (dt) => setState(() => time = dt),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.directions_walk),
                hintText: '1000',
                labelText: 'Steps *',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
