import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/page/circuit/circuit.dart';
import 'package:alpha_task/widget/circuit_category.dart';
import 'package:alpha_task/widget/new_circuit.dart';
import 'package:alpha_task/widget/v_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CircuitsPage {
  List<Widget> categoryList = [];
  Map<String, String> languageMap;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void init_list(BuildContext context, List<Widget> categoryList) {
    categoryList.clear();

    categoryList.addAll([
      new CircuitsCategory(
        context: context,
        category: new Category(
          categoryId: 1,
          categoryName: 'Art',
        ),
      ),
      new CircuitsCategory(
        context: context,
        category: new Category(
          categoryId: 1,
          categoryName: 'Sport',
        ),
      ),
      new CircuitsCategory(
        context: context,
        category: new Category(
          categoryId: 1,
          categoryName: 'Spirituel',
        ),
      ),
    ]);
    categoryList.add(NewCircuit(
      context: context,
      title: 'Circuit Personnalise',
      option: 'Nouveau Circuit',
    ));
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
    init_list(context, categoryList);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
//      statusBarColor: Colors.white,
//    ));
    return Container(
      margin: EdgeInsets.only(top: 80.0, left: 10.0, right: 10.0),
      child: Column(
        children: [
          VList(
            context: context,
            list: categoryList,
            onClick: (index) => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Circuit()),
              ),
            },
          ),
        ],
      ),
    );
  }
}
