import 'package:aac_mobile_app/model/symbol.dart';
import 'package:aac_mobile_app/ui/Decorations.dart';
import 'package:flutter/material.dart';
import 'package:aac_mobile_app/components/SymbolUI.dart';
import 'package:aac_mobile_app/api/api.dart' as api;
import 'dart:math';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

_uniqueKey() {
  var rand = new Random();
  return Key(rand.nextDouble().toString());
}

class _ChatPageState extends State<ChatPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// symbols for talking
  List<SymbolUI> symbols = [];
  int activeSymbolIndex = -1;

  double minRatio = 0.0;
  double maxRatio = 0.5;
  double initRatio = 0.0;

  /// symbols for preview
  var _previewScrollKey;
  List<SymbolUI> previewSymbols = [];

  // var _previewSymbolController;
  BuildContext _symbolScrollSheet;

  var inputControll = TextEditingController();
  @override
  void initState() {
    super.initState();
    _previewScrollKey = _uniqueKey();
  }

  _onEnter(String sentence) async {
    var res = await api.parseSentence(sentence);
    if (res['success']) {
      Para para = res['data'];
      setState(() {
        symbols = para.symbols.map((data) {
          var symbol = SymbolUI(
            symbol: data,
            tabCallback: _onSymbolTouch,
            tabmode: false,
          );
          return symbol;
        }).toList();
      });
    } else {
      _showAlert(_scaffoldKey.currentContext, res['cause']);
    }
  }

  _onSymbolTouch(Symbol symbol) async {
    print(symbol.toString());
    var index = symbols.indexWhere((symUI) => symUI.symbol == symbol);
    var symbolList = await api.symbol.search(symbol.token.defaultWord);
    setState(() {
      previewSymbols = symbolList.map((data) {
        return SymbolUI(
          symbol: data,
          tabCallback: _onPreviewSymbolTouch,
          renderDesc: false,
        );
      }).toList();
      _previewScrollKey = _uniqueKey();
      initRatio = 0.25;
      activeSymbolIndex = index;
      DraggableScrollableActuator.reset(_symbolScrollSheet);
    });
  }

  _showAlert(BuildContext ctx, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
              },
            ),
          ],
        );
      },
    );
  }

  _onPreviewSymbolTouch(Symbol sym) {
    print(sym.toString());
    // symbols.firstWhere((ui) => ui.symbol)
    var s = activeSymbolIndex;
    var e = s + 1;
    var currentUI = symbols[s];
    var symbolUI = currentUI.withPic(sym.pic, _onSymbolTouch);
    setState(() {
      symbols.replaceRange(s, e, [symbolUI]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print('W: $width');
    int cols = width ~/ 85;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('이야기'),
        ),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                color: Colors.amber[50],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 10.0, bottom: 300.0),
                          child: Wrap(
                              alignment: WrapAlignment.start,
                              runSpacing: 4.0,
                              spacing: 4.0,
                              children: symbols),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: DraggableScrollableActuator(
                  child: DraggableScrollableSheet(
                    key: _previewScrollKey,
                    expand: false,
                    initialChildSize: initRatio,
                    minChildSize: minRatio,
                    maxChildSize: maxRatio,
                    builder: (ctx, controller) {
                      _symbolScrollSheet = ctx;
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: Decorations.rounded(tl: 20.0, tr: 20.0),
                        child: GridView.builder(
                          itemCount: previewSymbols.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                          ),
                          controller: controller,
                          itemBuilder: (ctx, int index) {
                            return previewSymbols[index];
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
