import 'dart:convert';
import 'dart:typed_data';
import 'package:alpha_task/model/category.dart';
import 'package:alpha_task/model/picture.dart';

class Site {
  Map<String, dynamic> map;
  int key;
  int siteId;
  int markerId;
  int linked = 0;
  int hidden = 0;
  int visited = 0;
  int selected = 0;
  String siteTitle;
  String siteSousTitle;
  String siteDescriptionShort;
  String siteDescriptionLong;
  int active;
  //String audioPath;
  DateTime createdAt;
  DateTime updatedAt;
  String phoneNumber;
  String gpsLocation;
  int gpsDiametre;
  int rating;
  int isTemporary;
  String numTel;
  String url;
  String openingTime;
  String closingTime;
  String duration;
  String email;
  String adresse;
  int prix = 0;
  int nbrClicks;
  int nbrVisitsGps;
  List<Picture> images;
  List<Category> categories;
  double lat;
  double lng;
  Uint8List bitFlag;
  //List<dynamic> videos;

  Site({
    this.map,
    this.siteId,
    this.markerId,
    this.linked,
    this.siteTitle,
    this.siteSousTitle,
    this.siteDescriptionShort,
    this.siteDescriptionLong,
    this.active,
    //this.audioPath,
    this.createdAt,
    this.updatedAt,
    this.phoneNumber,
    this.gpsLocation,
    this.gpsDiametre,
    this.rating,
    this.isTemporary,
    this.url,
    this.openingTime,
    this.closingTime,
    this.duration,
    this.email,
    this.adresse,
    this.prix,
    this.nbrClicks,
    this.nbrVisitsGps,
    this.images,
    this.categories,
    //this.videos,
  });

  Map<String, dynamic> toMap() {
    return {
      'site_id': siteId,
      'marker_id': markerId,
      'title': siteTitle,
      'site_sous_title': siteSousTitle,
      'description_200m': siteDescriptionShort,
      'description_400m': siteDescriptionLong,
      'active': active,
      //'audio_path': audioPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'num_tel': phoneNumber,
      'gps_location' : gpsLocation,
    };
    //return map;
  }

  static Site fromMap(Map<String, dynamic> map) {
    print("> enter to site <");
    return Site(
      map: map,
      siteId: map["site_id"],
      markerId: map['marker_id'],
      siteTitle: map["title"],
      siteSousTitle: map["site_sous_title"],
      siteDescriptionShort: map["description_200m"],
      siteDescriptionLong: map["description_400m"],
      active: map["active"],
      // audioPath: map["audio_path"].split('/')[4].toString(),
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
      phoneNumber: map["num_tel"],
      gpsLocation: map["gps_location"],
      gpsDiametre: map["gps_diametre"],
      rating: map["rating"],
      isTemporary: map["is_temporary"],
      url: map["url"],
      openingTime: map["temps_ouverture"],
      closingTime: map["temps_fermeture"],
//      duration: map["duration"],
      email: map["email"],
      adresse: map["adresse"],
      prix: map["prix"],
      nbrClicks: map["nbr_clicks"],
      nbrVisitsGps: map["nbr_visits_gps"],
      images: (map['images'] == '[]')
          ? List<Picture>.from(map["images"].map((x) => Picture.fromJson(x)))
          : [],
      categories: (map['categories'] == '[]')
          ? List<Category>.from(
              map["categories"].map((x) => Category.fromJson(x)))
          : [],
      // videos: List<dynamic>.from(json["videos"].map((x) => x)),
    );
  }

//  factory Site.fromJson(Map<String, dynamic> json) => Site(
//        siteId: json["site_id"],
//        siteTitle: json["title"],
//        siteSousTitle: json["site_sous_title"],
//        siteDescriptionShort: json["description_200m"],
//        siteDescriptionLong: json["description_400m"],
//        active: json["active"],
//        //audioPath: json["audio_path"].split('/')[4].toString(),
//        createdAt: DateTime.parse(json["created_at"]),
//        updatedAt: DateTime.parse(json["updated_at"]),
//        phoneNumber: json["num_tel"],
//        gpsLocation: json["gps_location"],
//        gpsDiametre: json["gps_diametre"],
//        rating: json["rating"],
//        isTemporary: json["is_temporary"],
//        url: json["url"],
//        openingTime: json["temps_ouverture"],
//        closingTime: json["temps_fermeture"],
//        duration: json["duration"],
//        email: json["email"],
//        adresse: json["adresse"],
//        prix: json["prix"],
//        nbrClicks: json["nbr_clicks"],
//        nbrVisitsGps: json["nbr_visits_gps"],
//        images:
//            List<Picture>.from(json["images"].map((x) => Picture.fromJson(x))),
//        categories: List<Category>.from(
//            json["categories"].map((x) => Category.fromJson(x))),
//        // videos: List<dynamic>.from(json["videos"].map((x) => x)),
//      );
//
//  static List<Site> siteFromJson(String str) =>
//      List<Site>.from(json.decode(str).map((x) => Site.fromJson(x)));
}
