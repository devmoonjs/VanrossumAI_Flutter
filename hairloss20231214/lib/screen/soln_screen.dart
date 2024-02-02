import 'package:flutter/material.dart';
import 'package:hairloss/screen/map_screen.dart';
import 'package:hairloss/screen/hair_synthesis_screen.dart';

class solnScrean extends StatefulWidget {
  @override
  _SolnScreanState createState() => _SolnScreanState();
}

class _SolnScreanState extends State<solnScrean> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // Set the default tab index
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: null, // Remove the AppBar
        body: TabBarView(
          children: [
            MapScreen(),
            hairsynthesis(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white, // Set background color for the TabBar
          child: TabBar(
            indicatorColor: Colors.greenAccent,
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '병원 소개',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '가상 가발 착용',
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
