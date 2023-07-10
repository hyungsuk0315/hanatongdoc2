import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import '../src/widget_appBar.dart';
import '../utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar:AppBar(
          title: Text('하나 통독'),
          leading: ImageIcon(
          AssetImage('images/lalab_logo.png')
          )
        ),
        body:Calendar()
      )
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDays.contains(_focusedDay);
      // Update values in a Set
      // if (_selectedDays.contains(selectedDay)) {
      //   _selectedDays.remove(selectedDay);
      // } else {
      //   _selectedDays.add(selectedDay);
      // }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          ElevatedButton(
            child: Text('읽음'),
            onPressed: () {
              setState(() {
                if(!_selectedDays.contains(_focusedDay))
                  _selectedDays.add(_focusedDay);
                else
                  _selectedDays.remove(_focusedDay);
              });
            },
          ),
          const SizedBox(height: 8.0),

          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              // Use values from Set to mark multiple days as selected
              return _selectedDays.contains(day);

            },
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }}