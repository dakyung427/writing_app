import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'NovelSaveScreen.dart';  

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
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent), 
            foregroundColor: MaterialStateProperty.all(Colors.black),   
            padding: MaterialStateProperty.all(EdgeInsets.zero),         
            minimumSize: MaterialStateProperty.all(Size(50, 40)),      
          ),
          child: const Text(
            '뒤로',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Cafe24 Oneprettynight',
            ),
          ),
        ),
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

              final selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDay);

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