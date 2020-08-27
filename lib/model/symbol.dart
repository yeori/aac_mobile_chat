class Para {
  final List<Symbol> symbols;
  final String sentence;

  Para(this.sentence, this.symbols);

  @override
  String toString() {
    var buf = StringBuffer();
    buf.writeln('[$sentence]');
    symbols.forEach((elem) => buf.writeln('  ' + elem.toString()));
    return buf.toString();
  }
}

class Symbol {
  final Token token;
  Pic _pic;

  /// SIPDA (resources/images/go_sipda.png)
  ///
  final String symbolType;

  Symbol(this.token, this._pic, this.symbolType);

  get pic => _pic;
  set pic(pic) => _pic = pic;

  @override
  String toString() {
    return '${token.toString()}, ${_pic.toString()}, $symbolType';
  }

  factory Symbol.parse(Map<String, dynamic> map) {
    Token token = Token.parse(map['token']);
    Pic pic = Pic.parse(map['pic']);
    var symbolType = map['symbolType'];
    return Symbol(token, pic, symbolType);
  }
}

class Token {
  final String originWord;
  final String defaultWord;
  final String type;

  Token(this.originWord, this.defaultWord, this.type);
  factory Token.parse(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    var originWord = map['originWord'];
    var defWord = map['defaultWord'];
    var type = map['type'];
    return Token(originWord, defWord, type);
  }

  @override
  String toString() {
    return '($originWord, $defaultWord, $type)';
  }
}

class Pic {
  final String wordName;
  final String genName;
  final String origin;

  Pic(this.wordName, this.genName, this.origin);

  String get picturePath => '/$origin/$genName';

  static Pic parse(map) {
    var wname = map['wordName'];
    var genName = map['genName'];
    var origin = map['origin'];
    return Pic(wname, genName, origin);
  }

  @override
  String toString() {
    return '(origin: $origin, $genName, $wordName)';
  }
}
