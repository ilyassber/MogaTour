import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/widget/m_elem.dart';
import 'package:alpha_task/widget/x_list.dart';
import 'package:flutter/material.dart';

class CircuitsCategory extends StatefulWidget {
  CircuitsCategory({
    @required this.context,
    @required this.category,
  });

  final BuildContext context;
  final Category category;

  @override
  CircuitsCategoryState createState() => CircuitsCategoryState();
}

class CircuitsCategoryState extends State<CircuitsCategory> {
  @override
  BuildContext context;
  Category category;
  List<Widget> circuitList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    category = widget.category;
    context = widget.context;
    circuitList.addAll([
      new MedElem(
          context: context,
          id: 0,
          selected: 0,
          title: 'Artisanal',
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/circuit_categories/artisanal.jpg'),
          ),
          onClick: null,
          height: 100,
          width: 130,
          fontSize: 14),
      new MedElem(
          context: context,
          id: 0,
          selected: 0,
          title: 'Culturel',
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/circuit_categories/culturel.jpg'),
          ),
          onClick: null,
          height: 100,
          width: 130,
          fontSize: 14),
      new MedElem(
          context: context,
          id: 0,
          selected: 0,
          title: 'Sport',
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/circuit_categories/sport.jpg'),
          ),
          onClick: null,
          height: 100,
          width: 130,
          fontSize: 14),
    ]);
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
                        '${category.categoryName}',
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
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage('assets/icons/play_btn.png'),
                    ),
                  ),
                ),
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
                  context: context,
                  list: circuitList,
                  onClick: null,
                ).build(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
