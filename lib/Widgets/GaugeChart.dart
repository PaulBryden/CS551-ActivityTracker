import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  int stepCount;
  int goal;
  final bool animate;
  int day = 0;

  GaugeChart(this.seriesList, this.stepCount, this.goal, this.day, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        behaviors: [
          day == 0
              ? new charts.ChartTitle((((stepCount / goal) * 100).round().toString()) + "%",
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification: charts.OutsideJustification.middle,
                  // Set a larger inner padding than the default (10) to avoid
                  // rendering the text too close to the top measure axis tick label.
                  // The top tick label may extend upwards into the top margin region
                  // if it is located at the top of the draw area.
                  innerPadding: 8)
              : new charts.ChartTitle(((day.toString())),
                  behaviorPosition: charts.BehaviorPosition.top,
                  titleStyleSpec: new charts.TextStyleSpec(
                      fontSize: 10, // size in Pts.
                      color: charts.MaterialPalette.black),
                  innerPadding: 0),
        ],
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer:
            new charts.ArcRendererConfig(arcWidth: day == 0 ? 25 : 5, startAngle: 3.14 / 2, arcLength: 2 * 3.14));
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}
