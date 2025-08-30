import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/GoogleImageAPI.dart';
import '../global.dart' as globals;

class TranscribeDetailPage extends StatefulWidget {
  final String title;
  final String author;
  final String content;
  final String lastModified;
  final int? bookIndex;

  const TranscribeDetailPage({
    super.key,
    required this.title,
    required this.author,
    required this.content,
    required this.lastModified,
    this.bookIndex,
  });

  @override
  State<TranscribeDetailPage> createState() => _TranscribeDetailPageState();
}

class _TranscribeDetailPageState extends State<TranscribeDetailPage> {
  final TextEditingController _contentCtrl = TextEditingController();
  late String _lastModified;

  @override
  void initState() {
    super.initState();
    _contentCtrl.text = widget.content;
    _lastModified = widget.lastModified;
  }

  /// 📌 웹에서 파일 업로드 후 Vision API OCR
  Future<void> _pickImageAndExtractText() async {
    final api = GoogleImageAPI();

    // 파일 업로드 → 바이트 변환
    final Uint8List? bytes = await api.pickImageWeb();
    if (bytes == null) return;

    // Vision API OCR 요청
    final extracted = await api.extractTextFromBytes(bytes);

    if (extracted != null) {
      setState(() {
        _contentCtrl.text = extracted;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("텍스트 추출 실패")),
      );
    }
  }

void _save() {
  setState(() {
    _lastModified = DateFormat('yyyy / MM / dd').format(DateTime.now());
  });

  final bool validIndex = widget.bookIndex != null &&
      widget.bookIndex! >= 0 &&
      widget.bookIndex! < globals.transcribedBooks.length;

  if (validIndex) {
    final prev = globals.transcribedBooks[widget.bookIndex!];
    globals.transcribedBooks[widget.bookIndex!] = {
      "title": prev["title"] ?? widget.title,
      "author": prev["author"] ?? widget.author,
      "content": _contentCtrl.text,      // ✅ 본문 갱신
      "lastModified": _lastModified,     // ✅ 수정일 갱신
    };
  } else {
    globals.transcribedBooks.add({
      "title": widget.title,
      "author": widget.author,
      "content": _contentCtrl.text,
      "lastModified": _lastModified,
    });
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("저장되었습니다.")),
  );
}

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
            // 본문 박스
            Positioned(
              left: 16,
              top: 171,
              child: Container(
                width: 371,
                height: 667,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0xFFA19793),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _contentCtrl,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "추출된 텍스트가 여기에 표시됩니다.",
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.38,
                      fontFamily: 'Cafe24 Oneprettynight',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),

            // 뒤로
            Positioned(
              left: 18,
              top: 61,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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

            // 사진 업로드 버튼
            Positioned(
              left: 307,
              top: 60,
              child: IconButton(
                icon: const Icon(Icons.photo, color: Colors.black),
                onPressed: _pickImageAndExtractText,
              ),
            ),

            // 저장 버튼
            Positioned(
              left: 350,
              top: 61,
              child: GestureDetector(
                onTap: _save,
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

            // 제목
            Positioned(
              left: 149,
              top: 95,
              child: SizedBox(
                width: 106,
                height: 71,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // 마지막 수정 날짜
            Positioned(
              left: 16,
              top: 135,
              child: SizedBox(
                width: 300,
                height: 25,
                child: Text(
                  '마지막 수정 시간: $_lastModified',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
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

