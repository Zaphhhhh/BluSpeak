import 'package:bluspeak/ui/widgets/chat.widget.dart';
import 'package:bluspeak/ui/widgets/connect.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _connectionStatus = "Disconnected";
  BluetoothDevice? _connectedDevice;

  void _showConnectPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0E21),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: ConnectWidget(
            onDeviceConnected: (device) {
              setState(() {
                _connectedDevice = device;
                _connectionStatus = "Connected to ${device.platformName}";
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: InkWell(
          onTap: _showConnectPanel,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            child: Text(
              _connectionStatus,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: const ChatWidget(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF050919),
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            tooltip: "Chats",
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            tooltip: "Profile",
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
