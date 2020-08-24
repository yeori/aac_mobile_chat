import 'package:aac_mobile_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  get txtStyle => TextStyle(
        fontSize: 70.0,
        fontFamily: 'Fredoka One',
        shadows: [
          Shadow(
              blurRadius: 2.0,
              color: Colors.black54,
              offset: Offset.fromDirection(0.5, 10))
        ],
      );

  Future<bool> _fakeDelay() async {
    await Future.delayed(Duration(seconds: 3), () {});
    return true;
  }

  void _navToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => ChatPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fakeDelay().then((res) {
      _navToHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[50],
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg00.jpg',
              fit: BoxFit.fitHeight,
            ),
            Shimmer.fromColors(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'AAC Talk',
                        style: txtStyle,
                      ),
                      Text(
                        '(Kor)',
                        style: txtStyle,
                      ),
                    ],
                  ),
                ),
                baseColor: Colors.deepPurple[300],
                highlightColor: Colors.deepPurple)
          ],
        ),
      ),
    );
  }
}
