import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class NewMap extends StatefulWidget {
  const NewMap({super.key, required this.locationArray});
  final Map<String, Map<String, List<double>>> locationArray;

  @override
  State<NewMap> createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {
  String groupName = "friends";
  final MapController mapController = MapController(
    initMapWithUserPosition: true,
    areaLimit: const BoundingBox.world(),
  );
  final GlobalKey mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, List<double>>> locationArray = widget.locationArray;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: OSMFlutter(
            showContributorBadgeForOSM: true,
            controller: mapController,
            key: mapKey,
            initZoom: 15,
            trackMyPosition: true,
            stepZoom: 1,
          ),
        ),
        FloatingActionButton.extended(
            onPressed: () async {
              await mapController.currentLocation();
            },
            label: const Icon(Icons.my_location)),
        FloatingActionButton.extended(
            onPressed: () async {
              if (locationArray[groupName] == null) {
                locationArray.values.first.forEach((key, value) async {
                  await mapController.addMarker(
                      GeoPoint(latitude: value[0], longitude: value[1]));
                });
              } else {
                locationArray[groupName]!.values.forEach((element) async {
                  await mapController.addMarker(
                      GeoPoint(latitude: element[0], longitude: element[1]));
                });
              }
            },
            label: const Text('Show locations'))
      ],
    );
  }
}