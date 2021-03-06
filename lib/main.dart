import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_kids/pages/home_page.dart';
import 'package:puzzle_kids/pages/level_page.dart';
import 'package:puzzle_kids/pages/second_page.dart';
import 'package:puzzle_kids/pages/up_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/second': (context) => const SecondPage(),
        '/level': (context) => const LevelPage(),
        '/upload': (context) => const TableroPage(),
      },
    );
  }
}

