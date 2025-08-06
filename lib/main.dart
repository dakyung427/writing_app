import 'package:flutter/material.dart';
import 'screens/loadingScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Cafe24 Oneprettynight', // 전역 폰트
      ),
      home: const SplashScreen(),
    );
  }
}
