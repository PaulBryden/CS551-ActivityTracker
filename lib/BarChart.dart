import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<StepStruct, String>> _createSampleData() {
    final data = [
      new StepStruct('2014', 5),
      new StepStruct('2015', 25),
      new StepStruct('2016', 100),
      new StepStruct('2017', 75),
    ];

    return [
      new charts.Series<StepStruct, String>(
        id: 'Steps',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StepStruct sales, _) => sales.year,
        measureFn: (StepStruct sales, _) => sales.steps,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class StepStruct {
  final String year;
  final int steps;

  StepStruct(this.year, this.steps);
}
