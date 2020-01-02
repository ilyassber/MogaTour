import 'package:flutter/services.dart' show rootBundle;

class Reader {
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  String getAttr(Map<String, dynamic> map, String id) {
    return (map[id]);
  }
}