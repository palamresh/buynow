import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GetBatteryScreen extends StatefulWidget {
  const GetBatteryScreen({super.key});

  @override
  State<GetBatteryScreen> createState() => _GetBatteryScreenState();
}

class _GetBatteryScreenState extends State<GetBatteryScreen> {
  static const platform = MethodChannel('com.example/battery');
  String _unknown = 'Unknown battery level.';
  String device = "unknown";
  String result = "Result will come here";
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level: ${e.message}';
    }
    setState(() {
      _unknown = batteryLevel;
    });
  }

  Future<void> getDeviceInfo() async {
    try {
      final String result = await platform.invokeMethod('getDeviceInfo');
      device = 'Device info: $result';
      setState(() {});
    } on PlatformException catch (e) {
      device = 'Failed to get device info: ${e.message}';
    }
  }

  Future<void> calculateSum() async {
    try {
      // Arguments pass karna
      final int sum = await platform.invokeMethod("getSum", {"a": 10, "b": 20});
      setState(() {
        result = "Sum = $sum";
      });
    } on PlatformException catch (e) {
      setState(() {
        result = "Failed: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Battery Level")),
      body: Column(
        children: [
          Text(_unknown),
          Text(device),
          Text(result),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _getBatteryLevel();
                getDeviceInfo();
                calculateSum();
              },
              child: Text("Get Battery Level"),
            ),
          ),
        ],
      ),
    );
  }
}
