import 'package:flutter/material.dart';
import 'package:hairloss/screen/map_screen.dart';
import 'package:hairloss/screen/beauty_supplies.dart';
import 'package:hairloss/screen/forum_screen.dart';

class infoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // Set the default tab index
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: null, // Remove the AppBar
        body: TabBarView(
          children: [
            // 첫 번째 탭: 미용 용품 페이지 (임시 페이지)
            beautysupplies(),

            // 두 번째 탭: 모발 관리 게시판
            //원래 있던 게시판 페이지 메서드
            // Board(),
            //새로 연결할 게시판 페이지 메서드
            ForumScreen(),
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
                    '미용 용품 추천',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '모발 관리 게시판',
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
}
