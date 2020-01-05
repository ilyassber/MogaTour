import 'dart:convert';

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
  // Global Params

  SharedPreferences prefs;
  bool ready = false;
  int _currentIndex = 2;
  final List<Widget> _children = [];
  double height;
  double width;

  // Constructors

  SettingsState state;

  void initEnv() async {
    state = new SettingsState();
    prefs = await SharedPreferences.getInstance();
    state.language = prefs.get('language');
    state.languageMap = json.decode(prefs.get(state.language));
    _children.addAll([
      MapPage(
        circuit: null,
      ),
      CircuitsPage().build(context),
      MainPage(
        state: state,
      ),
      Container(),
      Container(),
    ]);
    setState(() {
      ready = true;
    });
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
            body: (_currentIndex == 2)
                ? _children[_currentIndex]
                : Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: _children[_currentIndex],
                  ),
            bottomNavigationBar: BottomNavigationBar(
              selectedIconTheme: IconThemeData(
                color: Colors.black12,
              ),
              selectedItemColor: Colors.brown,
              unselectedItemColor: Colors.black12,
              unselectedLabelStyle: TextStyle(
                color: Colors.black12,
                fontSize: 12,
              ),
              selectedLabelStyle: TextStyle(
                color: Colors.brown,
                fontSize: 10,
              ),
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.near_me),
                  activeIcon: Icon(
                    Icons.near_me,
                    color: Colors.brown,
                  ),
                  title: new Text(state.languageMap['proximity']),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.map),
                  activeIcon: Icon(
                    Icons.map,
                    color: Colors.brown,
                  ),
                  title: new Text(state.languageMap['circuit']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.brown,
                  ),
                  title: Text(state.languageMap['home']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_agenda),
                  activeIcon: Icon(
                    Icons.view_agenda,
                    color: Colors.brown,
                  ),
                  title: Text(state.languageMap['agenda']),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  activeIcon: Icon(
                    Icons.settings,
                    color: Colors.brown,
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
