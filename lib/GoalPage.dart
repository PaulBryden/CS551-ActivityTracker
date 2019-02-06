import 'package:flutter/material.dart';

import 'AddGoalsPage.dart';
import 'GlobDrawer.dart';
import 'UserData.dart';
import 'Day.dart';
import 'package:intl/intl.dart';

class GoalPage extends StatefulWidget {
  GoalPage({Key key, this.title, this.currentDay}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView.builder(
              // Let the ListView know how many items it needs to build
              itemCount: dataInst.goals.goals.length,
              // Provide a builder function. This is where the magic happens! We'll
              // convert each item into a Widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = dataInst.goals.goals[index];

                if (item.name == widget.currentDay.goal.name) {
                  return ListTile(
                      leading: const Icon(Icons.golf_course),
                      title: Text(widget.currentDay.goal.name),
                      subtitle: Text(widget.currentDay.goal.target.toString()));
                } else if (item.name ==
                    dataInst
                        .getDay(formatter.format(DateTime.now()))
                        .goal
                        .name) {
                  return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.target.toString()),
                      onTap: () {
                        if (dataInst.settings.goalMod) {
                          widget.currentDay.goal.name = item.name;
                          widget.currentDay.goal.target = item.target;
                          dataInst.updateDay(widget.currentDay);
                          setState(() => this.didChangeDependencies());
                        } else {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text("Goal Modification Disabled")));

                          /* react to the tile being tapped */

                        }
                      });
                } else {
                  return Dismissible(
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify Widgets.
                    key: Key(item.name),
                    background: Container(color: Colors.red),
                    // We also need to provide a function that will tell our app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from our data source.
                      setState(() {
                        dataInst.removeGoal(item);
                      });

                      // Show a snackbar! This snackbar could also contain "Undo" actions.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(item.name + "deleted")));
                    },
                    child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.target.toString()),
                        onTap: () {
                          if (dataInst.settings.goalMod) {
                            widget.currentDay.goal.name = item.name;
                            widget.currentDay.goal.target = item.target;
                            dataInst.updateDay(widget.currentDay);
                            setState(() => this.didChangeDependencies());
                          } else {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                content:
                                    new Text("Goal Modification Disabled")));
                          }
                          /* react to the tile being tapped */
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddGoalsPage(
                                  title: "Add Goals Page",
                                  name: item.name,
                                  target: item.target,
                                  enableName: false),
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
              builder: (context) => AddGoalsPage(
                  title: "Add Goals Page",
                  name: "DEFAULT",
                  target: 0,
                  enableName: true),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
