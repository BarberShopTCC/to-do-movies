import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:to_do_list/app/shared/styles/colors.dart';

class MenuWidget extends StatelessWidget {
  final LocationData? location;
  final bool isTablet;

  const MenuWidget({
    Key? key,
    this.location,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, kMainColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: location != null
                    ? GestureDetector(
                        onTap: () => launcherMap(location!),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              '${location?.latitude ?? 0},${location?.longitude ?? 0}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: isTablet
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 24.0, left: 24.0, right: 24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      Text(
                        'Batman',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    MenuItemWidget(
                      title: 'home.edit'.tr(),
                    )
                  ],
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Modular.to.pushNamed('/home/about'),
                      child: Text(
                        'home.about'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Container(
                        width: 1,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Modular.to.pushNamed('/home/terms'),
                      child: Text(
                        'home.terms_of_use'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  launcherMap(LocationData loc) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(loc.latitude!, loc.longitude!),
      title: "Ocean Beach",
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const MenuItemWidget({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: OutlinedButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.white, width: 2.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          textStyle: TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
