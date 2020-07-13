import 'dart:async';
import 'dart:math';

import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/ui/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Image logo;
  Image loading;

  @override
  void initState() {
    super.initState();
    logo = Image.asset("assets/logo.png");
    loading = Image.asset("assets/loading.gif", scale: 10);
    Timer(
      Duration(seconds: 4),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
    precacheImage(loading.image, context);
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
