import 'package:flutter/material.dart';
import 'randomWritingScreen.dart';
import 'randomSubjectScreen.dart';
import 'listScreen.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // 웹 저장용
import 'package:flutter/services.dart' show rootBundle; // ✅ 폰트 로드용
import '../global.dart' as globals;

class RandomNovelSaveScreen extends StatefulWidget {
  const RandomNovelSaveScreen({super.key});

  @override
  State<RandomNovelSaveScreen> createState() => _RandomNovelSaveScreenState();
}

class _RandomNovelSaveScreenState extends State<RandomNovelSaveScreen> {
  int? _selectedIndex;
  bool _showDeleteDialog = false;

  String getUntitledLabel(int index) => '무제 ${index + 1}';

  void _deleteSelected() {
    if (_selectedIndex != null) {
      globals.randomSavedWritings.removeAt(_selectedIndex!);
      setState(() {
        _selectedIndex = null;
        _showDeleteDialog = false;
      });
    }
  }

  Future<void> _navigateToWrite({int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritingScreen(
          editIndex: index,
          initialTitle: index != null
              ? globals.randomSavedWritings[index]['title'] ?? ''
              : '',
          initialContent: index != null
              ? globals.randomSavedWritings[index]['content'] ?? ''
              : '',
          isRandom: true,
          subject: index != null
              ? globals.randomSavedWritings[index]['subject'] // ✅ 주제 전달
              : null,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        _selectedIndex = null;
      });
    }
  }

  /// ✅ PDF 내보내기 함수 (NanumMyeongjo 적용)
  Future<void> _exportToPdf() async {
    if (_selectedIndex == null) return;

    final writing = globals.randomSavedWritings[_selectedIndex!];
    final title = (writing['title']?.isNotEmpty ?? false)
        ? writing['title']!
        : getUntitledLabel(_selectedIndex!);
    final subject = writing['subject'] ?? '주제 없음';
    final content = writing['content'] ?? '';

    final pdf = pw.Document();

    // ✅ NanumMyeongjo 폰트 로드
    final fontData = await rootBundle.load("assets/font/NanumMyeongjo.TTF");
    final nanumFont = pw.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                font: nanumFont,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              "주제: $subject",
              style: pw.TextStyle(
                font: nanumFont,
                fontSize: 18,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              content,
              style: pw.TextStyle(
                font: nanumFont,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // ✅ 웹 다운로드 처리
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "$title.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // ✅ 모바일/데스크탑 저장
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/$title.pdf");
      await file.writeAsBytes(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedWritings = globals.randomSavedWritings;
    final selectedTitle = _selectedIndex != null
        ? (savedWritings[_selectedIndex!]['title']?.isNotEmpty ?? false
            ? savedWritings[_selectedIndex!]['title']!
            : getUntitledLabel(_selectedIndex!))
        : '';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 402,
            height: 874,
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                const Positioned(
                  left: 134,
                  top: 95,
                  child: SizedBox(
                    width: 135,
                    height: 29,
                    child: Text(
                      '랜덤 글 목록',
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
                // 뒤로 / 삭제
                Positioned(
                  left: 18,
                  top: 61,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedIndex != null) {
                        setState(() => _showDeleteDialog = true);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const ListScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      _selectedIndex != null ? '삭제' : '뒤로',
                      style: TextStyle(
                        color: _selectedIndex != null
                            ? const Color(0xFFE81F1F)
                            : const Color(0xFFA0A0A0),
                        fontSize: 20,
                        fontFamily: 'Cafe24 Oneprettynight',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                // 수정 / 글 추가
                Positioned(
                  left: _selectedIndex == null ? 340 : 280, // ✅ 글 선택 여부에 따라 위치 조정
                  top: 61,
                  child: GestureDetector(
                    onTap: () async {
                      if (_selectedIndex != null) {
                        await _navigateToWrite(index: _selectedIndex);
                      } else {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RandomTopicScreen()),
                        );
                        if (result == true) {
                          setState(() {
                            _selectedIndex = null;
                          });
                        }
                      }
                    },
                    child: Text(
                      _selectedIndex != null ? '수정' : '글 추가',
                      style: TextStyle(
                        color: _selectedIndex != null
                            ? Colors.blue
                            : const Color(0xFF3C96D7),
                        fontSize: 20,
                        fontFamily: 'Cafe24 Oneprettynight',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                // ✅ PDF 버튼
                if (_selectedIndex != null)
                  Positioned(
                    left: 340,
                    top: 61,
                    child: GestureDetector(
                      onTap: _exportToPdf,
                      child: const Text(
                        'pdf',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontFamily: 'Cafe24 Oneprettynight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                // 글 목록
                Positioned(
                  top: 175,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ListView.builder(
                    itemCount: savedWritings.length,
                    itemBuilder: (context, index) {
                      final writing = savedWritings[index];
                      final title = writing['title']?.trim();
                      final content = writing['content']?.trim();
                      final displayTitle = (title == null || title.isEmpty)
                          ? getUntitledLabel(index)
                          : title;
                      final isSelected = _selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = isSelected ? null : index;
                            _showDeleteDialog = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 42, vertical: 10),
                          child: Container(
                            width: 318,
                            height: 170,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFE81F1F)
                                    : const Color(0xFFA29794),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    displayTitle,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Cafe24 Oneprettynight',
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    content ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Cafe24 Oneprettynight',
                                      color: Color(0xFF797979),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 삭제 다이얼로그
          if (_showDeleteDialog)
            Positioned(
              left: 43,
              top: 350,
              child: Container(
                width: 318,
                height: 138,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE81F1F)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 30,
                      left: 65,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$selectedTitle ',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Cafe24 Oneprettynight',
                              ),
                            ),
                            const TextSpan(
                              text: '삭제하시겠습니까?',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFE81F1F),
                                fontFamily: 'Cafe24 Oneprettynight',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 70,
                      top: 85,
                      child: GestureDetector(
                        onTap: _deleteSelected,
                        child: const Text(
                          '네',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFE81F1F),
                            fontFamily: 'Cafe24 Oneprettynight',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 205,
                      top: 85,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showDeleteDialog = false;
                            _selectedIndex = null;
                          });
                        },
                        child: const Text(
                          '아니요',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Cafe24 Oneprettynight',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
