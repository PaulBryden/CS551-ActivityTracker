import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Goal.dart';
import 'package:flutter_app_test/Data/UserData.dart';

class GoalModificationPage extends StatefulWidget {
  GoalModificationPage({Key key, this.m_Title, this.m_Name, this.m_Target, this.m_isEdit}) : super(key: key);
  /*Data to be passed in on page creation for use by widgets on the page*/

  final String m_Title;
  String m_Name;
  int m_Target;
  bool m_isEdit;

  @override
  _GoalModificationPageState createState() => _GoalModificationPageState(m_Name, m_Target);
}

class _GoalModificationPageState extends State<GoalModificationPage> {
  var m_dataPtr = new UserData();
  String m_valName;
  int m_targetVal;
  final m_nameController = TextEditingController();
  final m_targetController = TextEditingController();
  final GlobalKey<ScaffoldState> m_scaffoldKey = new GlobalKey<ScaffoldState>();

  _GoalModificationPageState(this.m_valName, this.m_targetVal) {
    m_nameController.text = (m_valName);
    m_targetController.text = (m_targetVal.toString());
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
      key: m_scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.m_Title),
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
              controller: m_nameController,
              enabled: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.text_format),
                hintText: 'Default Goal',
                labelText: 'Name *',
              ),
            ),
            TextFormField(
              controller: m_targetController,
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
            int.parse(m_targetController.text);
          } catch (e) {
            m_scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
            return;
          }
          if (int.parse(m_targetController.text) < 1) {
            m_scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text("Please enter a valid, positive step count.")));
            return;
          }
          Goal goal = new Goal(m_nameController.text, int.parse(m_targetController.text));
          if (widget.m_isEdit) {
            if (widget.m_Name != m_nameController.text &&
                m_dataPtr.getGoal(m_nameController.text).m_name != "No Goal Selected") {
              m_scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text("Another Goal already exists with that name.")));
            } else {
              m_dataPtr.updateGoal(new Goal(widget.m_Name, widget.m_Target), goal);
              Navigator.pop(context);
            }
          } else {
            if (m_dataPtr.getGoal(m_nameController.text).m_name != "No Goal Selected") {
              m_scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text("Goal already exists with that name.")));
            } else {
              m_dataPtr.addGoal(goal);
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
    widget.m_Name = "${m_nameController.text}";
  }

  void updateTarget() {
    widget.m_Target = int.parse("${m_targetController.text}");
  }
}
