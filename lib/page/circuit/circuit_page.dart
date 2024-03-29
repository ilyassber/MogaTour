import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/page/map/map_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/widget/elem_to_widget.dart';
import 'package:flutter/material.dart';

class CircuitPage extends StatefulWidget {
  CircuitPage({@required this.settingsState, @required this.circuit});

  final Circuit circuit;
  final SettingsState settingsState;

  @override
  CircuitPageState createState() => CircuitPageState();
}

class CircuitPageState extends State<CircuitPage> {
  ElemToWidget elemToWidget = new ElemToWidget();
  SettingsState settingsState;
  Circuit circuit;
  List<Site> circuitSites;
  List<Widget> circuitWidget = [];
  double height;
  double width;

  void refresh(Site site, int i) {
    setState(() {
      circuitWidget.clear();
      circuitWidget.addAll(elemToWidget.sitesVListWidget(
          context, circuitSites, null, refresh, width));
    });
  }

  void link_sites(List<Site> sites) {
    for (int i = 0; i < sites.length; i++) {
      sites[i].linked = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    settingsState = widget.settingsState;
    circuit = widget.circuit;
    circuitSites = circuit.sites;
    link_sites(circuitSites);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    circuitWidget.addAll(elemToWidget.sitesVListWidget(
        context, circuitSites, null, refresh, width));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
        //primarySwatch: MaterialColor(0, {0 : Colors.black54}),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Circuit - ${circuit.circuitName}',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
//          shape: Border(
//            bottom: BorderSide(
//              color: Colors.grey.withOpacity(0.3),
//              width: 1,
//            ),
//          ),
          elevation: 3,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 25,
              ),
            ),
          ),
        ),
        body: buildBody(context, height, width),
      ),
    );
  }

  Widget buildBody(BuildContext context, double height, double width) {
    return SafeArea(
      child: Container(
        height: height,
        width: width,
        child: Column(
          children: <Widget>[
            Container(
              height: 1,
              width: width,
              color: Colors.black12.withOpacity(0.1),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                height: 25,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Align(
                      //alignment: Alignment.bottomLeft,
                      child: Container(
                        child: Text(
                          '${circuit.circuitName}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapPage(
                                    circuit: circuit,
                                    buildType: 0,
                                  ))),
                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image: AssetImage('assets/icons/play_btn.png'),
                            ),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(12.5),
                              topRight: const Radius.circular(12.5),
                              bottomLeft: const Radius.circular(12.5),
                              bottomRight: const Radius.circular(12.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              width: width,
              color: Colors.black12.withOpacity(0.1),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: circuitSites.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(0),
                    child: SizedBox(
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: GestureDetector(
                          onTap: () {
                            print("list tap");
//                      refresh();
                          },
                          child: circuitWidget[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
