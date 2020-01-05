class Picture {
  int imgId;
  String imgTitle;
  String imgDescription;
  String imgPath;
  DateTime createdAt;
  DateTime updatedAt;

  Picture({
    this.imgId,
    this.imgTitle,
    this.imgDescription,
    this.imgPath,
    this.createdAt,
    this.updatedAt,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        imgId: json["img_id"],
        imgTitle: json["img_title"],
        imgDescription: json["img_description"],
        imgPath: json["img_path"].split('/')[4].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() {
    return {
      'img_id': imgId,
      'img_title': imgTitle,
      'img_description': imgDescription,
      'img_path': imgPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
