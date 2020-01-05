import 'package:alpha_task/page/circuit/create_circuit.dart';
import 'package:flutter/material.dart';

class NewCircuit extends StatefulWidget {
  NewCircuit(
      {@required this.context, @required this.title, @required this.option});

  final BuildContext context;
  final String title;
  final String option;

  @override
  _NewCircuitState createState() => _NewCircuitState();
}

class _NewCircuitState extends State<NewCircuit> {
  @override
  BuildContext context;
  String title;
  String option;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context = widget.context;
    title = widget.title;
    option = widget.option;
  }

  @override
  Widget build(BuildContext context) {
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
                        '$title',
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
            ],
          ),
        ),
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateCircuit()),
            ),
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 100,
                  width: 130,
                  decoration: new BoxDecoration(
                    color: Colors.black12,
//                  boxShadow: [
//                    new BoxShadow(
//                        color: Colors.black12,
//                        offset: new Offset(2.0, 2.0),
//                        blurRadius: 5.0,
//                        spreadRadius: 0.5)
//                  ],
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(
                                      'assets/icons/plus_yellow.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '$option',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
