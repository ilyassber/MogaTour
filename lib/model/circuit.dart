import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/picture.dart';
import 'package:alpha_task/model/site.dart';

class Circuit {
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

  Circuit({
    this.circuitId,
    this.langId,
    this.circuitName,
    this.type,
    this.nbrClicks,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.categories,
    this.sites,
  });

  Map<String, dynamic> toMap() {
    return {
      'circuit_id': circuitId,
      'lang_id': langId,
      'circuit_name': circuitName,
      'type': type,
      'nbr_clicks': nbrClicks,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': [(x) => images[x].toMap()],
      'categories': [
        (x) => categories[x].toMap(),
      ],
      'sites': [
        (x) => sites[x].toMap(),
      ],
    };
  }

  static Circuit fromMap(Map<String, dynamic> json) {
    return Circuit(
        circuitId: json['circuit_id'],
        langId: json['lang_id'],
        circuitName: json['title'],
        type: json['type'],
        nbrClicks: json['nbr_clicks'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json["updated_at"]),
        images:
            List<Picture>.from(json['images'].map((x) => Picture.fromJson(x))),
        categories: List<Category>.from(
            json['categories'].map((x) => Category.fromMap(x))),
        sites: List<Site>.from(json['sites'].map((x) => Site.fromMap(x))));
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
