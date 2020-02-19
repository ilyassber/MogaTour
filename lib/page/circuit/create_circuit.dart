import 'package:alpha_task/bloc/data_bloc.dart';
import 'package:alpha_task/bloc/data_event.dart';
import 'package:alpha_task/bloc/data_state.dart';
import 'package:alpha_task/database/db_manager.dart';
import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/page/circuit/circuit_page.dart';
import 'package:alpha_task/settings/settings_state.dart';
import 'package:alpha_task/tools/filter.dart';
import 'package:alpha_task/widget/circuit_site.dart';
import 'package:alpha_task/widget/elem_to_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCircuit extends StatefulWidget {
  CreateCircuit({@required this.settingsState, @required this.circuitName});

  final SettingsState settingsState;
  final String circuitName;

  @override
  CreateCircuitState createState() => CreateCircuitState();
}

class CreateCircuitState extends State<CreateCircuit> {
  SettingsState settingsState;
  int count = 0;
  String circuitName;
  TextEditingController textController = new TextEditingController();
  ElemToWidget elemToWidget;
  Filter filter;
  DbManager _dbManager = DbManager();
  double width;
  @override
  BuildContext context;

  DataBloc _dataBloc = DataBloc();
//  Widget siteListWidget;

  //Lists
//  List<Category> categoryList = [
//    Category(
//      image: "assets/images/circuit_categories/artisanal.jpg",
//      categoryId: 0,
//      categoryName: "Artisanal",
//    ),
//    Category(
//      image: "assets/images/circuit_categories/culturel.jpg",
//      categoryId: 0,
//      categoryName: "Culturel",
//    ),
//    Category(
//      image: "assets/images/circuit_categories/spirituel.jpg",
//      categoryId: 0,
//      categoryName: "Spirituel",
//    ),
//    Category(
//      image: "assets/images/circuit_categories/sport.jpg",
//      categoryId: 0,
//      categoryName: "Sport",
//    ),
//  ];
  List<Category> categoryList = [];
  List<Site> siteList = [];
  List<Site> visibleList = [];
  List<Site> circuitSites = [];
  List<Widget> circuitWidget = [];

  Widget getSiteById(Site site) {
    int i = 0;
    while (i < siteList.length) {
      if (site == siteList[i]) return circuitWidget[i];
      i++;
    }
    return (null);
  }

  void initCategories(int id, int access) {
    int i = 0;
    int index = -1;
    //siteList.forEach((x) => {x.linked = 0});
    if (categoryList.length > 0) {
      while (i < categoryList.length) {
        if (categoryList[i].categoryId == id) index = i;
        i++;
      }
      if (index != -1) categoryList[index].selected = access;
      visibleList.clear();
      for (int j = 0; j < categoryList.length; j++) {
        if (categoryList[j].selected == 1)
          visibleList.addAll(
              filter.filterByCategory(siteList, visibleList, categoryList[j]));
      }
      if (visibleList.length == 0) visibleList.addAll(siteList);
    } else
      visibleList.addAll(siteList);
    print(visibleList[0].images[0].toMap());
  }

  void categoryCallback(int id, int access) {
    setState(() {
      initCategories(id, access);
    });
  }

  void refresh(Site site, int i) {
    print("refresh Called !!");
    setState(() {
      if (site != null) {
        if (i == -1)
          siteList.remove(site);
        else if (i == 1)
          circuitSites.add(site);
        else if (i == 0) circuitSites.remove(site);
      }
      sitesVListWidget(context);
    });
  }

  void onCreateCircuit() async {
    List<Circuit> cir = await _dbManager.getAllCircuits();
    int id = 0;
    for (int i = 0; i < cir.length; i++) {
      if (cir[i].circuitId >= id) id = cir[i].circuitId;
    }
    id++;
    for (int i = 0; i < circuitSites.length; i++) {
      circuitSites[i].selected = 1;
    }
    Circuit circuit = new Circuit(
      circuitId: id,
      circuitName: circuitName,
      sites: circuitSites,
      createdAt: new DateTime.now(),
      updatedAt: new DateTime.now(),
    );
    await _dbManager.insertCircuit(circuit);
    cir = await _dbManager.getAllCircuits();
    print("Cir length : ${cir.length}");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CircuitPage(
              settingsState: settingsState,
              circuit: circuit,
            )));
  }

  void searchUpdate(String input) {
    setState(() {
      visibleList.clear();
      if (input != "")
        visibleList.addAll(filter.filterByCharacters(siteList, input));
      else
        categoryCallback(-1, 0);
    });
  }

  void sitesVListWidget(BuildContext context) {
    int i = 0;
    circuitWidget.clear();
    while (i < visibleList.length) {
      circuitWidget.add(new CircuitSite(
        context: context,
        site: visibleList[i],
        id: i,
        sites: visibleList,
        circuitSites: circuitSites,
        function: refresh,
        width: width,
      ).build());
      i++;
    }
  }

  void initData() async {
//    List<Site> sites = await _dbManager.getAllSites();
//    print("sites to delete len : ${sites.length}");
//    for (int i = 0; i < sites.length; i++) {
//      _dbManager.deleteSite(sites[i]);
//    }
//    sites.clear();
//    sites = await _dbManager.getAllSites();
//    print("sites 2 to delete len : ${sites.length}");
    _dataBloc.add(DataEvent.loadData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    circuitName = widget.circuitName;
    settingsState = widget.settingsState;
    elemToWidget = new ElemToWidget(function: refresh);
    filter = new Filter();
    //   initData();
    _dataBloc.add(DataEvent.loadData);
    elemToWidget = new ElemToWidget(function: refresh);
  }

  Widget buildBody(BuildContext context) {
    return BlocBuilder(
      bloc: _dataBloc,
      builder: (BuildContext context, DataState state) {
        if (state is InitialDataState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AfterLoading) {
          siteList.clear();
          categoryList.clear();
          print("sites len = ${state.sites.length}");
          print("props len = ${state.props.length}");
          siteList.addAll(state.sites);
          categoryList.addAll(state.categories);
          initCategories(-1, 1);
          print("siteList len = ${siteList.length}");
          print("visibleList len = ${visibleList.length}");
          //sitesVListWidget(context);
          _dataBloc.add(DataEvent.envInitiated);
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DataLoaded) {
          sitesVListWidget(context);
          return Container(
            child: new Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            child: Text(
                              '$circuitName - (${circuitSites.length})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            onCreateCircuit();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 80,
                              height: 25,
                              decoration: new BoxDecoration(
                                color: Color.fromARGB(255, 111, 139, 255),
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(12.0),
                                  topRight: const Radius.circular(12.0),
                                  bottomLeft: const Radius.circular(12.0),
                                  bottomRight: const Radius.circular(12.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Aperçu',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: AssetImage(
                                                  'assets/icons/view.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Container(
                    height: 30,
                    decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 245, 245, 245),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(12.0),
                        topRight: const Radius.circular(12.0),
                        bottomLeft: const Radius.circular(12.0),
                        bottomRight: const Radius.circular(12.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                            child: Icon(
                              Icons.search,
                              size: 26,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          width:
                              MediaQuery.of(context).size.width - 20 - 30 - 6,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              controller: textController,
                              onChanged: (text) {
                                searchUpdate(text);
                              },
                              maxLines: 1,
                              decoration: null,
                              cursorColor: Color.fromARGB(255, 210, 210, 210),
                              cursorWidth: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: elemToWidget.categoriesHListWidget(
                        context, categoryList, categoryCallback),
                  ),
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black12,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: circuitWidget.length,
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
//            Padding(
//              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//              child:
//            ),
              ],
            ),
          );
        } else
          return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final width = MediaQuery.of(context).size.width;
    this.width = width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Circuit',
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
//        appBar: AppBar(
//          iconTheme: IconThemeData(color: Colors.black),
//          automaticallyImplyLeading: false,
//          leading: IconButton(
//            icon: Icon(
//              Icons.arrow_back,
//              color: colors_lib.appbarIconColor,
//            ),
//            onPressed: () => Navigator.pop(context, false),
//          ),
//          centerTitle: true,
//          elevation: 0.0,
//          title: Text(
//            getAttr('aboutPageTitle'),
//            style: colors_lib.appBarTextStyle,
//          ),
//          backgroundColor: colors_lib.appbarBGColor,
//          brightness: Brightness.light,
//        ),
//        endDrawer: Theme(
//          data: Theme.of(context).copyWith(
//            canvasColor: Colors.white,
//          ),
//          child: getDrawerNew(context, _languageMap),
//        ),
//        backgroundColor: colors_lib.generalBGColor,
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: buildBody(context),
        ),
      ),
    );
  }
}
