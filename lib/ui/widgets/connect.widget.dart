import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../ble_constants.dart';

class ConnectWidget extends StatefulWidget {
  final Function(BluetoothDevice device) onDeviceConnected;

  const ConnectWidget({super.key, required this.onDeviceConnected});

  @override
  _ConnectWidgetState createState() => _ConnectWidgetState();
}

class _ConnectWidgetState extends State<ConnectWidget> {
  final _peripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;

  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  Future<void> _initBle() async {
    await requestPermissions();
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((isScanning) {
      if (mounted) setState(() => _isScanning = isScanning);
    });
    startSearchAndAdvertise();
  }

  @override
  void dispose() {
    stopSearchAndAdvertise();
    _scanSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();
  }

  Future<void> startSearchAndAdvertise() async {
    if (await _peripheral.isSupported) {
      final advertiseData = AdvertiseData(
        serviceUuid: BleConstants.SERVICE_UUID,
        includeDeviceName: true,
      );
      await _peripheral.start(advertiseData: advertiseData);
      if (mounted)
        setState(() async => _isAdvertising = await _peripheral.isAdvertising);
    }

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      final uniqueResults = <String, ScanResult>{};
      for (var r in results) {
        if (r.advertisementData.serviceUuids.contains(
          BleConstants.SERVICE_UUID.toLowerCase(),
        )) {
          uniqueResults[r.device.remoteId.toString()] = r;
        }
      }
      setState(() => _scanResults = uniqueResults.values.toList());
    });

    await FlutterBluePlus.startScan(
      withServices: [Guid(BleConstants.SERVICE_UUID)],
      timeout: null,
    );
  }

  void stopSearchAndAdvertise() {
    FlutterBluePlus.stopScan();
    if (_isAdvertising) {
      _peripheral.stop();
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    print("Tentative de connexion à ${device.platformName}...");
    stopSearchAndAdvertise();

    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 15),
      );

      print("Connecté avec succès à ${device.platformName} !");

      if (mounted) {
        widget.onDeviceConnected(device);
        Navigator.pop(context);
      }
    } catch (e) {
      print("ERREUR de connexion : $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Échec de la connexion à ${device.platformName}."),
          ),
        );
        startSearchAndAdvertise();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recherche d\'autres utilisateurs...',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            _isAdvertising ? "Vous êtes visible." : "Vous n'êtes pas visible.",
            style: TextStyle(color: _isAdvertising ? Colors.green : Colors.red),
          ),
          if (_isScanning && _scanResults.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!_isScanning && _scanResults.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  "Aucun utilisateur trouvé.",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

          Expanded(
            child: ListView(
              children: _scanResults
                  .map(
                    (result) => ListTile(
                      title: Text(
                        result.device.platformName.isNotEmpty
                            ? result.device.platformName
                            : "Appareil Inconnu",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        result.device.remoteId.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () => _connectToDevice(result.device),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
