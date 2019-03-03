import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Goal.dart';
import 'package:flutter_app_test/Data/UserData.dart';

class AddGoalsPage extends StatefulWidget {
  AddGoalsPage({Key key, this.title, this.name, this.target, this.isEdit}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  String name;
  int target;
  bool isEdit;

  @override
  _AddGoalsPageState createState() => _AddGoalsPageState(name, target);
}

class _AddGoalsPageState extends State<AddGoalsPage> {
  var dataInst = new UserData();
  String valString;
  int targetVal;
  final nameController = TextEditingController();
  final targetController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _AddGoalsPageState(this.valString, this.targetVal) {
    nameController.text = (valString);
    targetController.text = (targetVal.toString());
  } //constructor
  @override
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //
            // The widget.
            //
            TextFormField(
              controller: nameController,
              enabled: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.text_format),
                hintText: 'Default Goal',
                labelText: 'Name *',
              ),
            ),
            TextFormField(
              controller: targetController,
              keyboardType: TextInputType.number,
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
          try {
            int.parse(targetController.text);
          } catch (e) {
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
            return;
          }
          if (int.parse(targetController.text) < 1) {
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
            return;
          }
          Goal goal = new Goal(nameController.text, int.parse(targetController.text));
          if (widget.isEdit) {
            if (widget.name != nameController.text &&
                dataInst.getGoal(nameController.text).name != "No Goal Selected") {
              _scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text("Another Goal already exists with that name.")));
            } else {
              dataInst.updateGoal(new Goal(widget.name, widget.target), goal);
              Navigator.pop(context);
            }
          } else {
            if (dataInst.getGoal(nameController.text).name != "No Goal Selected") {
              _scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text("Goal already exists with that name.")));
            } else {
              dataInst.addGoal(goal);
              Navigator.pop(context);
            }
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void updateName() {
    widget.name = "${nameController.text}";
  }

  void updateTarget() {
    widget.target = int.parse("${targetController.text}");
  }
}
