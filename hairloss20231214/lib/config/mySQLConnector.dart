/* mySqlConnector.dart */
import 'package:mysql_client/mysql_client.dart';
import 'package:hairloss/config/dbInfo.dart';

//20231117 패키지 추가
import 'package:mysql1/mysql1.dart';

// MySQL 접속
Future<MySQLConnection> dbConnector() async {
  print("Connecting to mysql server...");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: DbInfo.hostName,
    port: DbInfo.portNumber,
    userName: DbInfo.userName,
    password: DbInfo.password,
    databaseName: DbInfo.dbName, // optional
  );

  await conn.connect();

  print("Connected");

  return conn;
}



Future<MySqlConnection> dbConnector2() async {
  print("Connecting to mysql server2...");
  final settings = ConnectionSettings(
    host: DbInfo.hostName,
    port: DbInfo.portNumber,
    db: DbInfo.dbName,
    user: DbInfo.userName,
    password: DbInfo.password,
  );

  try {
    final MySqlConnection conn = await MySqlConnection.connect(settings);
    print("Connected2");
    return conn;
  } catch (e) {
    print("Error connecting to the database: $e");
    rethrow; // 예외를 다시 던져서 호출하는 측에서 처리할 수 있도록 함
  }
}