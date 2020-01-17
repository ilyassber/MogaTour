import 'package:alpha_task/widget/v_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Circuit extends StatefulWidget {
  final Map<String, String> languageMap;

  @override
  CircuitState createState() => CircuitState();
  Circuit({this.languageMap});
}

class CircuitState extends State<Circuit> {
  static Map<String, String> _languageMap;
  List<Widget> circuitsList = [];

  void init_list(BuildContext context, List<Widget> list) {

  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _languageMap = widget.languageMap;
    });
  }

//  String getAttr(String title) {
//    String result = colors_lib.n_a_lang;
//    if (_languageMap != null) {
//      if (_languageMap[title] != null) return _languageMap[title];
//    }
//    return result;
//  }

  @override
  Widget build(BuildContext context) {
    init_list(context, circuitsList);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
    ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
//      appBar: AppBar(
//        iconTheme: IconThemeData(color: Colors.black),
//        automaticallyImplyLeading: false,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: colors_lib.appbarIconColor,
//          ),
//          onPressed: () => Navigator.pop(context, false),
//        ),
//        centerTitle: true,
//        elevation: 0.0,
//        title: Text(
//          getAttr('myCircuitsPageTitle'),
//          style: colors_lib.appBarTextStyle,
//        ),
//        backgroundColor: colors_lib.appbarBGColor,
//        brightness: Brightness.light,
//      ),
//      endDrawer: Theme(
//        data: Theme.of(context).copyWith(
//          canvasColor: Colors.white,
//        ),
//        child: getDrawerNew(context, _languageMap),
//      ),
//      backgroundColor: colors_lib.generalBGColor,
      body: Center(
        child: Column(
          children: [
            VList(
              list: circuitsList,
              onClick: (index) => {},
            ).build(),
          ],
        ),
      ),
    );
  }
}
