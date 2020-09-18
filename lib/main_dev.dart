import 'package:aac_mobile_app/config/aac_config.dart';
import 'package:aac_mobile_app/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var contents = await rootBundle.loadString('assets/config/dev.json');
  var config = json.decode(contents);
  print(config.toString());
  var aacConfig = AacConfig.getInstance(
    host: config['aacHost'],
    symbolPrefix: config['symbolPrefix'],
  );
  aacConfig.tts.listLangs();
  aacConfig.tts.listVoices();
  aacConfig.tts.listEngens();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}
