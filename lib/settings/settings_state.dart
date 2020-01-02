import 'package:flutter/material.dart';
import 'dart:convert';

class SettingsState {
  SettingsState({@required this.language, @required this.languageMap});
  final String language;
  final Map<String, dynamic> languageMap;

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