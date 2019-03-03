import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Pages/GoalModificationPage.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';
import 'package:intl/intl.dart';

class GoalPage extends StatefulWidget {
  GoalPage({Key key, this.title}) : super(key: key);

  final String title;
  Day currentDay;

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  var dataInst = new UserData();
  var formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    widget.currentDay = dataInst.getDay(formatter.format(DateTime.now()));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: dataInst.goals.goals.length,
              itemBuilder: (context, index) {
                final item = dataInst.goals.goals[index];
                if (item.name == widget.currentDay.goal.name) {
                  return Ink(
                      color: new Color.fromARGB(140,Colors.blue.red,Colors.blue.green,Colors.blue.blue),
                      child: ListTile(
                          leading: const Icon(Icons.golf_course),
                          title: Text(item.name),
                          subtitle: Text(item.target.toString())));
                } else if (!dataInst.settings.goalMod) {
                  return ListTile(
                      leading: const Icon(Icons.lock), title: Text(item.name), subtitle: Text(item.target.toString()));
                } else {
                  return Dismissible(
                    key: Key(item.name),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        dataInst.removeGoal(item);
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(item.name + " deleted."),duration: new Duration(seconds: 1)));
                    },
                    child: ListTile(
                        title: Text(item.name),
                        leading: const Icon(Icons.edit),
                        subtitle: Text(item.target.toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddGoalsPage(
                                  title: "Modify Goal", name: item.name, target: item.target, isEdit: true),
                            ),
                          );
                        }),
                  );
                }
              })),
      drawer: GlobDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGoalsPage(title: "Add Goal", name: "", target: 0, isEdit: false),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
