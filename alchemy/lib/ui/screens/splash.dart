import 'dart:async';
import 'dart:math';

import 'package:alchemy/ui/screens/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Image logo;
  Image loading;
  Image background;
  AssetImage bg1;
  AssetImage bg2;
  AssetImage bg3;
  AssetImage bg4;

  List currentBackground;
  bool bgColor = true;

  List backgrounds = [
    [
      AssetImage("assets/bg/b1_1.jpg"),
      AssetImage("assets/bg/b1_2.jpg"),
      AssetImage("assets/bg/b1_3.jpg"),
      AssetImage("assets/bg/b1_4.jpg"),
      "assets/bg/background1.jpg"
    ],
    [
      AssetImage("assets/bg/b3_1.jpg"),
      AssetImage("assets/bg/b3_2.jpg"),
      AssetImage("assets/bg/b3_3.jpg"),
      AssetImage("assets/bg/b3_4.jpg"),
      "assets/bg/background3.jpg"
    ],
    [
      AssetImage("assets/bg/b4_1.jpg"),
      AssetImage("assets/bg/b4_2.jpg"),
      AssetImage("assets/bg/b4_3.jpg"),
      AssetImage("assets/bg/b4_4.jpg"),
      "assets/bg/background4.jpg"
    ],
    [
      AssetImage("assets/bg/b5_1.jpg"),
      AssetImage("assets/bg/b5_2.jpg"),
      AssetImage("assets/bg/b5_3.jpg"),
      AssetImage("assets/bg/b5_4.jpg"),
      "assets/bg/background5.jpg"
    ],
    [
      AssetImage("assets/bg/b6_1.jpg"),
      AssetImage("assets/bg/b6_2.jpg"),
      AssetImage("assets/bg/b6_3.jpg"),
      AssetImage("assets/bg/b6_4.jpg"),
      "assets/bg/background6.jpg"
    ]
  ];

  void chooseBackground() {
    var chosen = new Random();
    int c = 1 + chosen.nextInt(5);
    setState(() {
      currentBackground = backgrounds[c - 1];
    });

    if (c == 2 || c == 4) {
      setState(() {
        bgColor = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    logo = Image.asset("assets/logo.png");
    loading = Image.asset("assets/loading.gif", scale: 10);

    chooseBackground();
    background = Image.asset(currentBackground[4], fit: BoxFit.fitHeight);
    bg1 = currentBackground[0];
    bg2 = currentBackground[1];
    bg3 = currentBackground[2];
    bg4 = currentBackground[3];

    Timer(
      Duration(seconds: 4),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen([bg1, bg2, bg3, bg4, background, bgColor]);
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
    precacheImage(loading.image, context);
    precacheImage(background.image, context);
    precacheImage(bg1, context);
    precacheImage(bg2, context);
    precacheImage(bg3, context);
    precacheImage(bg4, context);
  }

  @override
  Widget build(BuildContext context) {
    List frases = [
      "Brewing Potions",
      "\"Browse to your heart's content\"",
      "\"Can I help with some herbal needs?\"",
      "Looking for Toldfir's missing alembic",
      "\"I offer remedies for ailments both common and rare\"",
      "Alchenne is here for all your discreet needs...",
      "\"Need some sort of toxin for a special occasion?\"",
      "\"Alchemy is simple. Unless, of course, you are simple\""
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).textTheme.bodyText2.color,
                            width: 4,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 55,
                            child: logo,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        "Alchenne",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading,
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        frases[Random().nextInt(8)],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
