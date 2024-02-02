// 로그인 입력창에 입력된 아이디와 비밀번호의 getter setter
// 정보 수정과 회원 탈퇴에 사용됨
import 'package:flutter/foundation.dart';

class UserData {
  static String userId = '';
  static String password = '';
  static String name='';

  //아이디를 가져오는 getter 메서드
  static String getId() {
    print(userId);
    return userId;
  }

  // 비밀번호를 가져오는 getter 메서드
  static String getPassword() {
    print(password);
    return password;
  }

  static String getname(){
    print(name);
    return name;
  }

  static void setUserData(String getuserID, String getpassword, String getname){
    userId = getuserID;
    password = getpassword;
    name = getname;
  }
}