import 'package:alchemy/core/view_models/home_view_model.dart';
import 'package:alchemy/information/all_info_json.dart';
import 'package:alchemy/ui/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
          builder: (context) => HomeViewModel(),
        ),
        ChangeNotifierProvider<AllInfo>(
          builder: (context) => AllInfo(),
        ),
      ],
      child: MaterialApp(
        title: 'Alchemy Lab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF262b2f),
          canvasColor: Color(0xFF262b2f),
          iconTheme: IconThemeData(color: Color(0xFFfddfc0)),
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Color(0xFFfddfc0),
              fontSize: 20,
            ),
            headline6: TextStyle(color: Color(0xFFfddfc0)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.grey[700]),
          ),
          cursorColor: Color(0xFFfddfc0),
          accentColor: Color(0xFF262b2f),
          tooltipTheme: TooltipThemeData(
            textStyle: TextStyle(
              color: Color(0xFFfddfc0),
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
