import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:math';

Future<List> optimalMeetingPoints(
    List<List<dynamic>> coordinate, List<List> possibleMeetingSpots) async {
  int nPeople = coordinate.length;
  int nSpots = possibleMeetingSpots.length;

  double sum_x = 0;
  double sum_y = 0;
  double sum_z = 0;

  for (int i = 0; i < nPeople; i++) {
    var latRad = coordinate[i][0] * pi / 180;
    var lngRad = coordinate[i][1] * pi / 180;

    sum_x += cos(latRad) * cos(lngRad);
    sum_y += cos(latRad) * sin(lngRad);
    sum_z += sin(latRad);
  }

  double centX = sum_x / nPeople;
  double centY = sum_y / nPeople;
  double centZ = sum_z / nPeople;

  double centreLng = atan2(centY, centX);
  double centreHyp = sqrt(centX * centX + centY * centY);
  double centreLat = atan2(centZ, centreHyp);

  List<List<dynamic>> distances = new List.generate(
      nSpots, (i) => new List.generate(2, (j) => 0),
      growable: false);

  for (int i = 0; i < nSpots; i++) {
    distances[i][0] = possibleMeetingSpots[i][0];
  }

  for (int i = 0; i < nSpots; i++) {
    var lat1 = centreLat;
    var lng1 = centreLng;
    var lat2 = possibleMeetingSpots[i][1];
    var lng2 = possibleMeetingSpots[i][2];

//    double dist = 3963.0 * acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lng1 - lng2));

    // double dist = await distance2point(
    //   GeoPoint(
    //     longitude: lng1,
    //     latitude: lat1,
    //   ),
    //   GeoPoint(
    //     longitude: lng2,
    //     latitude: lat2,
    //   ),
    // );

    // distances[i][1] = dist;
  }

  //Sorting the lost of places
  //in ascending order of their distances from the centroid
  distances.sort((a, b) => a[1].compareTo(b[1]));

  //Defining list of three places closest to the centroid
  var threeOptimalPlaces = ["1", "2", "3"];

  threeOptimalPlaces[0] = distances[0][0];
  threeOptimalPlaces[1] = distances[1][0];
  threeOptimalPlaces[2] = distances[2][0];

  return threeOptimalPlaces;
}