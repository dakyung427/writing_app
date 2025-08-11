import 'package:flutter/material.dart';
import 'writingPage.dart';
import 'package:intl/intl.dart';
import '../global.dart' as globals;

class NovelSaveScreen extends StatefulWidget {
  final String? initialSelectedDate;

  const NovelSaveScreen({super.key, this.initialSelectedDate});

  @override
  State<NovelSaveScreen> createState() => _NovelSaveScreenState();
}

class _NovelSaveScreenState extends State<NovelSaveScreen> {
  late List<String> _recentDates;
  String? _selectedDate;
  int? _selectedIndex;
  bool _showDeleteDialog = false;

  @override
  void initState() {
    super.initState();
    _recentDates = _generateRecentDates(30);
    if (widget.initialSelectedDate != null) {
      if (!_recentDates.contains(widget.initialSelectedDate)) {
        _recentDates.insert(0, widget.initialSelectedDate!);
      }
    }
    if (widget.initialSelectedDate != null) {
      _selectedDate = widget.initialSelectedDate;
    } else {
      _selectedDate = _recentDates.first;
    }
  }

  List<String> _generateRecentDates(int days) {
    final today = DateTime.now();
    return List.generate(days, (index) {
      final date = today.subtract(Duration(days: index));
      return DateFormat('yyyy-MM-dd').format(date);
    });
  }

  List<Map<String, String>> get _writingsForSelectedDate {
    if (_selectedDate == null) return [];
    return globals.savedWritings[_selectedDate!] ?? [];
  }

  String getUntitledLabel(int index) => '무제 ${index + 1}';

  void _deleteSelected() {
    if (_selectedIndex != null && _selectedDate != null) {
      globals.savedWritings[_selectedDate!]!.removeAt(_selectedIndex!);
      setState(() {
        _selectedIndex = null;
        _showDeleteDialog = false;
      });
    }
  }

  Future<void> _navigateToWrite({int? index}) async {
    final writings = _writingsForSelectedDate;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WritingScreen(
          editIndex: index,
          initialTitle: index != null ? writings[index]['title'] ?? '' : '',
          initialContent: index != null ? writings[index]['content'] ?? '' : '',
          initialDate: _selectedDate,
        ),
      ),
    );

    if (result == true || result == false) {
      setState(() {
        _selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final writings = _writingsForSelectedDate;
    final selectedTitle = (_selectedIndex != null && writings.isNotEmpty)
        ? (writings[_selectedIndex!]['title']?.isNotEmpty ?? false
            ? writings[_selectedIndex!]['title']!
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
                Positioned(
                  left: 18,
                  top: 30,
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
                  left: 140,
                  top: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: _selectedDate,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cafe24 Oneprettynight',
                        color: Colors.black,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedDate = newValue;
                            _selectedIndex = null;
                            _showDeleteDialog = false;
                          });
                        }
                      },
                      items: _recentDates
                          .map<DropdownMenuItem<String>>((String date) {
                        return DropdownMenuItem<String>(
                          value: date,
                          child: Text(date),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Positioned(
                  left: 340,
                  top: 30,
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
                  top: 175,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: writings.isEmpty
                      ? const Center(
                          child: Text(
                            '선택한 날짜에 저장된 글이 없습니다.',
                            style: TextStyle(
                              fontFamily: 'Cafe24 Oneprettynight',
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: writings.length,
                          itemBuilder: (context, index) {
                            final writing = writings[index];
                            final title = writing['title']?.trim();
                            final content = writing['content']?.trim();
                            final elapsedTime = writing['elapsedTime'] ?? '';
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                displayTitle,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'Cafe24 Oneprettynight',
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (elapsedTime.isNotEmpty)
                                              Positioned(
                                                right: 0,
                                                child: Text(
                                                  elapsedTime,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Cafe24 Oneprettynight',
                                                    color: Color(0xFF797979),
                                                  ),
                                                ),
                                              ),
                                          ],
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
                              text: selectedTitle + ' ',
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
