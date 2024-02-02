import 'package:flutter/material.dart';
import 'package:hairloss/calendar/calendar_database.dart';
import 'package:hairloss/loginPage/loginDB.dart';
import 'package:hairloss/loginPage/memberRegisterPage.dart';
import 'package:hairloss/loginPage/loginMainPage.dart'; // 실제 경로로 변경 필요
import 'package:hairloss/screen/root_screen.dart'; // 실제 경로로 변경 필요
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart'; // 로캘 데이터 초기화를 위해 추가

void main() {
  // 로캘 데이터 초기화
  initializeDateFormatting('ko', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TokenCheck(), // TokenCheck 위젯을 홈으로 설정
    );
  }
}