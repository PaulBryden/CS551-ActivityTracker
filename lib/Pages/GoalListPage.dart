import 'package:flutter/material.dart';
import 'package:flutter_app_test/Data/Day.dart';
import 'package:flutter_app_test/Data/UserData.dart';
import 'package:flutter_app_test/Pages/GoalModificationPage.dart';
import 'package:flutter_app_test/Widgets/GlobDrawer.dart';
import 'package:intl/intl.dart';

class GoalListPage extends StatefulWidget {
  GoalListPage({Key key, this.m_title}) : super(key: key);
  /*Data to be passed in on page creation for use by widgets on the page*/

  final String m_title;
  Day m_currentDay;

  @override
  _GoalListPageState createState() => _GoalListPageState();
}

class _GoalListPageState extends State<GoalListPage> {
  var m_dataPtr = new UserData();
  var m_formatter = new DateFormat('yyyy-MM-dd');
  final GlobalKey<ScaffoldState> m_ScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    widget.m_currentDay = m_dataPtr.getDay(m_formatter.format(DateTime.now()));
    return Scaffold(
      key: m_ScaffoldKey,
      appBar: AppBar(
        title: Text(widget.m_title),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: m_dataPtr.m_goals.m_goals.length,
              itemBuilder: (context, index) {
                final item = m_dataPtr.m_goals.m_goals[index];
                if (item.m_name == widget.m_currentDay.m_goal.m_name) {
                  return Ink(
                      color: new Color.fromARGB(255,Colors.blue.red,Colors.blue.green,Colors.blue.blue),
                      child: ListTile(
                          leading: const Icon(Icons.golf_course),
                          title: Text(item.m_name),
                          subtitle: Text(item.m_target.toString())));
                } else if (!m_dataPtr.m_settings.m_goalMod) { /*If Goal Modification is Disabled*/
                  return ListTile(
                      leading: const Icon(Icons.lock), title: Text(item.m_name), subtitle: Text(item.m_target.toString()));
                } else {
                  return Dismissible( /*Else allow items to be deleted by swiping*/
                    key: Key(item.m_name),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      setState(() {
                        m_dataPtr.removeGoal(item);
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(item.m_name + " deleted."),duration: new Duration(seconds: 1)));
                    },
                    child: ListTile(
                        title: Text(item.m_name),
                        leading: const Icon(Icons.edit),
                        subtitle: Text(item.m_target.toString()),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GoalModificationPage(
                                  m_Title: "Modify Goal", m_Name: item.m_name, m_Target: item.m_target, m_isEdit: true),
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
              builder: (context) => GoalModificationPage(m_Title: "Add Goal", m_Name: "", m_Target: 0, m_isEdit: false),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
