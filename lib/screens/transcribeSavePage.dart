import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transcribeDetailPage.dart';
import '../global.dart' as globals;

class TranscribeSavePage extends StatefulWidget {
  final String extractedText;
  final int? bookIndex; // 수정: 기존 책을 열었을 때 인덱스

  const TranscribeSavePage({
    super.key,
    required this.extractedText,
    this.bookIndex,
  });

  @override
  State<TranscribeSavePage> createState() => _TranscribeSavePageState();
}

class _TranscribeSavePageState extends State<TranscribeSavePage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _authorCtrl = TextEditingController();

  bool _saved = false; // 저장 여부
  late String _lastModified;

  @override
  void initState() {
    super.initState();
    _lastModified = DateFormat('yyyy / MM / dd').format(DateTime.now());

    // 기존 책 열었을 경우 데이터 불러오기
    if (widget.bookIndex != null &&
        widget.bookIndex! < globals.transcribedBooks.length) {
      final book = globals.transcribedBooks[widget.bookIndex!];
      _titleCtrl.text = book['title'] ?? '';
      _authorCtrl.text = book['author'] ?? '';
      _lastModified = book['lastModified'] ?? _lastModified;
      _saved = true;
    }
  }

  /// 저장 함수
  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('책 제목을 입력해 주세요.')),
      );
      return;
    }
    if (_authorCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저자 이름을 입력해 주세요.')),
      );
      return;
    }

    setState(() {
      _saved = true;
      _lastModified = DateFormat('yyyy / MM / dd').format(DateTime.now());
    });

    final newBook = {
      "title": _titleCtrl.text.trim(),
      "author": _authorCtrl.text.trim(),
      "content": widget.extractedText, // ✅ OCR 본문 저장
      "lastModified": _lastModified,
    };

    if (widget.bookIndex != null &&
        widget.bookIndex! < globals.transcribedBooks.length) {
      globals.transcribedBooks[widget.bookIndex!] = newBook;
    } else {
      globals.transcribedBooks.add(newBook);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('저장되었습니다.')),
    );
  }

  /// DetailPage 열기
  void _openDetailPage() {
    int? index = widget.bookIndex;
    if (index == null || index >= globals.transcribedBooks.length) {
      // 새로 추가된 책이라면 마지막 index
      index = globals.transcribedBooks.isNotEmpty
          ? globals.transcribedBooks.length - 1
          : null;
    }

    String titleToShow = _titleCtrl.text.trim().isEmpty
        ? "제목 없음"
        : _titleCtrl.text.trim();
    String authorToShow = _authorCtrl.text.trim().isEmpty
        ? "저자 없음"
        : _authorCtrl.text.trim();
    String contentToShow = widget.extractedText;
    String lastModifiedToShow = _lastModified;

    // 저장된 책이 있으면 그 데이터로 갱신
    if (index != null && index < globals.transcribedBooks.length) {
      final book = globals.transcribedBooks[index];
      titleToShow = book['title'] ?? titleToShow;
      authorToShow = book['author'] ?? authorToShow;
      contentToShow = book['content'] ?? contentToShow;
      lastModifiedToShow = book['lastModified'] ?? lastModifiedToShow;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TranscribeDetailPage(
          title: titleToShow,
          author: authorToShow,
          content: contentToShow,
          lastModified: lastModifiedToShow,
          bookIndex: index,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_saved &&
        (_titleCtrl.text.trim().isNotEmpty ||
            _authorCtrl.text.trim().isNotEmpty)) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("저장하시겠습니까?"),
          content: const Text("변경된 제목/저자를 저장하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("아니요"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("예"),
            ),
          ],
        ),
      );

      if (shouldSave == true) {
        _save();
      }
    }
    return true; // 메인으로 나감
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          width: 402,
          height: 874,
          color: Colors.white,
          child: Stack(
            children: [
              // 뒤로
              Positioned(
                left: 18,
                top: 61,
                child: GestureDetector(
                  onTap: () async {
                    if (await _onWillPop()) {
                      Navigator.pop(context);
                    }
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

              // 상단 저장 버튼
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

              // 마지막 수정 날짜
              Positioned(
                left: 79,
                top: 142,
                child: Text(
                  '마지막 수정 날짜: $_lastModified',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Cafe24 Oneprettynight',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // 회색 네모(책 박스)
              Positioned(
                left: 53,
                top: 203,
                child: GestureDetector(
                  onTap: _openDetailPage,
                  child: Container(
                    width: 288,
                    height: 534,
                    decoration: const BoxDecoration(
                      color: Color(0xFFe5e5e5),
                    ),
                  ),
                ),
              ),

              // 제목 입력
              Positioned(
                left: 111,
                top: 287,
                child: Container(
                  width: 176,
                  height: 40,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _titleCtrl,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '책 제목',
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

              // 저자 입력
              Positioned(
                left: 120,
                top: 348,
                child: SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      const Text(
                        '저자: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Cafe24 Oneprettynight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _authorCtrl,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '이름 입력',
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Cafe24 Oneprettynight',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


