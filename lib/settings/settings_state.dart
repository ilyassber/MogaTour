import 'package:flutter/material.dart';
import 'dart:convert';

class SettingsState {
  SettingsState({this.language, this.languageMap});
  String language;
  Map<String, dynamic> languageMap;

  Map<String, String> toMap(SettingsState settingsState) {
    return {
      'language': language,
      'language-map': languageMap.toString(),
    };
  }

  SettingsState formMap(Map<String, dynamic> map) {
    return SettingsState(
      language: map['language'],
      languageMap: json.decode(map['language-map']),
    );
  }
}