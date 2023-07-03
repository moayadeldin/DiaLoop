import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    _spots = _getSpots();
  }

  DateTime now = DateTime.now();

  void refreshTime() {
    setState(() {
      now = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMd().format(now);
    final time = DateFormat.jm().format(now);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Your Glucose Readings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: refreshTime,
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF004D40),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: LineChart(
                LineChartData(
                  minY: 75,
                  maxY: 130,
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white24,
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: true,
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white24,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Color(0xFF004D40), width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getSpots(),
                      isCurved: true,
                      color: Colors.lightGreen,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                          show: true, color: Colors.white.withOpacity(0.2)),
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.calendar),
              SizedBox(width: 5),
              Text(date),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.clock),
              SizedBox(width: 5),
              Text(time),
            ],
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    Random random = Random();
    return List.generate(
        10, (index) => FlSpot(index.toDouble(), random.nextInt(41) + 80.0));
  }
}
