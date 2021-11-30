import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radar_covid/provider/User.dart';
import 'package:radar_covid/screen/HomeScreen.dart';
import 'package:radar_covid/screen/InfoScreen.dart';
import 'package:radar_covid/utils/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Users(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        routes: {
          AppRoutes.HOME: (ctx) => HomeScreem(),
          AppRoutes.INFO: (ctx) => InfoScreen(),
        },
      ),
    );
  }
}
