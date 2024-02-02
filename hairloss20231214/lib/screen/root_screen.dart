import 'package:flutter/material.dart';
import 'package:hairloss/component/main_calendar.dart';
import 'package:hairloss/component/schedule_card.dart';
import 'package:hairloss/component/today_banner.dart';
import 'package:hairloss/component/schedule_bottom_sheet.dart';
import 'package:hairloss/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:hairloss/calendar/calendar_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hairloss/screen/hairlLoss_tt.dart';
import 'dart:async';
import 'package:hairloss/screen/map_screen.dart';
import 'package:hairloss/screen/soln_screen.dart';
import 'package:hairloss/screen/info_screen.dart';
import 'package:hairloss/screen/care_screen.dart';

import '../loginPage/loginDB.dart';
import 'change_info_screen.dart';
import 'user_delete_screen.dart';
import 'package:hairloss/menuPage/login_tmp.dart';
import 'package:hairloss/menuPage/menuDB.dart';
import 'package:hairloss/loginPage/loginMainPage.dart';

class BottomNavi extends StatefulWidget {
  const BottomNavi({Key? key});

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}


class _BottomNaviState extends State<BottomNavi> {
  XFile? _imageFile;
  int _selectedTabIndex = 0;

  // 마이페이지 상단 이름 정보 출력
  String myPageId = UserData.getId();
  String myPagePw = UserData.getPassword();
  String name = UserData.getname();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercept back button press
        bool logoutConfirmed = await showLogoutConfirmationDialog(context);

        if (logoutConfirmed) {
          // Navigate to login screen when confirmed
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TokenCheck(),
            ),
          );
        }

        // Return false to prevent default behavior
        return Future.value(false);
      },
      child: MaterialApp(
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('반로썸'),
              backgroundColor: PRIMARY_COLOR,
              foregroundColor: Colors.white,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: PRIMARY_COLOR,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '마이 페이지',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '안녕하세요 $name님',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // 필요에 따라 폰트 크기 조절
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('정보 수정'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangeInfoPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cancel_presentation),
                    title: Text('회원 탈퇴'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => deleteAccountPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('로그아웃'),
                    onTap: () async {
                      bool logoutConfirmed = await showLogoutConfirmationDialog(context);

                      if (logoutConfirmed) {
                        String id = UserData.getId();
                        insertLogOutLog(id);
                        UserData.setUserData('', '', '');
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => TokenCheck(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Center(
                    child: hairLoss()
                ),
                Center(
                  child: infoScreen(),
                ),
                Center(
                  child: careScreen(),
                ),

                Center(
                  child: solnScrean(),
                ),
              ],
            ),
            extendBodyBehindAppBar: true,
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Container(
                height: 70,
                padding: EdgeInsets.only(bottom: 10, top: 5),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.greenAccent,
                  indicatorWeight: 2,
                  labelColor: Colors.greenAccent,
                  unselectedLabelColor: Colors.black38,
                  labelStyle: TextStyle(
                    fontSize: 13,
                  ),
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.search,
                      ),
                      text: 'Analysis',
                    ),
                    Tab(
                      icon: Icon(Icons.collections_bookmark),
                      text: 'Info',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.science,
                      ),
                      text: 'care',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.local_hospital,
                      ),
                      text: 'Soln',
                    ),
                  ],
                  onTap: (index) {
                    // 탭이 선택될 때 _selectedTabIndex 업데이트
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '로그아웃 하시겠습니까?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20, // 필요에 따라 폰트 크기 조절
              ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                String id = UserData.getId();
                insertLogOutLog(id);
                UserData.setUserData('', '', '');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => TokenCheck(),
                  ),
                );
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
