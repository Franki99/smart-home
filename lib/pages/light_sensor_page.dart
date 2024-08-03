import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'dart:async';

class LightSensorPage extends StatefulWidget {
  @override
  _LightSensorPageState createState() => _LightSensorPageState();
}

class _LightSensorPageState extends State<LightSensorPage> {
  late Light _light;
  late StreamSubscription<int> _lightSubscription;
  int _luxValue = 0;

  @override
  void initState() {
    super.initState();
    _light = Light();
    _lightSubscription = _light.lightSensorStream.listen(onData);
  }

  void onData(int luxValue) {
    setState(() {
      _luxValue = luxValue;
    });
  }

  @override
  void dispose() {
    _lightSubscription.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Light Sensor")),
      body: Center(
        child: Text('Current Light Level: $_luxValue lux'),
      ),
    );
  }
}
