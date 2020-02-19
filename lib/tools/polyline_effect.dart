import 'package:alpha_task/model/xcolor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineEffect {
  PolylineEffect({
    @required this.startColor,
    @required this.endColor,
    @required this.list,
  });

  final XColor startColor;
  final XColor endColor;
  final List<LatLng> list;
  List<LatLng> newList = [];

  List<LatLng> split(LatLng start, LatLng end, int len) {
    List<LatLng> splitList = [];
    double latF = (end.latitude - start.latitude) / len;
    double lngF = (end.longitude - start.longitude) / len;
    splitList.add(start);
    for (int i = 1; i <= len; i++) {
      splitList.add(new LatLng(
          (start.latitude + (latF * i)), (start.longitude + (lngF * i))));
    }
    print("split list len : ${splitList.length}");
    return splitList;
  }

  void splitAll() {
    int len = list.length;
    double factor = 10 / len;
    print("factor : $factor");
    if (factor > 1) {
      for (int i = 0; i < len - 1; i++) {
        newList.addAll(split(list[i], list[i + 1], factor.ceil()));
      }
    } else {
      newList.addAll(list);
    }
  }

  List<Polyline> polylineList() {
    List<Polyline> polylineList = [];
    splitAll();
    int len = newList.length;
    print("list len : ${list.length}");
    print("new list len : ${newList.length}");
    double factor = len / 10;
    for (int i = 0; i < 10; i++) {
      print(i);
      polylineList.add(new Polyline(
        polylineId: PolylineId(i.toString()),
        color: startColor.gradient(endColor, i, 10),
        points: (factor * (i + 1) < len)
            ? newList.sublist(
                (factor * i).floor(), (factor * (i + 1)).floor() + 1)
            : newList.sublist((factor * i).floor(), len),
        width: 6,
        patterns: [PatternItem.dot],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ));
    }
    return polylineList;
  }
}
