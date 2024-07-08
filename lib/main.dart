// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'bluetooth_service.dart' as my; // Alias the import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Audio Router',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioRouterPage(),
    );
  }
}

class AudioRouterPage extends StatefulWidget {
  @override
  _AudioRouterPageState createState() => _AudioRouterPageState();
}

class _AudioRouterPageState extends State<AudioRouterPage> {
  final List<Map<String, dynamic>> apps = [
    {'name': 'Spotify', 'useBluetooth': true},
    {'name': 'YouTube', 'useBluetooth': false},
    {'name': 'WhatsApp', 'useBluetooth': false},
  ];

  static const platform = MethodChannel('audio_router');
  final my.MyBluetoothService bluetoothService =
      my.MyBluetoothService(); // Use the aliased import

  @override
  void initState() {
    super.initState();
    bluetoothService.isBluetoothConnected().listen((isConnected) {
      if (isConnected) {
        _routeAudio();
      }
    });
  }

  void _routeAudio() async {
    for (var app in apps) {
      await platform.invokeMethod('routeAudio', {
        'appName': app['name'],
        'useBluetooth': app['useBluetooth'],
      });
    }
  }

  void _toggleBluetooth(int index, bool value) {
    setState(() {
      apps[index]['useBluetooth'] = value;
    });
    _routeAudio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Audio Router'),
      ),
      body: ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(apps[index]['name']),
              trailing: Switch(
                value: apps[index]['useBluetooth'],
                onChanged: (value) => _toggleBluetooth(index, value),
              ),
            ),
          );
        },
      ),
    );
  }
}
