// lib/bluetooth_service.dart
import 'package:flutter_blue/flutter_blue.dart';

class MyBluetoothService {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  Stream<bool> isBluetoothConnected() async* {
    await for (final state in flutterBlue.state) {
      yield state == BluetoothState.on;
    }
  }
}
