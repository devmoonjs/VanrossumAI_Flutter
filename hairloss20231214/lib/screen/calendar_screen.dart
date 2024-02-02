import 'package:flutter/material.dart';
import 'package:hairloss/component/main_calendar.dart';
import 'package:hairloss/component/schedule_card.dart';
import 'package:hairloss/component/today_banner.dart';
import 'package:hairloss/component/schedule_bottom_sheet.dart';
import 'package:hairloss/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:hairloss/calendar/calendar_database.dart';

class boardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<boardScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return MainCalendar(
                selectedData: selectedDate,
                onDaySelected: onDaySelected,
              );
            } else if (index == 1) {
              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: getSchedules(selectedDate), // 수정된 부분
                builder: (context, snapshot) {
                  return TodayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.length ?? 0,
                  );
                },
              );
            } else if (index == 2) {
              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: getSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Column(
                    children: snapshot.data!.map((schedule) {
                      return Dismissible(
                        key: ObjectKey(schedule['number']),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection direction) {
                          removeSchedules(schedule['number'], selectedDate);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                          child: ScheduleCard(
                            startTime: schedule['startTime'],
                            endTime: schedule['endTime'],
                            content: schedule['content'],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
