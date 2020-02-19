import 'dart:convert';

import 'package:alpha_task/database/db_manager.dart';
import 'package:alpha_task/database/image_db_manager.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/page/circuit/circuits_page.dart';
import 'package:alpha_task/page/main_page.dart';
import 'package:alpha_task/page/map/map_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/tools/filter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // DB Params

  DbManager _dbManager = DbManager();
  ImageDbManager _imageDbManager = new ImageDbManager();
  List<Circuit> circuits = [];
  List<Site> sites = [];

  // Global Params

  SharedPreferences prefs;
  bool ready = false;
  int _currentIndex = 2;
  List<Widget> _children = [];
  List<String> _titles = [];
  double height;
  double width;

  // Constructors

  SettingsState state;
  Filter filter = new Filter();

  // Pages

  Widget homePage;
  Widget circuitsPage;
  Widget mapPage;

  void initEnv(BuildContext context) async {
    state = new SettingsState();
    prefs = await SharedPreferences.getInstance();
    sites.addAll(await _dbManager.getAllSites());
    circuits.addAll(await _dbManager.getAllCircuits());
    await loadImages();
    print('image path : ${circuits[0].sites[0].images[0].localPath}');
    state.language = prefs.get('language');
    state.languageMap = json.decode(prefs.get(state.language));
    _titles.addAll([
      'Proximity',
      'Circuits',
      '',
      '',
      '',
    ]);
    homePage = MainPage(
      state: state,
    );
    circuitsPage = CircuitsPage(
      context: context,
      settingsState: state,
      circuits: circuits,
    ).build();
    mapPage = MapPage(
      circuit: (circuits != null)
          ? (circuits.length > 0) ? circuits[0] : null
          : null,
      buildType: 1,
    );
    setState(() {
      ready = true;
    });
//    _children.addAll([
//      MapPage(
//        circuit: (circuits != null)
//            ? (circuits.length > 0) ? circuits[0] : null
//            : null,
//      ),
//      CircuitsPage(
//        settingsState: state,
//        circuits: circuits,
//      ).build(context),
//      MainPage(
//        state: state,
//      ),
//      Container(),
//      Container(),
//    ]);
//    setState(() {
//      ready = true;
//    });
//    _titles.addAll([
//      'Proximity',
//      'Circuits',
//      '',
//      '',
//      '',
//    ]);
  }

  void callBack() {
    //print(circuits[0].sites[0].images[0].localPath);
    setState(() {});
  }

  Future loadImages() async {
    //int sum = 0;
    await _imageDbManager.loadSitesImages(sites, callBack);
    for (int i = 0; i < circuits.length; i++) {
      //sum = sum + await _imageDbManager.loadSitesImages([i], callBack);
      List<Site> newList = filter.updateSitesList(sites, circuits[i].sites);
      circuits[i].sites.clear();
      circuits[i].sites.addAll(newList);
      await _dbManager.updateCircuit(circuits[i]);
    }
//    if (sum > 0) {
//      List<Circuit> newCircuits = await _dbManager.getAllCircuits();
//      circuits.clear();
//      circuits.addAll(newCircuits);
//      print(circuits[0].sites[0].images[0].toMap());
//      homePage = MainPage(
//        state: state,
//      );
//      circuitsPage = CircuitsPage(
//        context: context,
//        settingsState: state,
//        circuits: circuits,
//      ).build();
//      mapPage = MapPage(
//        circuit: (circuits != null)
//            ? (circuits.length > 0) ? circuits[0] : null
//            : null,
//        buildType: 1,
//      );
//      _children.clear();
//      _children.addAll([
//        mapPage,
//        circuitsPage,
//        homePage,
//        Container(),
//        Container(),
//      ]);
//      callBack();
//    }
  }

  @override
  void initState() {
    super.initState();
    initEnv(context);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (ready) {
      _children.addAll([
        mapPage,
        circuitsPage,
        homePage,
        Container(),
        Container(),
      ]);
    }
    return (!ready)
        ? Container(
            color: Colors.black,
          )
        : Scaffold(
            extendBodyBehindAppBar:
                (_currentIndex == 2 || _currentIndex == 0) ? true : false,
            //backgroundColor: Color(0xfff0f0f0),
//            appBar: AppBar(
//              title: Align(
//                alignment: Alignment.center,
//                child: Text(
//                  _titles[_currentIndex],
//                  style: TextStyle(
//                    fontFamily: 'Roboto-regular',
//                    color: Colors.black38,
//                    fontSize: 16,
//                  ),
//                ),
//              ),
//              backgroundColor: Colors.white.withOpacity(0.1),
//              elevation: 0,
//            ),
            body: (_currentIndex == 2)
                ? _children[_currentIndex]
                : Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: _children[_currentIndex],
                  ),
            bottomNavigationBar: BottomNavigationBar(
              selectedIconTheme: IconThemeData(
                color: Colors.black12,
              ),
              selectedItemColor: Colors.black54,
              unselectedItemColor: Colors.black12,
              unselectedLabelStyle: TextStyle(
                color: Colors.black12,
                fontSize: 12,
              ),
              selectedLabelStyle: TextStyle(
                color: Colors.black54,
                fontSize: 10,
              ),
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.near_me),
                  activeIcon: Icon(
                    Icons.near_me,
                    color: Colors.black54,
                  ),
                  title: new Text(state.languageMap['proximity']),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.map),
                  activeIcon: Icon(
                    Icons.map,
                    color: Colors.black54,
                  ),
                  title: new Text(state.languageMap['circuit']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.black54,
                  ),
                  title: Text(state.languageMap['home']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_agenda),
                  activeIcon: Icon(
                    Icons.view_agenda,
                    color: Colors.black54,
                  ),
                  title: Text(state.languageMap['agenda']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  activeIcon: Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                  title: Text(state.languageMap['settings']),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          );
  }
}
