import 'dart:async';

import 'package:hairloss/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:intl/intl.dart';

import '../config/mySQLConnector.dart';
import '../menuPage/login_tmp.dart';
part 'calendar_database.g.dart';

// database 폴더에 있는 코드들은 일일 체크리스트와 연관된 데이터베이스 코드임

// 체크리스트 정보 저장
Future<void> insertshcedule(SchedulesCompanion data) async {
  String id = UserData.getId();
  int startTime = data.startTime.value!;
  int endTime = data.endTime.value!;
  String content = data.content.value!;
  DateTime date = data.date.value!;

  // Dart의 DateTime을 MySQL DATETIME 형식으로 포맷팅
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

  // MySQL 접속 설정
  final conn = await dbConnector();

  // DB에 캘린더 입력 정보 추가
  try {
    await conn.execute(
      "INSERT INTO Schedules (id, content, taking_date, startTime, endTime) VALUES (:id, :content, :taking_date, :startTime, :endTime)",
      {
        "id": id,
        "content": content,
        "taking_date": formattedDate,
        "startTime": startTime,
        "endTime": endTime,
      },
    );
    print("Insert successful");
  } catch (e) {
    print("Error inserting data: $e");
  }
}

// 선택된 날의 체크리스트 정보 가져오기
Stream<List<Map<String, dynamic>>> getSchedules(DateTime selectedDate) async* {
  String id = UserData.getId();

  final conn = await dbConnector();

  IResultSet? result;
  try {
    String formattedDate =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate.toUtc());

    result = await conn.execute(
      "SELECT number, content, taking_date, startTime, endTime FROM Schedules WHERE taking_date = :taking_date and id = :id",
      {
        "taking_date": formattedDate,
        "id": id,
      },
    );

    List<Map<String, dynamic>> schedules = [];
    for (final row in result.rows) {
      final number = row.colAt(0);
      final content = row.colAt(1);
      final takingDate = row.colAt(2);
      final startTime = row.colAt(3);
      final endTime = row.colAt(4);

      // Null 체크 후 int로 변환
      schedules.add({
        'number': number != null ? int.parse(number) : null,
        'content': content,
        'taking_date': takingDate,
        'startTime': startTime != null ? int.parse(startTime) : null,
        'endTime': endTime != null ? int.parse(endTime) : null,
      });
    }

    yield schedules;

  } catch (e) {
    print("Error retrieving data: $e");
    throw e;
  } finally {
    await conn.close();
  }
}

// 체크리스트 정보 삭제 -> 해당 체크리스트 카드를 우측으로 슬라이드 하면 삭제됨
Future<void> removeSchedules(int number, DateTime selectedDate) async {
  String getId = UserData.getId();

  String formattedDate =
  DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate.toUtc());

  final conn = await dbConnector();
  try{
    await conn.execute(
      "DELETE FROM Schedules where id = :id and number = :number and taking_date = :taking_date",
      {
        "id": getId,
        "number": number,
        "taking_date": formattedDate,
      },
    );
    print("삭제 완료");
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}