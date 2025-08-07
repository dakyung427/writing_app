import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'NovelSaveScreen.dart';  // 파일 경로에 맞게 수정하세요.

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontFamily: 'Cafe24 Oneprettynight',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // 선택한 날짜를 'yyyy-MM-dd' 형식으로 변환
              final selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDay);

              // 노블세이브스크린으로 날짜 전달하며 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelSaveScreen(
                    initialSelectedDate: selectedDateString,
                  ),
                ),
              );
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 219, 231),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 205, 226),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
          ),
        ],
      ),
    );
  }
}