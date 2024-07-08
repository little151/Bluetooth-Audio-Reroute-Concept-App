import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    _startDeviceDiscovery();
  }

  void _startDeviceDiscovery() {
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      setState(() {
        scanResults = results;
      });
    });
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Discover Bluetooth Devices'), // Blue underline is expected and normal
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = scanResults[index].device;
          return ListTile(
            title: Text(device.name ??
                'Unknown Device'), // Yellow underline might suggest unused string
            onTap: () => _connectToDevice(device),
          );
        },
      ),
    );
  }

  void _connectToDevice(BluetoothDevice device) {
    print(
        'Connecting to ${device.name}'); // Blue underline is expected and normal
    // Implement connection logic here
  }
}
