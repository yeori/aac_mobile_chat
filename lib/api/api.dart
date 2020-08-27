import 'package:aac_mobile_app/config/aac_config.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:aac_mobile_app/model/symbol.dart';

final _config = AacConfig.getInstance();
// const _host = 'http://10.0.2.2:8080';
final _host = _config.aacHost;

Future<Map<String, Object>> parseSentence(String sentence) async {
  print('[before]');
  var res = await http.post(
    '$_host/reading/parse/talk',
    body: {'sentence': sentence},
  );
  print(res);
  Map<String, dynamic> body = json.decode(res.body);
  // Map<String, dynamic> para = body['para'];
  if (body['success']) {
    List<dynamic> list = body['para']['symbols'];
    var symbols = list.map((item) => Symbol.parse(item)).toList();
    body['data'] = Para(sentence, symbols);
  } else {
    body['cause'] = res.statusCode;
  }

  return body;
}

final symbol = new SymbolAPI();

class SymbolAPI {
  Future<List<Symbol>> search(String keyword) async {
    var res = await http.get('$_host/talk/symbols?keyword=$keyword');
    var body = json.decode(res.body);
    List<dynamic> list = body['symbols'];
    List<Symbol> symbols = list.map((item) => _toSymbol(item)).toList();
    return symbols;
  }

  Symbol _toSymbol(Map<String, dynamic> map) {
    /*
    "wordSeq": 609,
    "wordName": "배",
    "picSeq": 970,
    "picName": "100862.png",
    "genName": "ed2edc00-dd07-4646-b37f-92980c047438.png",
    "fileLength": 0,
    "origin": "Ara",
    "orderNum": 0,
    "fingerprint": null
    */
    Pic pic = Pic.parse(map);
    Token token = Token(pic.wordName, pic.wordName, 'NORMAL');
    return Symbol(token, pic, 'NORMAL');
  }
}
