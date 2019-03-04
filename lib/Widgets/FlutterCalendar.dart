import 'dart:async';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/Widgets/CalendarDayTile.dart';
import 'package:tuple/tuple.dart';

typedef DayBuilder(BuildContext context, DateTime day);

/**
 *
 * THIS CALENDAR IS A MODIFIED VERSION OF THE WORK COMPLETED BY Eric Windmill <ericwindmill.com>
 * Ref: https://pub.dartlang.org/packages/flutter_calendar
 * The calendar is Material Design compliant.
 *
*/

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> m_onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> m_onSelectedRangeChange;
  final bool m_isExpandable;
  final DayBuilder m_dayBuilder;
  final bool m_showChevronsToChangeRange;
  final bool m_showTodayAction;
  final bool m_showCalendarPickerIcon;
  final DateTime m_initialCalendarDateOverride;

  Calendar(
      {this.m_onDateSelected,
      this.m_onSelectedRangeChange,
      this.m_isExpandable: false,
      this.m_dayBuilder,
      this.m_showTodayAction: false,
      this.m_showChevronsToChangeRange: true,
      this.m_showCalendarPickerIcon: true,
      this.m_initialCalendarDateOverride});

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final m_calendarUtils = new Utils();
  List<DateTime> m_selectedMonthsDays;
  Iterable<DateTime> m_selectedWeeksDays;
  DateTime m_selectedDate = new DateTime.now();
  String m_currentMonth;
  bool m_isExpanded = true;
  String m_displayMonth;

  DateTime get selectedDate => m_selectedDate;

  void initState() {
    super.initState();
    if (widget.m_initialCalendarDateOverride != null) m_selectedDate = widget.m_initialCalendarDateOverride;
    m_selectedMonthsDays = Utils.daysInMonth(m_selectedDate);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(m_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(m_selectedDate);
    m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
    m_displayMonth = Utils.formatMonth(m_selectedDate);
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.m_showCalendarPickerIcon) {
      rightInnerIcon = new IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: new Icon(Icons.calendar_today),
      );
    } else {
      rightInnerIcon = new Container();
    }

    if (widget.m_showChevronsToChangeRange) {
      leftOuterIcon = new IconButton(
        onPressed: m_isExpanded ? previousMonth : previousWeek,
        icon: new Icon(Icons.chevron_left),
      );
      rightOuterIcon = new IconButton(
        onPressed: m_isExpanded ? nextMonth : nextWeek,
        icon: new Icon(Icons.chevron_right),
      );
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    if (widget.m_showTodayAction) {
      leftInnerIcon = new InkWell(
        child: new Text('Today'),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = new Container();
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? new Container(),
        leftInnerIcon ?? new Container(),
        new Text(
          m_displayMonth,
          style: new TextStyle(
            fontSize: 20.0,
          ),
        ),
        rightInnerIcon ?? new Container(),
        rightOuterIcon ?? new Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return new Container(
      child: new GridView.count(
        shrinkWrap: true,
        crossAxisCount: 7,
        padding: new EdgeInsets.only(bottom: 0.0),
        children: calendarBuilder(),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays = m_isExpanded ? m_selectedMonthsDays : m_selectedWeeksDays;

    Utils.weekdays.forEach(
      (day) {
        dayWidgets.add(
          new CalendarTile(
            m_isDayOfWeek: true,
            m_dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.m_dayBuilder != null) {
          dayWidgets.add(
            new CalendarTile(
              m_child: this.widget.m_dayBuilder(context, day),
              m_date: day,
            ),
          );
        } else {
          dayWidgets.add(
            new CalendarTile(
              m_date: day,
              m_dateStyles: configureDateStyle(monthStarted, monthEnded),
              m_isSelected: Utils.isSameDay(selectedDate, day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    if (m_isExpanded) {
      dateStyles =
          monthStarted && !monthEnded ? new TextStyle(color: Colors.black) : new TextStyle(color: Colors.black38);
    } else {
      dateStyles = new TextStyle(color: Colors.black);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.m_isExpandable) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(Utils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: m_isExpanded ? new Icon(Icons.arrow_drop_up) : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          new ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: m_isExpanded,
          ),
          expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    m_selectedDate = new DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(m_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(m_selectedDate);

    setState(() {
      m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      m_displayMonth = Utils.formatMonth(m_selectedDate);
    });

    _launchDateSelectionCallback(m_selectedDate);
  }

  void nextMonth() {
    setState(() {
      m_selectedDate = Utils.nextMonth(m_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(m_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(m_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      m_selectedMonthsDays = Utils.daysInMonth(m_selectedDate);
      m_displayMonth = Utils.formatMonth(m_selectedDate);
    });
  }

  void previousMonth() {
    setState(() {
      m_selectedDate = Utils.previousMonth(m_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(m_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(m_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      m_selectedMonthsDays = Utils.daysInMonth(m_selectedDate);
      m_displayMonth = Utils.formatMonth(m_selectedDate);
    });
  }

  void nextWeek() {
    setState(() {
      m_selectedDate = Utils.nextWeek(m_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(m_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(m_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      m_displayMonth = Utils.formatMonth(m_selectedDate);
    });
    _launchDateSelectionCallback(m_selectedDate);
  }

  void previousWeek() {
    setState(() {
      m_selectedDate = Utils.previousWeek(m_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(m_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(m_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      m_displayMonth = Utils.formatMonth(m_selectedDate);
    });
    _launchDateSelectionCallback(m_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    var selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.m_onSelectedRangeChange != null) {
      widget.m_onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: m_selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        m_selectedDate = selected;
        m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
        m_selectedMonthsDays = Utils.daysInMonth(selected);
        m_displayMonth = Utils.formatMonth(selected);
      });
      // updating selected date range based on selected week
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      _launchDateSelectionCallback(selected);
    }
  }

  void toggleExpanded() {
    if (widget.m_isExpandable) {
      setState(() => m_isExpanded = !m_isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      m_selectedDate = day;
      m_selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      m_selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.m_onDateSelected != null) {
      widget.m_onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      flex: 1,
      child: new AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
