import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Clock Challenge',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Flutter Clock Challenge'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int seconds;
  int min;
  int hr;
  String images;
  String image2s;
  String imagem;
  String image2m;
  String imageh;
  String image2h;
  String time_type;
  AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      hr = DateTime.now().hour;
      min = DateTime.now().minute;
      seconds = DateTime.now().second;
      if (hr < 12) {
        setState(() {
          time_type = "AM";
        });
      } else {
        setState(() {
          time_type = "PM";
        });
      }

      String data =
          await DefaultAssetBundle.of(context).loadString("assets/time.json");
      var time = json.decode(data);
      setState(() {
        images = time['seconds'][seconds]['one'];
        image2s = time['seconds'][seconds]['two'];

        imagem = time['mins'][min]['one'];
        image2m = time['mins'][min]['two'];

        imageh = time['hrs'][hr]['one'];
        image2h = time['hrs'][hr]['two'];
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.green,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.green,
        end: Colors.blue,
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.blue,
        end: Colors.pink,
      ),
    ),
  ]);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Scaffold(
            backgroundColor:
                background.evaluate(AlwaysStoppedAnimation(_controller.value)),
            appBar: AppBar(
              backgroundColor: background
                  .evaluate(AlwaysStoppedAnimation(_controller.value)),
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(
                        imageh,
                        width: 50,
                        height: 50,
                      ),
                      Image.asset(
                        image2h,
                        width: 50,
                        height: 50,
                      ),
                      Text(" : "),
                      Image.asset(
                        imagem,
                        width: 50,
                        height: 50,
                      ),
                      Image.asset(
                        image2m,
                        width: 50,
                        height: 50,
                      ),
                      Text(" : "),
                      Image.asset(
                        images,
                        width: 50,
                        height: 50,
                      ),
                      Image.asset(
                        image2s,
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      time_type,
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
