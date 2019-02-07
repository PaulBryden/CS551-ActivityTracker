import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'GaugeChart.dart';
import 'GlobDrawer.dart';
import 'GoalPage.dart';
import 'UserData.dart';
import 'package:intl/intl.dart';
import 'Day.dart';
import 'Goals.dart';
import 'Goal.dart';
import 'DayState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.datetimePage, this.isHome})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  String datetimePage;
  bool isHome;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  var dataInst = new UserData();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  Day currentDay;
  List<Goal> _currGoals;
  String selectedGoal;
  List<DropdownMenuItem<String>> _dropDownGoals;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    currentDay = dataInst.getDay(widget.datetimePage);
    selectedGoal = currentDay.goal.name;
    _dropDownGoals = getDropDownMenuCurrencyItems();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      key: _scaffoldKey,
      drawer: widget.isHome ? GlobDrawer() : new Container(),
      appBar: !widget.isHome
          ? AppBar(
              title: Text(widget.title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
          : AppBar(
              title: Text(widget.title),
            ),
      body: ListView(padding: EdgeInsets.all(10), children: <Widget>[
        new Column(children: <Widget>[
          !DateTime.parse(widget.datetimePage).isBefore(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day))||currentDay.state==DayState.NoGoal?
          new DropdownButton(
            value: selectedGoal,
            items: _dropDownGoals,
            onChanged: changedDropDownItem
          ):
         new Row(mainAxisAlignment: MainAxisAlignment.center,children : <Widget>[currentDay.state==DayState.ModifiedGoal?new Icon(Icons.edit,size: 15,):new Container(),new  Icon(Icons.golf_course,size: 25,),
          new Text(currentDay.goal.name),
          new Text(" - "+currentDay.goal.target.toString()+" Steps")])]),
        new Container(
          height: 245,
          child: currentDay.state != 0
              ? new GaugeChart(_createSampleData(currentDay), currentDay.steps,
                  currentDay.goal.target, 0,
                  animate: true)
              : new Text("Please choose a goal."),
        ),
      new Row(
        children: <Widget>[
      new Flexible(
      child: new
        TextFormField(
          controller: textController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: currentDay.goal.target.toString(),
            labelText: "Steps:" + currentDay.steps.toString(),
          ),
        )),
        new Container(
          height:30,
          margin: EdgeInsets.fromLTRB(5, 15, 0, 0),
          child:
        new FlatButton(

          child: const Text('Add'),
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          splashColor: Colors.blue,
          onPressed: () {
            if (dataInst.settings.historyMod ||
                !DateTime.parse(widget.datetimePage).isBefore(DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day))) {
              incrementSteps(dataInst, currentDay);
            } else {
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text("History Modification Disabled")));
            }
          },
        ))]),
      ]),
    );
    //);
  }

  void incrementSteps(UserData userData, Day day) {

    try{
      int.parse(textController.text);
    }
    catch(e)
    {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Please enter a valid, positive step count.")));
      return;

    }
    if(int.parse(textController.text)<0)
    {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("Please enter a valid, positive step count.")));
      return;
    }
    day.steps += int.parse(textController.text);
    userData.updateDay(day);
    FocusScope.of(context).requestFocus(new FocusNode());
    textController.text="";
    setState(() => this.didChangeDependencies());
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData(
      Day currentDay) {
    final data = [
      new GaugeSegment(
          'Complete',
          (currentDay.goal.target - currentDay.steps) > 0
              ? (currentDay.goal.target - currentDay.steps)
              : 0),
      new GaugeSegment('ToGo', currentDay.steps),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }

  List<DropdownMenuItem<String>> getDropDownMenuCurrencyItems() {
    _currGoals = dataInst.getGoals();
    List<String> currGoalsNames = new List<String>();
    if (currentDay.state == DayState.NoGoal) {
      currGoalsNames.add("No Goal Selected");
    }
    for (Goal element in _currGoals) {
      currGoalsNames.add(element.name);
      print(element.name);
    }
    List<DropdownMenuItem<String>> items = new List();
    for (String element in currGoalsNames) {
      items.add(new DropdownMenuItem(value: element, child: new Row(children : <Widget>[
        currentDay.state==DayState.ModifiedGoal?new Icon(Icons.edit,size: 15,):new Container(),new  Icon(Icons.golf_course,size: 25,),
          new Text(element),
        new Text(" - "+dataInst.getGoal(element).target.toString()+" Steps")])));
    }
    return items;
                            }

  void changedDropDownItem(String selectedGoal) {
    setState(() {
      currentDay.goal = dataInst.getGoal(selectedGoal);
      currentDay.state = currentDay.state==DayState.SelectedGoal||currentDay.state==DayState.ModifiedGoal?DayState.ModifiedGoal:DayState.SelectedGoal;
      dataInst.updateDay(currentDay);
    });
  }
}
