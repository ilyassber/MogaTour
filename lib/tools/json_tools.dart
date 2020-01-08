import 'dart:convert';

class JsonTools {

  dynamic listToJson(List<dynamic> list) {
    String str = "[";
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        str += list[i].toMap().toString();
        if ((i + 1) < list.length) str += ",";
      }
    }
    str += "]";
    return str;
  }
}