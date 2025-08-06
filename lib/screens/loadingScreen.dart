import 'package:flutter/material.dart';
import 'listScreen.dart'; // ListScreen을 임포트

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ListScreen()), // 수정된 부분
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEFD),
      body: Center(
        child: Container(
          width: 402,
          height: 874,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFFFFEFD),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x3F000000),
                blurRadius: 4,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // 텍스트: 제목
              const Positioned(
                left: 130,
                top: 230,
                child: SizedBox(
                  width: 155,
                  height: 70,
                  child: Text(
                    '매일쓰기',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontFamily: 'Cafe24 Oneprettynight',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                      letterSpacing: 9,
                    ),
                  ),
                ),
              ),

              // 텍스트: 부제목
              const Positioned(
                left: 120,
                top: 280,
                child: SizedBox(
                  width: 161,
                  height: 44,
                  child: Text(
                    '글쓰기를 위한 맞춤형 앱',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Cafe24 Oneprettynight',
                      fontWeight: FontWeight.w400,
                      height: 3.33,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              // 수평 선 1~4
              Positioned(
                left: 105,
                top: 230,
                child: Container(
                  width: 191,
                  height: 1,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 105,
                top: 236,
                child: Container(
                  width: 191,
                  height: 1,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 105,
                top: 273,
                child: Container(
                  width: 191,
                  height: 1,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 105,
                top: 279,
                child: Container(
                  width: 191,
                  height: 1,
                  color: const Color(0xFFE91F1F),
                ),
              ),

              // 수직 선 5~9
              Positioned(
                left: 135,
                top: 236,
                child: Container(
                  width: 1,
                  height: 37,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 168,
                top: 236,
                child: Container(
                  width: 1,
                  height: 37,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 201,
                top: 236,
                child: Container(
                  width: 1,
                  height: 37,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 234,
                top: 236,
                child: Container(
                  width: 1,
                  height: 37,
                  color: const Color(0xFFE91F1F),
                ),
              ),
              Positioned(
                left: 267,
                top: 236,
                child: Container(
                  width: 1,
                  height: 37,
                  color: const Color(0xFFE91F1F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
