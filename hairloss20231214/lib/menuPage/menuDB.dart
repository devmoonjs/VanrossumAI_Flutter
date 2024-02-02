import 'package:hairloss/config/hashPassword.dart';
import 'package:hairloss/config/mySqlConnector.dart';
import 'package:mysql_client/mysql_client.dart';

import 'login_tmp.dart';

Future<List<String>?> getChangeInfo() async {
  // 사용자 자격 증명 가져오기
  String getId = UserData.getId();
  String getPassword = UserData.getPassword();
  // MySQL 연결
  final conn = await dbConnector();

  // 비밀번호 해싱
  final hashedPassword = hashPassword(getPassword);
  print(hashedPassword);

  IResultSet? results;
  try {
    // 쿼리 실행
    results = await conn.execute(
      "SELECT address, age, name FROM users WHERE id = :id and password = :password",
      {
        "id": getId,
        "password": hashedPassword,
      },
    );

    String address = '';
    String age = '';
    String name = '';
    String id = getId;
    String password = getPassword;
    // Check if results are not empty
    if (results != null && results.length > 0) {
      for (final row in results.rows) {
        print(row.assoc());
        address = row.colAt(0).toString();
        age = row.colAt(1).toString();
        name = row.colAt(2).toString();
      }

      print(address);
      print(age);
      print(name);
      print(id);
      print(password);
      // 사용자 정보 리스트 생성
      List<String> userInfoList = [address, age, name, id, password];

      // Do something with userInfoList
      
      return userInfoList;
    } else {
      print("User not found");
      return null;
    }
  } catch (e) {
    // 프로세스 중에 발생한 오류 처리
    print("사용자 정보 가져오기 오류: $e");
    return null;
  }
}

Future<String?> beforePasswordcheck(String beforePassword) async {
  // MySQL 연결
  final conn = await dbConnector();

  // 비밀번호 해싱
  final hashedPassword = hashPassword(beforePassword);

  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  try {
    result = await conn.execute(
      "SELECT id FROM users WHERE password = :password",
      {
        "password": hashedPassword,
      },
    );

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print(row.assoc());
        // 유저 정보가 존재하면 유저의 index 값 반환
        return row.colAt(0).toString();
      }
    }
    else{
      return '-1';
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 정보 수정
Future<void> updateInfo(String id, String password, String address, int age, String name) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 비밀번호 암호화
  final hashedPassword = hashPassword(password);

  // DB에 유저 정보 추가
  try {
    await conn.execute(
      "UPDATE users SET password = :password, address = :address,  age = :age, name = :name WHERE id = :id",
      {
        "id": id,
        "password": hashedPassword,
        "address": address,
        "age": age,
        "name": name,
      },
    );
    print("정보 수정 완료");
    print(hashedPassword);
  }catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

//마이페이지 이름 가져오기
Future<String?> getUName(String id, String password) async{
  final conn = await dbConnector();

  final hashedPassword = hashPassword(password);

  IResultSet? results;
  try{
    results = await conn.execute(
      "SELECT name FROM users where id= :id and password= :password",
      {
        "id": id,
        "password": hashedPassword,
      },
    );
    String name = '';
    if (results != null && results.length > 0) {
      for(final row in results.rows) {
        print(row.assoc());
        name = row.colAt(0).toString();
      }
      print(name);
      return name;
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}
//회원 탈퇴
Future<void> deleteAccount(String password) async{

  String getId = UserData.getId();
  //MySQL 접속 설정
  final conn = await dbConnector();

  //비밀번호 암호화
  final hashedPassword = hashPassword(password);

  //DB 접근후 아이디와 비밀번호를 기준으로 삭제 수행
  try {
    await conn.execute(
      "DELETE FROM users where id= :id and password= :password",
      {
        "id": getId,
        "password": hashedPassword,
      },
    );
    print("탈퇴 완료");
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}