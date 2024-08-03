import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async'; // Import this for StreamSubscription

class MotionDetectionPage extends StatefulWidget {
  @override
  _MotionDetectionPageState createState() => _MotionDetectionPageState();
}

class _MotionDetectionPageState extends State<MotionDetectionPage> {
  List<FlSpot> _accelXData = [];
  List<FlSpot> _accelYData = [];
  List<FlSpot> _accelZData = [];
  int _dataIndex = 0;
  bool _isCollectingData = false;
  StreamSubscription<AccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();
  }

  void _toggleDataCollection() {
    setState(() {
      if (_isCollectingData) {
        _isCollectingData = false;
        _subscription?.cancel();
      } else {
        _isCollectingData = true;
        _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
          setState(() {
            _dataIndex++;
            _accelXData.add(FlSpot(_dataIndex.toDouble(), event.x));
            _accelYData.add(FlSpot(_dataIndex.toDouble(), event.y));
            _accelZData.add(FlSpot(_dataIndex.toDouble(), event.z));

            // Keep the data limited to the last 50 points
            if (_accelXData.length > 50) {
              _accelXData.removeAt(0);
              _accelYData.removeAt(0);
              _accelZData.removeAt(0);
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Motion Detection")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _accelXData,
                    isCurved: true,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: _accelYData,
                    isCurved: true,
                    color: Colors.green,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: _accelZData,
                    isCurved: true,
                    color: Colors.red,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineTouchData: LineTouchData(enabled: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _toggleDataCollection,
              child: Text(_isCollectingData ? 'Stop' : 'Start'),
            ),
          ),
        ],
      ),
    );
  }
}
