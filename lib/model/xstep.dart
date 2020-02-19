import 'package:google_maps_flutter/google_maps_flutter.dart';

class XStep {
  XStep({this.startLocation, this.endLocation, this.distance, this.here});

  LatLng startLocation;
  LatLng endLocation;
  int distance;
  int here;

  factory XStep.fromJson(Map<String, dynamic> json) {
    return new XStep(
      startLocation: new LatLng(
          json["start_location"]["lat"], json["start_location"]["lng"]),
      endLocation:
      new LatLng(json["end_location"]["lat"], json["end_location"]["lng"]),
      distance: json["distance"]["value"],
      here: (json["here"] == null) ? 0 : json["here"],
    );
  }

  Map<String, dynamic> toMap(XStep step) {
    return {
      'start_location' : {
        'lat' : step.startLocation.latitude,
        'lng' : step.startLocation.longitude,
      },
      'end_location' : {
        'lat' : step.endLocation.latitude,
        'lng' : step.endLocation.longitude,
      },
      'distance' : {
        'value' : distance,
      },
      'here' : step.here,
    };
  }
}
