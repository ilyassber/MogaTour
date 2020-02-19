import 'package:alpha_task/model/site.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:core';
import 'dart:math';

class GeoTools {
  void initSitesGeoPos(List<Site> sites) {
    if (sites != null) {
      for (int i = 0; i < sites.length; i++) {
        sites[i].lat = double.parse(sites[i].gpsLocation.split(',')[0]);
        sites[i].lng = double.parse(sites[i].gpsLocation.split(',')[1]);
      }
    }
  }

  double getDistance(LatLng start, LatLng end) {
    double distance = sqrt(pow(start.latitude - end.latitude, 2) + pow(start.longitude - end.longitude, 2));
    distance = distance / 0.00000449964;
    return distance;
  }

  LatLng getNearestPoint(Site site, LatLng location) {
    LatLng latLng;
    double a;
    double b = 1;
    double c;
    double distance = -1;
    int index = -1;

    for (int i = 0; i < site.stepsToNext.length; i++) {
      a = (site.stepsToNext[i].startLocation.latitude -
              site.stepsToNext[i].endLocation.latitude) /
          (site.stepsToNext[i].startLocation.longitude -
              site.stepsToNext[i].endLocation.longitude);
      c = site.stepsToNext[i].startLocation.longitude -
          (a * site.stepsToNext[i].startLocation.latitude);
      double d = (((a * location.latitude) + (b * location.longitude) + c) /
              (sqrt(pow(a, 2) + pow(b, 2))))
          .abs();
      if ((distance != -1 && d < distance) || (distance == -1)) {
        distance = d;
        index = i;
      }
    }

    return latLng;
  }
}
