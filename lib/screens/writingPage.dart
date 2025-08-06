import 'package:flutter/material.dart';
import '../global.dart' as globals;

class WritingScreen extends StatefulWidget {
  final int? editIndex;
  final String initialTitle;
  final String initialContent;

  const WritingScreen({
    super.key,
    this.editIndex,
    this.initialTitle = '',
    this.initialContent = '',
  });

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  void _saveWriting() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      setState(() {
        _errorMessage = '글의 내용이 없습니다.';
      });
      return;
    }

    if (widget.editIndex != null) {
      globals.savedWritings[widget.editIndex!] = {
        'title': title,
        'content': content,
      };
    } else {
      globals.savedWritings.add({
        'title': title,
        'content': content,
      });
    }

    Navigator.pop(context, true); // true 반환 → 목록 화면에서 새로고침
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
            Positioned(
              left: 18,
              top: 61,
              child: GestureDetector(
                onTap: () => Navigator.pop(context, false),
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





