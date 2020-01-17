import 'package:alpha_task/tools/TextTools.dart';
import 'package:flutter/material.dart';

class SmallElem {
  SmallElem(
      {@required this.context,
        @required this.id,
        @required this.checked,
        @required this.title,
        @required this.distance,
        @required this.image,
        @required this.onClick});

  final BuildContext context;
  final int id;
  final int checked;
  final String title;
  final int distance;
  final DecorationImage image;
  final void Function(int) onClick;

  TextTools textTools = new TextTools();

  Widget build(BuildContext context) {
    context = this.context;
    return GestureDetector(
      //onTap: onClick(id),
      child: Container(
        width: 90,
        height: 100,
        child: Stack(children: [
          Column(
            children: <Widget>[
              Container(
                width: 90,
                height: 70,
                decoration: new BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.7),
                    image: image,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                    )),
              ),
              Container(
                width: 90,
                height: 30,
                child: Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
//                      topLeft: const Radius.circular(5.0),
//                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    ),
                    gradient: new LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 255, 255, 1),
                          Color.fromRGBO(255, 255, 255, 1)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Container(
                    height: 30,
                    width: 90,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  textTools.resizeText(title, 18),
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${distance}m',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 90,
            height: 100,
            decoration: new BoxDecoration(
                color: (checked == 1)
                    ? Colors.black.withOpacity(0.5)
                    : Colors.black.withOpacity(0.0),
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(5.0),
                  topRight: const Radius.circular(5.0),
                  bottomLeft: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0),
                )),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                width: 40,
                decoration: new BoxDecoration(
                  image: (checked == 1)
                      ? DecorationImage(
                      image: AssetImage("assets/icons/checked.png"),
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown)
                      : null,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
