class Image {
  int imgId;
  String imgTitle;
  String imgDescription;
  String imgPath;
  DateTime createdAt;
  DateTime updatedAt;

  Image({
    this.imgId,
    this.imgTitle,
    this.imgDescription,
    this.imgPath,
    this.createdAt,
    this.updatedAt,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imgId: json["img_id"],
        imgTitle: json["img_title"],
        imgDescription: json["img_description"],
        imgPath: json["img_path"].split('/')[4].toString(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
