import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationTrackingPage extends StatefulWidget {
  @override
  _LocationTrackingPageState createState() => _LocationTrackingPageState();
}

class _LocationTrackingPageState extends State<LocationTrackingPage> {
  Position? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return Future.error('Location permissions are permanently denied.');
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return Future.error('Failed to get location.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Tracking")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _currentPosition == null
                ? Text('Location not available')
                : Text(
                    'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'),
      ),
    );
  }
}
