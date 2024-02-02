import 'package:flutter/material.dart';
import 'package:hairloss/component/main_calendar.dart';
import 'package:hairloss/component/schedule_card.dart';
import 'package:hairloss/component/today_banner.dart';
import 'package:hairloss/component/schedule_bottom_sheet.dart';
import 'package:hairloss/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:hairloss/calendar/calendar_database.dart';
import 'package:hairloss/screen/progress_status_screen.dart';
import 'package:hairloss/screen/calendar_screen.dart';

class careScreen extends StatefulWidget {
  @override
  _CareScreenState createState() => _CareScreenState();
}

class _CareScreenState extends State<careScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: null,
        body: TabBarView(
          children: [
            Center(
              child: progressStatus(),
            ),

            Center(
              child: boardScreen(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: TabBar(
            indicatorColor: Colors.greenAccent,
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '경과 상태 확인',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '일일 체크리스트',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
