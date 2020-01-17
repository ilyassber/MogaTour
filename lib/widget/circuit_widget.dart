import 'dart:io';

import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/widget/m_elem.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:flutter/material.dart';

class CircuitWidget {
  CircuitWidget({
    @required this.settingsState,
    @required this.circuit,
    @required this.f,
  });

  final SettingsState settingsState;
  final Circuit circuit;
  final Function f;
  List<Widget> sitesList = [];

  void initState() {
    if (circuit != null && circuit.sites != null) {
      for (int i = 0; i < circuit.sites.length; i++) {
        sitesList.add(new MedElem(
                id: circuit.sites[i].siteId,
                selected: 1,
                title: circuit.sites[i].siteTitle,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: (circuit.sites[i].images[0].localPath == null)
                      ? AssetImage(
                          'assets/images/circuit_categories/artisanal.jpg')
                      : FileImage(
                          new File(circuit.sites[i].images[0].localPath),
                        ),
                ),
                onClick: null,
                height: 100,
                width: 130,
                fontSize: 12)
            .build());
      }
    }
  }

  Widget build() {
    initState();
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 30,
                      child: Text(
                        '${circuit.circuitName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  shadowColor: Color(0xffffffff).withOpacity(0.5),
                  color: Color(0xffffffff).withOpacity(0.7),
                  child: InkWell(
                    onTap: f,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/icons/play_btn.png'),
                        ),
                      ),
                    ),
                  ),
                )
                /*Container(
                  width: 30,
                  height: 30,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage('assets/icons/play_btn.png'),
                    ),
                  ),
                )*/,
              ),
            ],
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                child: XList(
                  list: sitesList,
                  onClick: null,
                ).build(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
