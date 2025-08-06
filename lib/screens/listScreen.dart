import 'package:flutter/material.dart';
import 'NovelSaveScreen.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 402,
        height: 874,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            const Positioned(
              left: 185,
              top: 95,
              child: Text(
                '메뉴',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Cafe24 Oneprettynight',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              left: 177,
              top: 261,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NovelSaveScreen(),
                    ),
                  );
                },
                child: const Text(
                  '글쓰기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 140,
              top: 343,
              child: Text(
                '랜덤 주제 글쓰기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Cafe24 Oneprettynight',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

