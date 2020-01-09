import 'package:alpha_task/tools/TextTools.dart';
import 'package:flutter/material.dart';

class MedElem {
  MedElem(
      {@required this.context,
      @required this.id,
      @required this.selected,
      @required this.title,
      @required this.image,
      @required this.onClick,
      @required this.height,
      @required this.width,
      @required this.fontSize});

  final BuildContext context;
  final int id;
  final int selected;
  final String title;
  final DecorationImage image;
  final void Function(int, int) onClick;
  final double height;
  final double width;
  final double fontSize;

  TextTools textTools = new TextTools();

  Widget build() {
    return InkWell(
      onTap: () {
        if (selected == 0) {
          onClick(id, 1);
        } else if (selected == 1) {
          onClick(id, 0);
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
          //image: image,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(5.0),
            topRight: const Radius.circular(5.0),
            bottomLeft: const Radius.circular(5.0),
            bottomRight: const Radius.circular(5.0),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              decoration: new BoxDecoration(
                image: image,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(5.0),
                  topRight: const Radius.circular(5.0),
                  bottomLeft: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: width,
                  height: height,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    ),
                    gradient: new LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.2),
                        Color.fromRGBO(0, 0, 0, 0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    textTools.resizeText(title, 18),
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: fontSize, fontFamily: 'Roboto'),
                  ),
                ),
              ),
            ),
            Container(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: width,
                  height: height,
                  decoration: new BoxDecoration(
                    color: (selected == 0)
                        ? Color.fromRGBO(255, 255, 255, 0.6)
                        : Color.fromRGBO(255, 255, 255, 0.0),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
