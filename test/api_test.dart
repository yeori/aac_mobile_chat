import 'package:aac_mobile_app/api/api.dart' as api;

void main() async {
  var res = await api.parseSentence('오늘 학교에서 축구를 했다.');
  print(res.toString());
}
