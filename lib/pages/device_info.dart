import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';


//device info screen -- where all available information regarding the devices are shown
class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  AndroidDeviceInfo? androidInfo;
  Future<AndroidDeviceInfo> getInfo() async {
    return await deviceInfo.androidInfo;
  }

  Widget showCard(String name, String value) {
    return Card(
      child: ListTile(
        title: Text(
          "$name : $value",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: FutureBuilder<AndroidDeviceInfo>(
      future: getInfo(),
      builder: (context, snapshot) {
        final data = snapshot.data!;
        return Column(
          children: [
            showCard('board', data.board),
            showCard('bootloader', data.bootloader),
            showCard('brand', data.brand),
            showCard('device', data.device),
            showCard('display', data.display),
            showCard('fingerprint', data.fingerprint),
            showCard('hardware', data.hardware),
            showCard('host', data.host),
            showCard('manufacturer', data.manufacturer),
            showCard('model', data.model),
            showCard('product', data.product),
            showCard('supported32BitAbis', data.supported32BitAbis.toString()),
            showCard('supported64BitAbis', data.supported64BitAbis.toString()),
            showCard('tags', data.tags),
            showCard('type', data.type),
            showCard('isPhysicalDevice', data.isPhysicalDevice.toString()),
            showCard('androidId', data.id),
            showCard('systemFeatures', data.systemFeatures.toString()),
            showCard('version', data.version.release.toString()),
          ],
        );
      },
    )));
  }

}
