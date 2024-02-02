import 'package:flutter/material.dart';
import 'package:hairloss/const/colors.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: renderAppBar(),
      body: Text('Home Screen'),
    );
  }

  AppBar renderAppBar() {
    // AppBar를 구현하는 함수
    return AppBar(
      centerTitle: true,
      title: Text(
        '반로썸',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}