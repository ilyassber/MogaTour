import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/page/circuit/circuit_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/widget/circuit_widget.dart';
import 'package:alpha_task/widget/new_circuit.dart';
import 'package:alpha_task/widget/v_list.dart';
import 'package:flutter/material.dart';

class CircuitsPage {
  CircuitsPage({@required this.settingsState, @required this.circuits});

  SettingsState settingsState;
  List<Circuit> circuits;
  List<Widget> circuitsList = [];

  void initList(BuildContext context, List<Widget> categoryList) {
    for (int i = 0; i < circuits.length; i++) {
      categoryList.add(new CircuitWidget(
        context: context,
        settingsState: settingsState,
        circuit: circuits[i],
      ).build(context));
    }
    categoryList.add(NewCircuit(
      context: context,
      settingsState: settingsState,
      title: 'Circuit Personnalise',
      option: 'Nouveau Circuit',
    ).build(context));
  }

//  String getAttr(String title) {
//    //print("----------getAttr: in: " + title.toString());
//    String result = colorsUI_lib.n_a_lang;
//    if (languageMap != null) {
//      if (languageMap[title] != null) return languageMap[title];
//    }
//
//    // print("----------getAttr: out: " + result);
//    return result;
//  }

  Widget build(BuildContext context) {
    initList(context, circuitsList);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      statusBarColor: Colors.white,
//    ));
    return Container(
      margin: EdgeInsets.only(top: 0.0, left: 10.0, right: 0.0, bottom: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VList(
            context: context,
            list: circuitsList,
            onClick: (index) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CircuitPage(
                          settingsState: settingsState,
                          circuit: circuits[index],
                        )),
              ),
            },
          ),
        ],
      ),
    );
  }
}
