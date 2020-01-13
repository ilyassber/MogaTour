class Picture {
  int imgId;
  String imgTitle;
  String imgDescription;
  String imgPath;
  String localPath;
  DateTime createdAt;
  DateTime updatedAt;

  Picture({
    this.imgId,
    this.imgTitle,
    this.imgDescription,
    this.imgPath,
    this.localPath,
    this.createdAt,
    this.updatedAt,
  });

  static Picture fromMap(Map<String, dynamic> map) {
    return Picture(
      imgId: map["img_id"],
      imgTitle: map["img_title"],
      imgDescription: map["img_description"],
      imgPath: map["img_path"],//.split('/')[4].toString(),
      localPath: map["local_path"],
      createdAt: (map['created_at'] != null) ? DateTime.parse(map["created_at"]) : null,
      updatedAt: (map['updated_at'] != null) ? DateTime.parse(map["updated_at"]) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'img_id': imgId,
      'img_title': imgTitle,
      'img_description': imgDescription,
      'img_path': imgPath,
      'local_path': localPath,
      'created_at': (createdAt != null) ? createdAt.toIso8601String() : null,
      'updated_at': (updatedAt != null) ? updatedAt.toIso8601String() : null,
    };
  }
}
