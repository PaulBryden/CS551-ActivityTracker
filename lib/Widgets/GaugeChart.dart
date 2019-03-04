import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  final List<charts.Series> m_seriesList;
  int m_stepCount;
  int m_goal;
  final bool m_animate;
  int m_day = 0;

  GaugeChart(this.m_seriesList, this.m_stepCount, this.m_goal, this.m_day, {this.m_animate});

  /*Creates a Pie Chart with no middle.*/
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(m_seriesList,
        animate: m_animate,
        behaviors: [
          m_day == 0
              ? new charts.ChartTitle((((m_stepCount / m_goal) * 100).round().toString()) + "%",
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification: charts.OutsideJustification.middle,
                  innerPadding: 8)
              : new charts.ChartTitle(((m_day.toString())),
                  behaviorPosition: charts.BehaviorPosition.top,
                  titleStyleSpec: new charts.TextStyleSpec(
                      fontSize: 10, // size in Pts.
                      color: charts.MaterialPalette.black),
                  innerPadding: 0),
        ],
        // Configure the width of the pie slices to be small - identified by caller. The remaining space in
        // the chart will be left as a hole in the center. Angle represents difference in step count
        defaultRenderer:
            new charts.ArcRendererConfig(arcWidth: m_day == 0 ? 25 : 5, startAngle: 3.14 / 2, arcLength: 2 * 3.14));
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
