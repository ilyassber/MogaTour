import 'dart:convert';

import 'package:alpha_task/bloc/data_bloc.dart';
import 'package:alpha_task/bloc/data_event.dart';
import 'package:alpha_task/bloc/data_state.dart';
import 'package:alpha_task/page/home_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/tools/reader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  SplashPage();
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  // Constructors

  SettingsState settingsState;
  Reader reader;

  // Global Params

  bool ready = false;
  SharedPreferences prefs;
  int init = 0;
  String language;
  String jsonFile;
  Map<String, dynamic> map;

  // Bloc

  DataBloc _dataBloc = DataBloc();

  void initEnv() async {
    prefs = await SharedPreferences.getInstance();
    reader = new Reader();
    _dataBloc.add(DataEvent.loadData);
    init = prefs.getInt('init') ?? 0;
    if (init == 0) {
      prefs.setString('language', 'eng');
      prefs.setInt('init', 1);
      language = 'eng';
    } else {
      language = prefs.getString('language');
    }
    jsonFile = await reader.getFileData('assets/strings/eng');
    prefs.setString('eng', jsonFile);
    print(jsonFile);
    map = json.decode(jsonFile);
    settingsState = new SettingsState(
      language: 'eng',
      languageMap: map,
    );
    setState(() {
      ready = true;
    });
  }

  Widget bodyBuilder() {
    return BlocBuilder(
      bloc: _dataBloc,
      builder: (BuildContext context, DataState state) {
        if (state is InitialDataState) {
          return Container(
            color: Colors.black,
          );
        } else if (state is AfterLoading) {
          return SplashScreen(
            seconds: 0,
            navigateAfterSeconds:
            (!ready) ? Center(child: CircularProgressIndicator()) : HomePage(),
            backgroundColor: Colors.black,
          );
        } else
          return Container(
            color: Colors.deepOrange,
          );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initEnv();
  }

  @override
  Widget build(BuildContext context) {
    return bodyBuilder();
  }
}
