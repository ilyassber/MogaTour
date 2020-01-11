import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/xstep.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/tools/geo_tools.dart';
import 'package:alpha_task/tools/network_tools.dart';
import 'package:alpha_task/widget/btn_widget.dart';
import 'package:alpha_task/widget/elem_to_widget.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  MapPage({
    @required this.circuit,
  });

  final Circuit circuit;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // General Params

  NetworkTools network = new NetworkTools();
  ElemToWidget elemToWidget = new ElemToWidget();
  GeoTools geoTools = new GeoTools();
  List<Widget> list = [];
  XList xList;
  bool activateDispose = false;

  // Permissions Params

  PermissionStatus _status;

  // Circuits Params

  Circuit circuit;
  List<Site> sites = [];

  // Map Params

  final Set<Polyline> _polyline = {};
  MapType _currentMapType = MapType.normal;
  List<LatLng> latlng = [];
  GoogleMapController mapController;
  LatLng _centre;
  Position currentLocation;
  FutureOr<GoogleMapController> get controller => null;
  String _mapStyle;
  double _zoom = 15;

  // Markers Params

  final Set<Marker> _markers = {};
  BitmapDescriptor marker1;
  Uint8List markerIcon;
  List<String> paths = [
    'assets/markers/real_pos.png',
    'assets/markers/cross.png',
    'assets/markers/exhibition.png',
    'assets/markers/islam.png',
    'assets/markers/juif.png',
    'assets/markers/tower.png',
    'assets/markers/woods.png',
  ];
  List<Uint8List> markerIcons = [];
  Marker userPos;

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
      onClick: siteLocation,
    );
  }

  static LatLng getSitePosition(Site site) {
    return new LatLng(site.lat, site.lng);
  }

  // get Markers

  Future<List<Uint8List>> iconToBit(List<String> links) async {
    List<Uint8List> list = [];
    for (int i = 0; i < links.length; i++) {
      list.add(await getBytesFromAsset(links[i], 120));
    }
    return list;
  }

  void initBitMarkers() async {
    markerIcons.clear();
    markerIcons.addAll(await iconToBit(paths));
    getUserLocation();
    //addMarkers(sites);
  }

//  void initMarkers(List<String> paths) async {
//    if (markerIcons.length == 0) markerIcons.addAll(await iconToBit(paths));
//    for (int i = 1; i < markerIcons.length; i++) {
//      _markers.add(new Marker(
//        onTap: () {
//          //ToDo
//        },
//        markerId: MarkerId('$i'),
//        icon: BitmapDescriptor.fromBytes(markerIcons[i]),
//        position: new LatLng(shops[i - 1].lat, shops[i - 1].lng),
//      ));
//    }
//    userPos = new Marker(
//      markerId: MarkerId('0'),
//      icon: BitmapDescriptor.fromBytes(markerIcons[0]),
//      position: new LatLng(_centre.latitude, _centre.longitude),
//    );
//    _markers.add(userPos);
//    setState(() {});
//    updateUserLocation();
//  }

  void addMarkers(List<Site> sites) {
    _markers.clear();
    for (int i = 0; i < sites.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('$i'),
        position: getSitePosition(sites[i]),
        infoWindow: InfoWindow(
          title: sites[i].siteTitle,
          snippet: '${sites[i].rating} star',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcons[sites[i].markerId]),
      ));
    }

    userPos = new Marker(
      markerId: MarkerId('0'),
      icon: BitmapDescriptor.fromBytes(markerIcons[0]),
      position: new LatLng(_centre.latitude, _centre.longitude),
    );
    _markers.add(userPos);
    if (!activateDispose) setState(() {});
    updateUserLocation();
  }

//  void initMarkers() {
//    setState(() {
//      addMarkers(sites);
//    });
//  }

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

      if (!activateDispose) {
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
      }
    });
  }

  //TODO: Get Users' location

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void getUserLocation() async {
    _markers.clear();
    currentLocation = await locateUser();
    if (!activateDispose) {
      setState(() {
        _centre = LatLng(currentLocation.latitude ?? 53.467125,
            currentLocation.longitude ?? -2.233966);
      });
    }
    print('centre $_centre');
    addMarkers(sites);
  }

  void updateUserLocation() async {
    while (true) {
      currentLocation = await locateUser();
      if (!activateDispose) {
        setState(() {
          _markers.remove(userPos);
          _centre = LatLng(currentLocation.latitude ?? 53.467125,
              currentLocation.longitude ?? -2.233966);
          userPos = new Marker(
            markerId: MarkerId('0'),
            icon: BitmapDescriptor.fromBytes(markerIcons[0]),
            position: new LatLng(_centre.latitude, _centre.longitude),
          );
          _markers.add(userPos);
        });
      }
    }
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.locationWhenInUse)
          .then(_updateStatus);
    }
    print("STATE -> $state");
  }

  void _askPermission() {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];
    if (status != PermissionStatus.granted) {
      // On iOS if "deny" is pressed, open App Settings
      PermissionHandler().openAppSettings();
    } else {
      //_updateStatus(status);
      print("STATUS -> $status");
    }
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      // check status has changed
      if (!activateDispose) {
        setState(() {
          _status = status; // update
          //_onMapCreated(controller);
        });
      }
    } else {
      if (status != PermissionStatus.granted) {
        print("REQUESTING PERMISSION");
        _askPermission();
      }
    }
  }

  // Callback Functions

  void _toLocation(Position position) {
    final GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _zoom,
          tilt: 0.0),
    ));
  }

  void myLocation() {
    _toLocation(currentLocation);
  }

  void siteLocation(int i) {
    setState(() {
      sites[i].visited = 1;
      Position position = new Position(
        latitude: sites[i].lat,
        longitude: sites[i].lng,
      );
      _toLocation(position);
    });
  }

  void _zoomIn() async {
    if (_zoom <= 19) {
      _zoom = _zoom + 1;
      final GoogleMapController controller = mapController;
      LatLng latLng = await _currentCameraPosition();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: _zoom, tilt: 0.0),
      ));
    }
  }

  void _zoomOut() async {
    if (_zoom >= 3) {
      _zoom = _zoom - 1;
      final GoogleMapController controller = mapController;
      LatLng latLng = await _currentCameraPosition();
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: _zoom, tilt: 0.0),
      ));
    }
  }

  Future<LatLng> _currentCameraPosition() async {
    final GoogleMapController controller = mapController;
    LatLngBounds latLngBounds = await controller.getVisibleRegion();
    LatLng latLng = new LatLng(
        (latLngBounds.northeast.latitude + latLngBounds.southwest.latitude) / 2,
        (latLngBounds.northeast.longitude + latLngBounds.southwest.longitude) /
            2);
    return latLng;
  }

  @override
  void initState() {
    super.initState();
    circuit = widget.circuit;
    if (circuit.sites != null) sites = circuit.sites;
    geoTools.initSitesGeoPos(sites);
    initBitMarkers();
    rootBundle.loadString('assets/map/map_style_silver').then((string) {
      if (!activateDispose) {
        setState(() {
          _mapStyle = string;
          print(string);
        });
      }
    });
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup
            .locationWhenInUse) //check permission returns a Future
        .then(_updateStatus);
    //initMarkers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    activateDispose = false;
    getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
    activateDispose = true;
  }

  @override
  Widget build(BuildContext context) {
    initList(context);

    return new Container(
      child: Stack(
        children: <Widget>[
          (currentLocation == null)
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    //_mapController.complete(controller);
                    mapController = controller;
                    if (_mapStyle != null && controller != null) {
                      print('#### SET_MAP_STYLE ####');
                      mapController.setMapStyle(_mapStyle);
                    }
                  },
                  initialCameraPosition: // required parameter that sets the starting camera position. Camera position describes which part of the world you want the map to point at.
                      CameraPosition(
                          target: LatLng(currentLocation.latitude,
                              currentLocation.longitude),
                          zoom: _zoom,
                          tilt: 0.0),
                  markers: _markers,
                  polylines: _polyline,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationEnabled: false,
                  mapType: _currentMapType,
                  zoomGesturesEnabled: true,
                  mapToolbarEnabled: false,
                  onCameraMove: (CameraPosition position) {
                    _zoom = position.zoom;
                  },
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
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 60, 5, 0),
              child: BtnWidget(
                      size: 25,
                      height: 40,
                      width: 40,
                      icon: Icons.my_location,
                      text: null,
                      onClick: myLocation)
                  .build(),
            ),
          ),
        ],
      ),
    );
  }
}
