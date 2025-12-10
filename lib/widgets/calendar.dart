import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/widgets/image_pp.dart';
import 'package:nds_gui_kit/widgets/text.dart';

class NDSCalendar extends StatefulWidget {
  const NDSCalendar({super.key});

  @override
  NDSCalendarState createState() => NDSCalendarState();
}

class NDSCalendarState extends State<NDSCalendar> {
  late DateTime _currentDate;
  late Timer _timer;

  static const double _cellWidth = 16;
  static const double _cellHeight = 16;
  static const double _headerHeight = 14.5;
  static const double _weekdayHeight = 16;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();

    _timer = Timer.periodic(Duration(hours: 1), (timer) {
      setState(() {
        _currentDate = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int year = _currentDate.year;
    final int month = _currentDate.month;
    final int today = _currentDate.day;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    int startWeekday = firstDayOfMonth.weekday % 7;

    return Stack(
      children: [
        ImagePP('assets/images/calendar.png'),
        Positioned(
          top: 3.5,
          left: 0,
          right: 0,
          child: Center(
            child: NDSText(
              text: '${month.toString().padLeft(2, '0')} / $year',
              color: Colors.grey[800]!,
            ),
          ),
        ),
        Positioned(
          top: (_headerHeight + 2.5),
          left: 2,
          child: _buildWeekdayHeader(),
        ),
        Positioned(
          top: (_headerHeight + _weekdayHeight + 2),
          left: 2,
          child: _buildDaysGrid(daysInMonth, startWeekday, today),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(7, (index) {
        return SizedBox(
          width: _cellWidth,
          height: _cellHeight,
          child: Center(child: NDSText(text: weekdays[index])),
        );
      }),
    );
  }

  Widget _buildDaysGrid(int daysInMonth, int startWeekday, int today) {
    List<Widget> rows = [];
    int dayCounter = 1;

    int totalCells = startWeekday + daysInMonth;
    int numWeeks = (totalCells / 7).ceil();

    for (int week = 0; week < numWeeks; week++) {
      List<Widget> dayCells = [];

      for (int weekday = 0; weekday < 7; weekday++) {
        int cellIndex = week * 7 + weekday;

        if (cellIndex < startWeekday || dayCounter > daysInMonth) {
          dayCells.add(SizedBox(width: _cellWidth, height: _cellHeight));
        } else {
          bool isToday = dayCounter == today;
          dayCells.add(_buildDayCell(dayCounter, weekday, isToday));
          dayCounter++;
        }
      }

      rows.add(Row(mainAxisSize: MainAxisSize.min, children: dayCells));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: rows);
  }

  Widget _buildDayCell(int day, int weekday, bool isToday) {
    Color textColor;

    if (weekday == 0) {
      textColor = const Color(0xFFE00080);
    } else if (weekday == 6) {
      textColor = const Color(0xFF0000FF);
    } else {
      textColor = const Color(0xFF404040);
    }

    Widget content = NDSText(text: day.toString(), color: textColor);

    if (isToday) {
      return Transform.translate(
        offset: Offset(-0.5, 0.5),
        child: SizedBox(
          width: _cellWidth,
          height: _cellHeight,
          child: Center(
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0000FF), width: 1),
                color: const Color.fromARGB(64, 0, 0, 255),
              ),
              alignment: Alignment.center,
              child: content,
            ),
          ),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(0, 2),
      child: SizedBox(
        width: _cellWidth,
        height: _cellHeight,
        child: Center(child: content),
      ),
    );
  }
}
