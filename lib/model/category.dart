import 'dart:convert';

class Category {
  int key;
  int selected = 0;
  int categoryId;
  String categoryName;
  String image;
  dynamic nbrClicks;
  DateTime createdAt;
  DateTime updatedAt;
  //String title;

  Category({
    this.categoryId,
    this.categoryName,
    this.nbrClicks,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'nbr_clicks': nbrClicks,
      'created_at': createdAt,
      'updated': updatedAt,
      'image': image,
    };
  }

  static Category fromMap(Map<String, dynamic> json) {
    return Category(
      categoryId: json["category_id"],
      categoryName: json["title"],
      nbrClicks: (json["nbr_clicks"] != null) ? json["nbr_clicks"] : 0,
      createdAt: (json["created_at"] != null) ? DateTime.parse(json["created_at"]) : null,
      updatedAt: (json["updated_at"] != null) ? DateTime.parse(json["updated_at"]) : null,
      image: json["image"],
    );
  }
}