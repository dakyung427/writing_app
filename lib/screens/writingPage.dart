import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global.dart' as globals;

class WritingScreen extends StatefulWidget {
  final int? editIndex;
  final String initialTitle;
  final String initialContent;
  final String? initialDate;

  const WritingScreen({
    super.key,
    this.editIndex,
    this.initialTitle = '',
    this.initialContent = '',
    this.initialDate,
  });

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _errorMessage;
  late DateTime _selectedDate;

  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isTimerRunning = false;
  bool _hasTimerStarted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    _selectedDate = widget.initialDate != null
        ? DateTime.parse(widget.initialDate!)
        : DateTime.now();

    final editIndex = widget.editIndex;
    if (editIndex != null) {
      final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final writings = globals.savedWritings[dateKey];
      if (writings != null && editIndex < writings.length) {
        final savedElapsed = writings[editIndex]['elapsedTime'];
        if (savedElapsed is String) {
          _elapsed = _parseDuration(savedElapsed);
          if (_elapsed > Duration.zero) {
            _hasTimerStarted = true;
          }
        }
      }
    }
  }

  Duration _parseDuration(String s) {
    try {
      final parts = s.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    } catch (e) {}
    return Duration.zero;
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
        _hasTimerStarted = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      });
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
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

    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);

    if (!globals.savedWritings.containsKey(dateKey)) {
      globals.savedWritings[dateKey] = [];
    }

    String? elapsedTimeStr;
    if (_hasTimerStarted) {
      elapsedTimeStr = _formatDuration(_elapsed);
    }

    final writingData = {
      'title': title,
      'content': content,
    };

    if (elapsedTimeStr != null) {
      writingData['elapsedTime'] = elapsedTimeStr;
    }

    if (widget.editIndex != null) {
      globals.savedWritings[dateKey]![widget.editIndex!] = writingData;
    } else {
      globals.savedWritings[dateKey]!.add(writingData);
    }

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
              left: 0,
              right: 0,
              top: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '닫기',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 20,
                          fontFamily: 'Cafe24 Oneprettynight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleTimer,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isTimerRunning
                            ? const Color.fromARGB(255, 237, 140, 140)
                            : const Color.fromARGB(255, 119, 210, 122),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _isTimerRunning ? '타이머 중지' : '타이머 시작',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Cafe24 Oneprettynight',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveWriting,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '저장',
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
            Positioned(
              left: 149,
              top: 120,
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
            if (_errorMessage != null)
              Positioned(
                left: 16,
                top: 195,
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: 'Cafe24 Oneprettynight',
                  ),
                ),
              ),
            if (_hasTimerStarted)
              Positioned(
                right: 20,
                top: 90,
                child: Text(
                  _formatDuration(_elapsed),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cafe24 Oneprettynight',
                    color: Colors.black87,
                  ),
                ),
              ),
            Positioned(
              left: 16,
              top: 215,
              child: Container(
                width: 371,
                height: 623,
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
          ],
        ),
      ),
    );
  }
}
