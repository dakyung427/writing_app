import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../global.dart' as globals;
import 'randomWritingScreen.dart';

class RandomTopicScreen extends StatefulWidget {
  const RandomTopicScreen({super.key});

  @override
  State<RandomTopicScreen> createState() => _RandomTopicScreenState();
}

class _RandomTopicScreenState extends State<RandomTopicScreen> {
  late Map<String, dynamic> topicData;
  String baseType = "";
  String purpose = "";
  String where = "";
  String charClass = "";

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  Future<void> loadTopics() async {
    String jsonString = await rootBundle.loadString('assets/random.json');
    topicData = json.decode(jsonString);
    generateRandomTopic();
  }

  void generateRandomTopic() {
    // 판타지 / 현실 랜덤 선택
    bool isFantasy = random.nextBool();
    final data = isFantasy ? topicData["fantasy"] : topicData["real"];

    baseType = isFantasy ? "판타지" : "현실";
    purpose = data["purpose"][random.nextInt(data["purpose"].length)];
    where = data["where"][random.nextInt(data["where"].length)];
    charClass = data["class"][random.nextInt(data["class"].length)];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String topicText = '<$baseType 기반>\n$purpose 위해\n$where 에서 온 $charClass';

    return Scaffold(
      body: Container(
        width: 402,
        height: 874,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            const Positioned(
              left: 139,
              top: 95,
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
            Positioned(
              left: 42,
              top: 135,
              child: Container(
                width: 318,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFA29794)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      topicText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Cafe24 Oneprettynight',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 다시 버튼
            Positioned(
              left: 90,
              top: 340,
              child: GestureDetector(
                onTap: generateRandomTopic,
                child: const Text(
                  '다시?',
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
            // 결정 버튼
            Positioned(
              left: 260,
              top: 340,
              child: GestureDetector(
onTap: () async {
  globals.selectedRandomTopic = topicText;
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => WritingScreen(isRandom: true)),
  );
  if (result == true) {
    Navigator.pop(context, true);
  }
},
                child: const Text(
                  '결정!',
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
            // 뒤로 버튼
            Positioned(
              left: 18,
              top: 61,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '뒤로',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA0A0A0),
                    fontSize: 20,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
