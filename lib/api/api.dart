import 'package:aac_mobile_app/config/aac_config.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:aac_mobile_app/model/symbol.dart';

final _config = AacConfig.getInstance();
// const _host = 'http://10.0.2.2:8080';
final _host = _config.aacHost;

Future<Para> parseSentence(String sentence) async {
  print('[before]');
  var res = await http.post(
    '$_host/reading/parse/talk',
    body: {'sentence': sentence},
  );
  print(res);
  var body = json.decode(res.body);
  // Map<String, dynamic> para = body['para'];
  List<dynamic> list = body['para']['symbols'];
  var symbols = list.map((item) => Symbol.parse(item)).toList();
  return Para(sentence, symbols);
}
