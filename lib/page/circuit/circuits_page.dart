import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/page/circuit/circuit_page.dart';
import 'package:alpha_task/page/circuit/create_circuit.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/widget/circuit_widget.dart';
import 'package:alpha_task/widget/new_circuit.dart';
import 'package:alpha_task/widget/v_list.dart';
import 'package:flutter/material.dart';

class CircuitsPage {
  CircuitsPage(
      {@required this.context,
      @required this.settingsState,
      @required this.circuits});

  final BuildContext context;
  SettingsState settingsState;
  List<Circuit> circuits;
  List<Widget> circuitsList = [];

  // General Params

  TextEditingController textController = new TextEditingController();
  String newCircuit = "";

  void initList(List<Widget> categoryList) {
    for (int i = 0; i < circuits.length; i++) {
      categoryList.add(new CircuitWidget(
          settingsState: settingsState,
          circuit: circuits[i],
          f: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CircuitPage(
                            settingsState: settingsState,
                            circuit: circuits[i],
                          )),
                ),
              }).build());
    }
    categoryList.add(NewCircuit(
      context: context,
      settingsState: settingsState,
      title: 'Circuit Personnalise',
      option: 'Nouveau Circuit',
      function: circuitNameAlert,
    ).build());
  }

  void circuitNameAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Circuit name'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 60,
                  child: TextField(
                    controller: textController,
                    onChanged: (text) {
                      newCircuit = text;
                    },
                    maxLines: 1,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 210, 210, 210),
                      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    cursorColor: Color.fromARGB(255, 190, 190, 190),
                    cursorWidth: 2,
                    maxLength: 25,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                textController.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Enter',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                textController.clear();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCircuit(
                            settingsState: settingsState,
                            circuitName: newCircuit,
                          )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget build() {
    initList(circuitsList);
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0, bottom: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VList(
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
          ).build(),
        ],
      ),
    );
  }
}
