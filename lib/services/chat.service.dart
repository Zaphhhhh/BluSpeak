import 'dart:async';
import 'dart:convert';

import 'package:bluspeak/ble_constants.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ChatService {
  final BluetoothDevice connectedDevice;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;
  StreamController<String> _messageController = StreamController.broadcast();

  Stream<String> get messages => _messageController.stream;

  ChatService({required this.connectedDevice});

  Future<void> initialize() async {
    List<BluetoothService> services = await connectedDevice.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toLowerCase() ==
          BleConstants.SERVICE_UUID.toLowerCase()) {
        for (var char in service.characteristics) {
          if (char.uuid.toString().toLowerCase() ==
              BleConstants.WRITE_CHARACTERISTIC_UUID.toLowerCase()) {
            _writeCharacteristic = char;
          }
          if (char.uuid.toString().toLowerCase() ==
              BleConstants.NOTIFY_CHARACTERISTIC_UUID.toLowerCase()) {
            _notifyCharacteristic = char;
            await _notifyCharacteristic!.setNotifyValue(true);
            _notifyCharacteristic!.value.listen((value) {
              _messageController.add(utf8.decode(value));
            });
          }
        }
      }
    }
  }

  void sendMessage(String message) {
    if (_writeCharacteristic != null) {
      _writeCharacteristic!.write(utf8.encode(message));
    }
  }

  void dispose() {
    _messageController.close();
    connectedDevice.disconnect();
  }
}
