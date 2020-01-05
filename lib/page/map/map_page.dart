import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/xstep.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/tools/geo_tools.dart';
import 'package:alpha_task/tools/network_tools.dart';
import 'package:alpha_task/widget/elem_to_widget.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  MapPage({
    @required this.circuit,
  });

  final Circuit circuit;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Circuit circuit;
  static List<Site> sites;
  NetworkTools network = new NetworkTools();
  ElemToWidget elemToWidget = new ElemToWidget();
  GeoTools geoTools = new GeoTools();

  CameraPosition _StartCamera;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  MapType _currentMapType = MapType.normal;
  LatLng _lastMapPosition = _center;
  List<LatLng> latlng = [];
  List<Widget> list = [];
  XList xList;

  BitmapDescriptor marker1;
  Uint8List markerIcon;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void initList(BuildContext context) {
    list.clear();
    print('sites len ==>> ${sites.length}');
    for (int i = 0; i < sites.length; i++) {
      list.add(elemToWidget.siteSmallWidget(context, i, sites[i]));
    }
    xList = new XList(
      context: context,
      list: list,
      onClick: null,
    );
  }

  @override
  void initState() {
    super.initState();
    circuit = widget.circuit;
    sites = circuit.sites;
    geoTools.initSitesGeoPos(sites);
    _StartCamera = CameraPosition(
      target: getSitePosition(sites[0]),
      zoom: 14.4746,
    );
    Future<Uint8List>.delayed(new Duration(milliseconds: 0),
    () => getBytesFromAsset('assets/icons/marker1.png', 100)).then((value) {
    markerIcon = value;
    initMarkers();
    });
  }

  static LatLng getSitePosition(Site site) {
    return new LatLng(site.lat, site.lng);
  }

  void addMarkers(List<Site> sites) {
    _markers.clear();
    for (int i = 0; i < sites.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString() + '$i'),
        position: getSitePosition(sites[i]),
        infoWindow: InfoWindow(
          title: sites[i].siteTitle,
          snippet: '${sites[i].rating} star',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
  }

  void initMarkers() {
    setState(() {
      addMarkers(sites);
    });
  }

  Future<List<XStep>> scanRoad(List<XStep> steps) {
    int i = 0;
    int pass = 1;
    List<XStep> newRoad;
    while (i < steps.length) {
      if (pass == 1) {
        pass = 0;
        getDirectionSteps(steps[i]).then((value) {
          newRoad.addAll(value);
          pass = 1;
          i++;
        });
      }
    }
    return Future.delayed(Duration(milliseconds: 100), () => newRoad);
  }

  Future<List<XStep>> loopRoadScan(
      List<XStep> steps, List<XStep> result, int length, int i) async {
    while (i < length) {
      await network
          .get("origin=" +
          steps[i].startLocation.latitude.toString() +
          "," +
          steps[i].startLocation.longitude.toString() +
          "&destination=" +
          steps[i].endLocation.latitude.toString() +
          "," +
          steps[i].endLocation.longitude.toString() +
          "&key=AIzaSyB940mpfv4pNgFIHTLI2v0nEXcAiQaYMjE")
          .then((dynamic res) {
        print(res.length.toString() + ' + ' + result.length.toString());
        result.addAll(res);
        print(result.length.toString());
        i++;
        //if (i < length) loopRoadScan(steps, result, length, i);
      });
    }
    print('result => ' + result.length.toString());
    return Future.delayed(Duration(milliseconds: 0), () => result);
  }

  Future<List<XStep>> getDirectionSteps(XStep step) {
    List<XStep> rr;
    network
        .get("origin=" +
        step.startLocation.latitude.toString() +
        "," +
        step.startLocation.longitude.toString() +
        "&destination=" +
        step.endLocation.latitude.toString() +
        "," +
        step.endLocation.longitude.toString() +
        "&key=AIzaSyB940mpfv4pNgFIHTLI2v0nEXcAiQaYMjE")
        .then((dynamic res) {
      rr = res;
    });
    return Future.delayed(Duration(milliseconds: 100), () => rr);
  }

  void getRoad(LatLng start, LatLng end, int deptScan) {
    XStep step = new XStep(startLocation: start, endLocation: end);
    List<XStep> startList = [step];
    List<XStep> finalRoad = [];
    loopRoadScan(startList, finalRoad, startList.length, 0).then((value) {
      List<XStep> rr = value;
      for (final i in rr) {
        latlng.add(i.startLocation);
        latlng.add(i.endLocation);
      }

      setState(() {
        _polyline.add(Polyline(
          polylineId: PolylineId("12"),
          visible: true,
          //latlng is List<LatLng>
          points: latlng,
          color: Colors.blue,
          width: 5,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initList(context);

    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            polylines: _polyline,
            mapType: _currentMapType,
            initialCameraPosition: _StartCamera,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers.toSet(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 130,
                child: xList.build(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
