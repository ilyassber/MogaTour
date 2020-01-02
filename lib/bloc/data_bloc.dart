import 'dart:async';
import 'dart:convert';
import 'package:alpha_task/database/db_manager.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DbManager _dbManager = DbManager();

  @override
  DataState get initialState => InitialDataState();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    switch (event) {
      case DataEvent.loadData:
        yield InitialDataState();
        yield* _loadData();
        break;
      case DataEvent.envInitiated:
        yield* _initState();
        break;
    }
  }

  Stream<DataState> _loadData() async* {

//    var siteUrl = "http://165.227.192.11/api/1/sites/all";
//    var categoryUrl = "http://165.227.192.11/api/1/categories/sites";
//
//    List<Site> sites = await _dbManager.getAllSites();
//    List<Category> categories = await _dbManager.getAllCategories();
//
//    if (sites == null || sites.length == 0) {
//      var response = await http.get(siteUrl);
//      print("response code == ${response.statusCode}");
//      if (response.statusCode  == 200) {
//        Iterable jsonResponse = json.decode(response.body);
//        print('>>> success! >>> $jsonResponse');
//        try {
//          sites = jsonResponse.map((x) => Site.fromMap(x)).toList();
//          (x) => _dbManager.insertSite(sites[x]);
//        }
//        catch(e) {
//          print(e);
//        }
//      } else {
//        print('>>> fail?');
//      }
//    } else
//      print("Sites data is already there : length = ${sites.length}");
//
//    if (categories == null || categories.length == 0) {
//      var response = await http.get(categoryUrl);
//      print("response code == ${response.statusCode}");
//      if (response.statusCode  == 200) {
//        Iterable jsonResponse = json.decode(response.body);
//        print('>>> success! >>> $jsonResponse');
//        try {
//          categories = jsonResponse.map((x) => Category.fromMap(x)).toList();
//          (x) => _dbManager.insertCategory(categories[x]);
//          categories[0].selected = 1;
//        }
//        catch(e) {
//          print(e);
//        }
//      } else {
//        print('>>> fail?');
//      }
//    } else
//      print("Categories data is already there : length = ${categories.length}");

    yield AfterLoading();
  }

  Stream<DataState> _initState() async* {
    yield DataLoaded();
  }
}
