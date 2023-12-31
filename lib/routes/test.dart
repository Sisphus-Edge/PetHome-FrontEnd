import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCalendar(),
    );
  }
}

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DateTime _selectedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Stack(
        children: [
          Center(
            child: TableCalendar(
              firstDay: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
              lastDay: DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                // Handle selected date
                print('Selected: $_selectedDay');
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                weekendStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPageChanged: (focusedDay) {},
            ),
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullCalendar()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //
  //     // floatingActionButton: FloatingActionButton(
  //     //   onPressed: () {
  //     //     Navigator.push(
  //     //       context,
  //     //       MaterialPageRoute(builder: (context) => FullCalendar()),
  //     //     );
  //     //   },
  //     //   child: Icon(Icons.calendar_today),
  //     // ),
  //
  //     child: Center(
  //       child: TableCalendar(
  //         firstDay: DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
  //         lastDay: DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday)),
  //         focusedDay: DateTime.now(),
  //         calendarFormat: CalendarFormat.week,
  //         selectedDayPredicate: (day) {
  //           return isSameDay(_selectedDay, day);
  //         },
  //         onDaySelected: (selectedDay, focusedDay) {
  //           setState(() {
  //             _selectedDay = selectedDay;
  //           });
  //           // Handle selected date
  //           print('Selected: $_selectedDay');
  //         },
  //         headerStyle: const HeaderStyle(
  //           formatButtonVisible: false,
  //         ),
  //         calendarStyle: const CalendarStyle(
  //           outsideDaysVisible: false,
  //         ),
  //         daysOfWeekStyle: const DaysOfWeekStyle(
  //           weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
  //           weekendStyle: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         onPageChanged: (focusedDay) {},
  //       ),
  //     ),
  //   );
  // }
}

class FullCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Calendar'),
      ),
      body: Center(
        child: Text('Full Calendar Page'),
      ),
    );
  }
}
