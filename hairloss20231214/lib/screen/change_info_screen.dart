import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hairloss/menuPage/menuDB.dart';

import 'package:hairloss/const/colors.dart';

import '../menuPage/login_tmp.dart';

class ChangeInfoPage extends StatefulWidget {
  ChangeInfoPage({Key? key}) : super(key: key);

  @override
  State<ChangeInfoPage> createState() => _ChangeInfoPageState();
}

class _ChangeInfoPageState extends State<ChangeInfoPage> {
  // 유저의 아이디와 비밀번호의 정보 저장
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController beforepasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordVerifyingController = TextEditingController();

  // 주소 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController addressController = TextEditingController();

  // 나이 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController ageController = TextEditingController();

  // 이름 입력 텍스트필드의 컨트롤러 변수
  final TextEditingController nameController = TextEditingController();

  // 사용자 정보 가져오기
  Future<void> getUserInfo() async {
    // getChangeInfo 함수를 사용하여 사용자 정보 가져오기
    List<String>? info = await getChangeInfo();
    // 정보가 있는지 확인
    if (info != null) {
      // 정보를 컨트롤러 변수에 할당
      setState(() {
        userIdController.text = info[3]; // ID
        addressController.text = info[0]; // Address
        ageController.text = info[1]; // Age
        nameController.text = info[2]; // Name
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // 사용자 정보 가져오는 함수 호출
    getUserInfo();
  }

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
                  // 아이디 확인창
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: userIdController,
                        textAlign: TextAlign.center,
                        enabled: false,
                        readOnly: true,
                        
                      ),
                    ),
                  ),
                  // 이전 비밀번호 입력 텍스트필드
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: beforepasswordController,
                        placeholder: '현재 비밀번호를 입력해주세요',
                        textAlign: TextAlign.center,
                        obscureText: true,
                      ),
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: CupertinoTextField(
                        controller: newPasswordController,
                        placeholder: '새로운 비밀번호를 입력해주세요',
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
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
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
                              final beforepasswordck = await(beforePasswordcheck(beforepasswordController.text));
                              if (beforepasswordck == '-1'){
                                print('이전 비밀번호 불일치');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('이전 비밀번호가 일치하지 않습니다.'),
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
                              // 새로운 비밀번호와 확인 비밀번호가 다를 경우
                              else if (newPasswordController.text != passwordVerifyingController.text) {
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
                                UserData.setUserData(userIdController.text, newPasswordController.text, nameController.text);
                                String validId = UserData.getId();
                                String validPw = UserData.getPassword();
                                print("변경 확인 절차");
                                print(validId);
                                print(validPw);
                                updateInfo(
                                  userIdController.text,
                                  newPasswordController.text,
                                  addressController.text, // 주소 입력 필드
                                  int.parse(ageController.text), // 나이 입력 필드
                                  nameController.text, // 이름 입력 필드
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('정보 수정이 완료되었습니다.'),
                                      actions: [
                                        TextButton(
                                          child: Text('닫기'),
                                          onPressed: () {
                                            String id = UserData.getId();
                                            UserData.setUserData(id, newPasswordController.text, nameController.text);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              '정보 수정',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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