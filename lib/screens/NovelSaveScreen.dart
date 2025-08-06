import 'package:flutter/material.dart';
import 'writingPage.dart';
import '../global.dart' as globals;

class NovelSaveScreen extends StatefulWidget {
  const NovelSaveScreen({super.key});

  @override
  State<NovelSaveScreen> createState() => _NovelSaveScreenState();
}

class _NovelSaveScreenState extends State<NovelSaveScreen> {
  int? _selectedIndex;
  bool _showDeleteDialog = false;

  String getUntitledLabel(int index) => '무제 ${index + 1}';

  void _deleteSelected() {
    if (_selectedIndex != null) {
      globals.savedWritings.removeAt(_selectedIndex!);
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
            ? globals.savedWritings[index]['title'] ?? ''
            : '',
        initialContent: index != null
            ? globals.savedWritings[index]['content'] ?? ''
            : '',
      ),
    ),
  );

  if (result == true) {
    // 저장 후 돌아왔을 때
    setState(() {
      _selectedIndex = null;
    });
  } else if (result == false) {
    // 취소 후 돌아왔을 때
    setState(() {
      _selectedIndex = null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final savedWritings = globals.savedWritings;
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
                      '글 목록',
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
                Positioned(
                  left: 18,
                  top: 61,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedIndex != null) {
                        setState(() => _showDeleteDialog = true);
                      } else {
                        Navigator.pop(context);
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
                Positioned(
                  left: 340,
                  top: 61,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedIndex != null) {
                        _navigateToWrite(index: _selectedIndex);
                      } else {
                        _navigateToWrite();
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
                                fontWeight: FontWeight.normal,
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

