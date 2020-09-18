import 'package:aac_mobile_app/tts/tts_handler.dart';
import 'package:flutter/cupertino.dart';

class AacConfig {
  final String aacHost;
  final symbolPrefix;
  final TtsHandler tts = TtsHandler();

  AacConfig({@required this.aacHost, @required this.symbolPrefix});

  static var _instance;

  static AacConfig getInstance({host, symbolPrefix}) {
    if (_instance == null) {
      _instance = AacConfig(aacHost: host, symbolPrefix: symbolPrefix);
    }
    return _instance;
  }
}
