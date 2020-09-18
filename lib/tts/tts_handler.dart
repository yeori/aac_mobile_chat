import 'package:flutter_tts/flutter_tts.dart';

class TtsHandler {
  FlutterTts _tts = FlutterTts();

  void speak(String text) async {
    await _tts.setSpeechRate(1.0);
    // await _tts.setLanguage('ko-KR');
    await _tts.setVoice('ko-kr-x-ism-local');
    // await _tts.setVoice('id-id-x-dfz#female_3-local');
    // ko-KR-language(google-female),
    // ko-kr-x-ism-local,
    // ko-kr-x-kob-local(google-female),
    // ko-kr-x-koc-local(google-male)
    // ko-kr-x-ism-network
    // _tts.set
    await _tts.speak(text);
  }

  void listLangs() async {
    var langs = await _tts.getLanguages;
    print('LANG: ' + langs.toString());
  }

  void listVoices() async {
    List<dynamic> voices = await _tts.getVoices;
    print('VOICE\n');
    voices.forEach((v) {
      print('  ' + v.toString());
    });
  }

  void listEngens() async {
    var engines = await _tts.getEngines;
    print('ENGINE: ' + engines.toString());
  }
}
