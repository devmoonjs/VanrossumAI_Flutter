// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairloss/menuPage/menuDB.dart';

import 'package:hairloss/const/colors.dart';
import '../menuPage/login_tmp.dart';
import 'package:hairloss/loginPage/loginMainPage.dart'; // 실제 경로로 변경 필요

class deleteAccountPage extends StatefulWidget {
  deleteAccountPage({Key? key}) : super(key: key);

  @override
  State<deleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<deleteAccountPage> {
  // 유저의 아이디와 비밀번호의 정보 저장

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              // 아이디 입력 텍스트필드
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 비밀번호 입력창
                    Padding(
                      padding: const EdgeInsets.only(top: 250.0, left: 8.0, right: 8.0, bottom: 8.0),
                      child: SizedBox(
                        width: 300,
                        child: CupertinoTextField(
                          controller: passwordController,
                          placeholder: '현재 비밀번호를 입력해주세요',
                          textAlign: TextAlign.center,
                          obscureText: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // Change the radius as needed
                                  ),
                                ),
                              ),
                              child: Text(
                                '뒤로 가기',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text('   '),
                          // 계정 생성 버튼
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: PRIMARY_COLOR,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                                ),
                              ),
                              onPressed: () async {
                                final beforepasswordck = await(beforePasswordcheck(passwordController.text));
                                if (beforepasswordck == '-1'){
                                  print('비밀번호 불일치');
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('알림'),
                                        content: Text('비밀번호가 일치하지 않습니다.'),
                                        actions: [
                                          TextButton(
                                            child: Text('닫기'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                // 탈퇴 절차 수행
                                else {
                                  print("변경 확인 절차");
                                  print(passwordController.text);
                                  deleteAccount(
                                    passwordController.text,
                                  );
                                  UserData.setUserData('', '', '');
                                  print(UserData.getId());
                                  print(UserData.getPassword());
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('알림'),
                                        content: Text('탈퇴가 완료되었습니다. 감사합니다.'),
                                        actions: [
                                          TextButton(
                                            child: Text('닫기'),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the alert dialog
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) => TokenCheck(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text('회원 탈퇴'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}
