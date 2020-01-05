import 'dart:async';
import 'dart:convert';
import 'package:alpha_task/model/xstep.dart';
import 'package:http/http.dart' as http;

class NetworkTools {
  static final BASE_URL =
      "https://maps.googleapis.com/maps/api/directions/json?";

  static NetworkTools _instance = new NetworkTools.internal();

  NetworkTools.internal();

  factory NetworkTools() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(BASE_URL + url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      List<XStep> steps;
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);
      } catch (e) {
        throw new Exception(res);
      }

      return steps;
    });
  }

  List<XStep> parseSteps(final responseBody) {
    var list =
    responseBody.map<XStep>((json) => new XStep.fromJson(json)).toList();

    return list;
  }
}