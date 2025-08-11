import 'package:flutter/material.dart';
import '../global.dart' as globals;
import 'randomNovelSaveScreen.dart';

class WritingScreen extends StatefulWidget {
  final int? editIndex;
  final String initialTitle;
  final String initialContent;
  final String? subject;
  final bool isRandom;

  const WritingScreen({
    super.key,
    this.editIndex,
    this.initialTitle = '',
    this.initialContent = '',
    this.isRandom = false,
    this.subject,
  });

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _errorMessage;
  late String? _subject;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    _subject = widget.subject ?? (widget.isRandom ? globals.selectedRandomTopic : null);
  }

void _saveWriting() {
  final title = _titleController.text.trim();
  final content = _contentController.text.trim();
  final subjectInfo = globals.selectedRandomTopic;

  if (content.isEmpty) {
    setState(() {
      _errorMessage = '글의 내용이 없습니다.';
    });
    return;
  }

  if (widget.isRandom) {
    // 랜덤 저장소
    if (widget.editIndex != null) {
      globals.randomSavedWritings[widget.editIndex!] = {
        'title': title,
        'content': content,
        'subject': subjectInfo,
      };
    } else {
      globals.randomSavedWritings.add({
        'title': title,
        'content': content,
        'subject': subjectInfo,
      });
    }
  } else {
    // 일반 저장소 — Map 구조라서 이렇게
    globals.savedWritings.putIfAbsent('default', () => []);
    if (widget.editIndex != null) {
      globals.savedWritings['default']![widget.editIndex!] = {
        'title': title,
        'content': content,
        'subject': subjectInfo ?? '',
      };
    } else {
      globals.savedWritings['default']!.add({
        'title': title,
        'content': content,
        'subject': subjectInfo ?? '',
      });
    }
  }

  Navigator.pop(context, true);
}

  void _closeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RandomNovelSaveScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 402,
        height: 874,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFFFFFFE)),
        child: Stack(
          children: [
            // 제목 입력
            Positioned(
              left: 149,
              top: 95,
              child: SizedBox(
                width: 106,
                height: 71,
                child: TextField(
                  controller: _titleController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '제목',
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // 마지막 수정 시간
            const Positioned(
              left: 16,
              top: 135,
              child: SizedBox(
                width: 236,
                height: 25,
                child: Text(
                  '마지막 수정 시간: 2025/ 7/ 25',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            // 본문 입력
            Positioned(
              left: 16,
              top: 171,
              child: Container(
                width: 371,
                height: 667,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFA19793),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '내용을 입력하세요...',
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Cafe24 Oneprettynight',
                        fontWeight: FontWeight.w400,
                        height: 1.38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 닫기 버튼
            Positioned(
              left: 18,
              top: 61,
              child: GestureDetector(
                onTap: _closeScreen,
                child: const Text(
                  '닫기',
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
            // 저장 버튼
            Positioned(
              left: 350,
              top: 61,
              child: GestureDetector(
                onTap: _saveWriting,
                child: const Text(
                  '저장',
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
            // 주제 보기 버튼 (랜덤 모드일 때만 표시)
            if (widget.isRandom && _subject != null)
  Positioned(
    left: 160,
    top: 61,
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('선택된 주제'),
            content: Text(
              _subject!,
              style: const TextStyle(
                fontFamily: 'Cafe24 Oneprettynight',
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      },
      child: const Text(
        '주제 보기',
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
            // 에러 메시지
            if (_errorMessage != null)
              Positioned(
                left: 16,
                top: 150,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Cafe24 Oneprettynight',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}