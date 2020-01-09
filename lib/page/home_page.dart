import 'dart:convert';

import 'package:alpha_task/database/db_manager.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/page/circuit/circuits_page.dart';
import 'package:alpha_task/page/main_page.dart';
import 'package:alpha_task/page/map/map_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
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
  List<Circuit> circuits;

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

  void initEnv() async {
    state = new SettingsState();
    prefs = await SharedPreferences.getInstance();
    circuits = await _dbManager.getAllCircuits();
    print('home page circuits length : ${circuits.length}');
    state.language = prefs.get('language');
    state.languageMap = json.decode(prefs.get(state.language));
    _children.addAll([
      MapPage(
        circuit: (circuits != null)
            ? (circuits.length > 0) ? circuits[0] : null
            : null,
      ),
      CircuitsPage(
        settingsState: state,
        circuits: circuits,
      ).build(context),
      MainPage(
        state: state,
      ),
      Container(),
      Container(),
    ]);
    setState(() {
      ready = true;
    });
    _titles.addAll([
      'Proximity',
      'Circuits',
      '',
      '',
      '',
    ]);
  }

  @override
  void initState() {
    super.initState();
    initEnv();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return (!ready)
        ? Container(
            color: Colors.black,
          )
        : Scaffold(
            extendBodyBehindAppBar:
                (_currentIndex == 2 || _currentIndex == 0) ? true : false,
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
