import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hairloss/const/colors.dart';

class MainCalendar extends StatelessWidget{
  final OnDaySelected onDaySelected;
  final DateTime selectedData;

  MainCalendar({
    required this.onDaySelected,
    required this.selectedData,
});

  @override
  Widget build(BuildContext context){
    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,

      selectedDayPredicate: (data) =>
      data.year == selectedData.year &&
      data.month == selectedData.month &&
      data.day == selectedData.day,
      firstDay: DateTime(1800,1,1),
      lastDay: DateTime(3000,1,1),
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}