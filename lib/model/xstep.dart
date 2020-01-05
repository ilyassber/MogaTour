import 'package:google_maps_flutter/google_maps_flutter.dart';

class XStep {
  XStep({this.startLocation, this.endLocation});

  factory XStep.fromJson(Map<String, dynamic> json) {
    return new XStep(
        startLocation: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
  LatLng startLocation;
  LatLng endLocation;
}