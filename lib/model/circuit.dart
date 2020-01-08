import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/picture.dart';
import 'package:alpha_task/model/site.dart';
import 'package:alpha_task/tools/json_tools.dart';
import 'dart:convert';

class Circuit {
  JsonTools jsonTools = new JsonTools();

  int circuitId;
  int langId;
  String circuitName;
  String type;
  dynamic nbrClicks;
  DateTime createdAt;
  DateTime updatedAt;
  List<Picture> images;
  List<Category> categories;
  List<Site> sites;
  int key;
  Map<String, dynamic> map;

  Circuit(
      {this.circuitId,
      this.langId,
      this.circuitName,
      this.type,
      this.nbrClicks,
      this.createdAt,
      this.updatedAt,
      this.images,
      this.categories,
      this.sites,
      this.map});

  Map<String, dynamic> imagesToMap() {
    return Map.fromIterable(images, value: (e) => e.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'circuit_id': circuitId,
      'lang_id': langId,
      'circuit_name': circuitName,
      'type': type,
      'nbr_clicks': nbrClicks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'images': jsonTools.listToJson(images),
      'categories': jsonTools.listToJson(categories),
      'sites': sites.map((x) => x.toMap()).toList(),
    };
  }

  static Circuit fromMap(Map<String, dynamic> map) {
    print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
    List<Site> sites = [];
    try {
      print("**value** : ${map['sites'].length}");
      Iterable value = map['sites'];
      print("**value** : $value");
      //Iterable response = value;
      sites.addAll(value.map((x) => Site.fromMap(x)).toList());
      print(sites.length);
    } catch (e) {
      print("--ERROR : $e");
    }
    Circuit circuit = new Circuit(
        circuitId: map['circuit_id'],
        langId: map['lang_id'],
        circuitName: map['title'],
        type: map['type'],
        nbrClicks: map['nbr_clicks'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map["updated_at"]),
        images: (map['images'] != '[]')
            ? List<Picture>.from(map['images'].map((x) => Picture.fromJson(x)))
            : [],
        categories: (map['categories'] != '[]')
            ? List<Category>.from(
                map['categories'].map((x) => Category.fromMap(x)))
            : [],
        sites: (map['sites'] != '[]') ? sites : [],
        map: map);
    //print("<><><><><><><><><><>--${json.decode(map['sites'])}--<><><><><><><><><><>");
    return circuit;
  }

/* factory Circuit.fromJson(Map<String, dynamic> json) => Circuit(
        circuitId: json["circuit_id"],
        circuitName: json["circuit_name"],
        type: json["type"],
        nbrClicks: json["nbr_clicks"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        imgPath: json["img_path"].split('/')[4].toString(),
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        sites: List<Site>.from(json["sites"].map((x) => Site.fromJson(x))),
    );*/
}
