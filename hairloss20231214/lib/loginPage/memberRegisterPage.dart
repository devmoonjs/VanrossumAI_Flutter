// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairloss/loginPage/loginDB.dart';

import 'loginMainPage.dart';

class MemberRegisterPage extends StatefulWidget {
  const MemberRegisterPage({Key? key}) : super(key: key);

  @override
  State<MemberRegisterPage> createState() => _MemberRegisterState();
}

class _MemberRegisterState extends State<MemberRegisterPage> {
  // 유저의 아이디와 비밀번호의 정보 저장
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController = TextEditingController();

  // 주소 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController addressController = TextEditingController();

  // 나이 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController ageController = TextEditingController();

  // 이름 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            // 아이디 입력 텍스트필드
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: userIdController,
                        placeholder: '아이디를 입력해주세요',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 비밀번호 입력 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: passwordController,
                        placeholder: '비밀번호를 입력해주세요',
                        textAlign: TextAlign.center,
                        obscureText: true,
                      ),
                    ),
                  ),
                  // 비밀번호 재확인 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: passwordVerifyingController,
                        placeholder: '비밀번호를 다시 입력해주세요',
                        textAlign: TextAlign.center,
                        obscureText: true,
                      ),
                    ),
                  ),
                  // 주소 입력 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: addressController,
                        placeholder: '주소를 입력해주세요', // 주소 입력 필드
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 나이 입력 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: ageController,
                        placeholder: '나이를 입력해주세요', // 나이 입력 필드
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 이름 입력 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: nameController,
                        placeholder: '이름을 입력해주세요', // 이름 입력 필드
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 로그인 페이지로 돌아가기
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 110,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              '뒤로 가기',
                              style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Text('   '),
                        // 계정 생성 버튼
                        SizedBox(
                          width: 195,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                              ),
                            ),
                            onPressed: () async {
                              // ID 중복확인
                              final idCheck = await confirmIdCheck(userIdController.text);
                              print('idCheck : $idCheck');

                              // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
                              if (idCheck != '0') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('입력한 아이디가 이미 존재합니다.'),
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
                              // 비밀번호가 다를 경우
                              else if (passwordController.text != passwordVerifyingController.text) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('입력한 비밀번호가 같지 않습니다.'),
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
                              // 주소, 나이, 이름을 포함하여 DB에 계정 정보 등록
                              else {
                                insertMember(
                                  userIdController.text,
                                  passwordController.text,
                                  addressController.text, // 주소 입력 필드
                                  int.parse(ageController.text), // 나이 입력 필드
                                  nameController.text, // 이름 입력 필드
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('아이디가 생성되었습니다.'),
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
                            child: Text('계정 생성'),
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
