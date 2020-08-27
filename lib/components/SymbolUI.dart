import 'package:aac_mobile_app/config/aac_config.dart';
import 'package:aac_mobile_app/ui/Decorations.dart';
import 'package:flutter/material.dart';
import 'package:aac_mobile_app/model/symbol.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _config = AacConfig.getInstance();
final String symbolPrefix = _config.symbolPrefix;
const double _pic_size = 100;
const double _desc_height = 28;

class _CachedImg {
  Map<String, Image> map = {};

  loadImage(String url, Function fn) {
    Image image = map[url];
    if (image == null) {
      image = fn.call(url);
      map[url] = image;
    } else {
      print('[HIT] $url');
    }
    return image;
  }
}

var _cached = _CachedImg();

class SymbolUI extends StatelessWidget {
  final Symbol symbol;
  final tabCallback;
  SymbolUI({@required this.symbol, this.tabCallback});

  Widget _sipda(normalImage, auxImage) {
    return Stack(
      children: [
        Positioned(
          top: _pic_size * .07,
          right: _pic_size * .07,
          width: _pic_size * .5,
          height: _pic_size * .5,
          child: normalImage,
        ),
        auxImage
      ],
    );
  }

  Widget _maseyo(normalImage, auxImage) {
    return Stack(
      children: [
        Positioned(
          top: _pic_size * .07,
          right: _pic_size * .07,
          left: _pic_size * .07,
          bottom: _pic_size * .07,
          child: normalImage,
        ),
        auxImage
      ],
    );
  }

  Widget _renderPic(img) {
    var config = AacConfig.getInstance();
    var type = symbol.symbolType;
    Widget widget;
    if (type == 'NORMAL') {
      widget = Container(
        child: img,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (type == 'SIPDA') {
      var url = '${config.aacHost}/resources/images/go_sipda.png';
      var sipda = _cached.loadImage(url, (url) => Image.network(url));
      widget = _sipda(img, sipda);
    } else if (type == 'SILTA') {
      var url = '${config.aacHost}/resources/images/gi_silta.png';
      var silta = _cached.loadImage(url, (url) => Image.network(url));
      widget = _sipda(img, silta);
    } else if (type == 'MASEYO') {
      var url = '${config.aacHost}/resources/images/gi_maseyo.png';
      var maseyo = _cached.loadImage(url, (url) => Image.network(url));
      widget = _maseyo(img, maseyo);
    } else if (type == 'ANAYO') {
      var url = '${config.aacHost}/resources/images/gi_anayo.png';
      var anayo = _cached.loadImage(url, (url) => Image.network(url));
      widget = _maseyo(img, anayo);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    var url = '$symbolPrefix${symbol.pic.picturePath}';
    var img;
    if (url.toLowerCase().endsWith('svg')) {
      img = SvgPicture.network(url, fit: BoxFit.contain);
    } else {
      img = Image.network(url, fit: BoxFit.contain);
    }

    return InkWell(
      onTap: () {
        print('[SYMBOL] ${symbol.token.defaultWord}');
        if (tabCallback != null) {
          tabCallback(symbol);
        }
      },
      child: Container(
        height: _pic_size + _desc_height,
        decoration: Decorations.roundedBox(
            radius: 8.0, borderColor: Colors.transparent),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Expanded(
                child: _renderPic(img),
              ),
              Container(
                  height: _desc_height,
                  alignment: Alignment.center,
                  child: Text(symbol.token.originWord,
                      style: Theme.of(context).textTheme.headline5))
            ],
          ),
        ),
      ),
    );
  }

  SymbolUI withPic(Pic pic, callback) {
    symbol.pic = pic;
    return SymbolUI(
      symbol: symbol,
      tabCallback: callback,
    );
  }
}
