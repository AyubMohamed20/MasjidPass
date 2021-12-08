import 'package:flutter/material.dart';
import 'package:masjid_pass/setting_page/settings_page_controller.dart';
import 'package:masjid_pass/utilities/screen_size_config.dart';

class InfoSideBanner extends StatelessWidget {
  const InfoSideBanner({Key? key, required this.controller}) : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(
            title: const Center(
              child: Text(
                'MasjidPass',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ),
          const ListTile(
            title: Center(
              child: Text(
                'System Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InfoBannerListTile(
              'Device ID', controller.identifier, controller.deviceIdOnTap()),
          const Divider(
            thickness: 2,
          ),
          InfoBannerListTile(
              'Scanner Version', '3.0', controller.scannerVersionOnTap()),
          const Divider(
            thickness: 2,
          ),
          const InfoBannerListTile('Authentication API Version', '1.0', null),
          const Divider(
            thickness: 2,
          ),
          const InfoBannerListTile('Backend API Version', '1.0', null),
          const Divider(
            thickness: 2,
          ),
        ], //children
      ),
    );
  }
}

class InfoBannerListTile extends StatelessWidget {
  final String text;
  final String subtitle;
  final Function? func;

  const InfoBannerListTile(this.text, this.subtitle, this.func);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      onTap: () => {
        func,
      },
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key, required this.controller}) : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog<String>(
          context: controller.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    controller.logoutButtonOnPressed();
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
      child: Text('Logout',
          style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
    );
  }
}

class TestingModeBanner extends StatelessWidget {
  const TestingModeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        width: SizeConfig.screenWidth,
        margin: const EdgeInsets.only(top: 50),
        color: Colors.red,
        child: Center(
          child: Text('Testing Mode',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical * 2)),
        ),
      ),
    );
  }
}

class OrganizationName extends StatelessWidget {
  const OrganizationName({Key? key}) : super(key: key);

  // TODO: Check if this Value should be hard coded
  final String organizationName = 'SNMC Mosque';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(organizationName,
            style: TextStyle(
                color: Colors.lightBlue,
                fontSize: SizeConfig.blockSizeVertical * 3.33)),
      ),
    );
  }
}

class SelectDoorText extends StatelessWidget {
  const SelectDoorText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Text(text,
            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.22)));
  }
}

class SelectDoorDropDown extends StatelessWidget {
  const SelectDoorDropDown({Key? key, required this.controller})
      : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: controller.entrance,
      icon:
          Icon(Icons.arrow_downward, size: SizeConfig.blockSizeVertical * 3.33),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        controller.entrancesDropDownOnChanged(newValue);
      },
      items: controller.organizationEntrances
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.22)),
        );
      }).toList(),
    );
  }
}

class DirectionSwitch extends StatelessWidget {
  const DirectionSwitch({Key? key, required this.controller}) : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Transform.scale(
            scale: SizeConfig.blockSizeVertical * 0.2,
            child: Switch(
              onChanged: (controller.toggleSwitch),
              value: controller.isSwitched,
              activeTrackColor: Colors.blue,
              activeColor: Colors.blueAccent,
            ),
          ),
        ),
        Text(
          controller.switchText,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: controller.switchTextColor,
              fontSize: SizeConfig.blockSizeVertical * 2),
        ),
      ],
    );
  }
}

class SelectEventButton extends StatelessWidget {
  const SelectEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(
        'Select Event',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockSizeVertical * 2.5),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  const ScanButton({Key? key, required this.controller}) : super(key: key);
  final SettingsPageController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ElevatedButton(
      onPressed: () {
        controller.scanButtonOnPressed();
      },
      child: Text(
        'Scan',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.blockSizeVertical * 2.5),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
    ));
  }
}
