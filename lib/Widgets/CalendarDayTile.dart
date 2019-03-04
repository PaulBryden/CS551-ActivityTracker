import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';

/**
 *
 * THIS CALENDAR DAY TILE IS A MODIFIED VERSION OF THE WORK COMPLETED BY Eric Windmill <ericwindmill.com>
 * Ref: https://pub.dartlang.org/packages/flutter_calendar
 * The calendar is Material Design compliant.
 *
 */

class CalendarTile extends StatelessWidget {
  final VoidCallback m_onDateSelected;
  final DateTime m_date;
  final String m_dayOfWeek;
  final bool m_isDayOfWeek;
  final bool m_isSelected;
  final TextStyle m_dayOfWeekStyles;
  final TextStyle m_dateStyles;
  final Widget m_child;

  CalendarTile({
    this.m_onDateSelected,
    this.m_date,
    this.m_child,
    this.m_dateStyles,
    this.m_dayOfWeek,
    this.m_dayOfWeekStyles,
    this.m_isDayOfWeek: false,
    this.m_isSelected: false,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (m_isDayOfWeek) {
      return new Container(
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            m_dayOfWeek,
            style: m_dayOfWeekStyles,
          ),
        ),
      );
    } else {
      return new Container(
        child: new Container(
          decoration: m_isSelected
              ? new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                )
              : new BoxDecoration(),
          alignment: Alignment.center,
          child: new Text(
            Utils.formatDay(m_date).toString(),
            style: m_isSelected ? new TextStyle(color: Colors.white) : m_dateStyles,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (m_child != null) {
      return new Container(
        child: m_child,
      );
    }
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: renderDateOrDayOfWeek(context),
    );
  }
}
