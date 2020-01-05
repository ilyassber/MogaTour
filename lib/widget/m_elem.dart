import 'package:flutter/material.dart';

class MedElem extends StatefulWidget {
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

  @override
  MedElemState createState() => MedElemState();
}

class MedElemState extends State<MedElem> {
  @override
  BuildContext context;
  int id;
  int selected;
  double height;
  double width;
  double fontSize;
  String title;
  DecorationImage image;
  void Function(int, int) onClick;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context = widget.context;
    id = widget.id;
    selected = widget.selected;
    height = widget.height;
    width = widget.width;
    fontSize = widget.fontSize;
    title = widget.title;
    image = widget.image;
    onClick = widget.onClick;
  }

  @override
  Widget build(BuildContext context) {
    context = this.context;
    return InkWell(
      onTap: () {
        setState(() {
          if (selected == 0) {
            selected = 1;
            onClick(id, 1);
          } else if (selected == 1) {
            selected = 0;
            onClick(id, 0);
          }
        });
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
                    title,
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
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
