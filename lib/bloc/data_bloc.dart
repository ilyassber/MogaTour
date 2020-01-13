import 'dart:async';
import 'dart:convert';
import 'package:alpha_task/database/db_manager.dart';
import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/circuit.dart';
import 'package:alpha_task/model/site.dart';
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
    var siteUrl = "http://165.227.192.11/api/1/sites/all";
    var categoryUrl = "http://165.227.192.11/api/1/categories/sites";
    var circuitUrl = "http://165.227.192.11/api/1/circuits/all";

    await _dbManager.deleteAllCircuit();
    await _dbManager.deleteAllCategory();
    await _dbManager.deleteAllSite();

    List<Site> sites = await _dbManager.getAllSites();
    List<Category> categories = await _dbManager.getAllCategories();
    List<Circuit> circuits = await _dbManager.getAllCircuits();

    if (sites == null || sites.length == 0) {
      print(sites.length);
      var response = await http.get(siteUrl);
      print("response code == ${response.statusCode}");
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        print('>>> success! >>> ${response.body}');
        try {
          sites = jsonResponse.map((x) => Site.fromMap(x)).toList();
          for (int i = 0; i < sites.length; i++) {
            _dbManager.insertSite(sites[i]);
          }
        } catch (e) {
          print(e);
        }
      } else {
        print('>>> fail?');
      }
    } else
      print("Sites data is already there : length = ${sites.length}");

    if (categories == null || categories.length == 0) {
      print(categories.length);
      var response = await http.get(categoryUrl);
      print("response code == ${response.statusCode}");
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        print('>>> success! >>> $jsonResponse');
        try {
          categories = jsonResponse.map((x) => Category.fromMap(x)).toList();
          if (categories != null && categories.length > 0) {
            for (int i = 0; i < categories.length; i++) {
              _dbManager.insertCategory(categories[i]);
            }
            categories[0].selected = 1;
          }
        } catch (e) {
          print(e);
        }
      } else {
        print('>>> fail?');
      }
    } else
      print("Categories data is already there : length = ${categories.length}");

    if (circuits == null || circuits.length == 0) {
      var response = await http.get(circuitUrl);
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        try {
          circuits = jsonResponse.map((x) => Circuit.fromMap(x)).toList();
          for (int i = 0; i < circuits.length; i++) {
            _dbManager.insertCircuit(circuits[i]);
          }
        } catch (e) {
          print("ERROR : $e");
        }
      } else {
        print('>>> fail?');
      }
    } else
      print("Circuits data is already there : length = ${circuits.length}");

    yield AfterLoading(sites, categories, circuits);
  }

  Stream<DataState> _initState() async* {
    yield DataLoaded();
  }
}
