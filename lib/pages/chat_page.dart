import 'package:flutter/material.dart';
import 'package:aac_mobile_app/components/SymbolUI.dart';
import 'package:aac_mobile_app/api/api.dart' as api;

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Future<Para> para;
  List<SymbolUI> symbols = [];
  var inputControll = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  _onEnter(String sentence) async {
    var para = await api.parseSentence(sentence);
    setState(() {
      symbols = para.symbols.map((data) => SymbolUI(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('이야기'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          color: Colors.amber[50],
          child: Column(children: [
            TextField(
              controller: inputControll,
              onSubmitted: _onEnter,
              autofocus: false,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                onPressed: () => inputControll.clear(),
                icon: Icon(Icons.clear),
              )),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.0),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 4.0,
                  spacing: 4.0,
                  children: symbols),
            )
          ]),
        ));
  }
}
