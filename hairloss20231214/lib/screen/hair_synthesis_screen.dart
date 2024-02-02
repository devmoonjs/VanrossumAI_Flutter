import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:hairloss/model/hair_synthesis_result.dart';
import 'dart:typed_data';
import 'package:hairloss/const/colors.dart';

import '../menuPage/login_tmp.dart';

class hairsynthesis extends StatefulWidget {
  @override
  _hairsynthesis createState() => _hairsynthesis();
}

class _hairsynthesis extends State<hairsynthesis> {
  String sampleResult = '';
  final picker = ImagePicker();
  File? _image;
  String id = UserData.getId();
  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();

    // 알림창에 출력될 예시 이미지 경로
    Image imageToShow = Image.asset('assets/images/example.jpg');

    // 알림창 출력
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이미지 선택 안내'),
          content: Column(
            children: <Widget>[
              Text('예시와 같은 이미지를 선택해주세요.'),
              Text('어깨 위로 정면 촬영 및 안경 착용 X'),
              SizedBox(height: 10),
              imageToShow, // Display the image
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future getCameraImage() async {
    final status = await Permission.camera.status;

    Image imageToShow = Image.asset('assets/images/example.jpg');
    if (status.isGranted) {
      // 촬영 안내 다이얼로그를 표시
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('카메라 촬영 안내'),
            content: Column(
              children: <Widget>[
                Text('예시와 같은 이미지를 선택해주세요.'),
                Text('어깨 위로 정면 촬영 및 안경 착용 X'),
                SizedBox(height: 10),
                imageToShow, // Display the image
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 알림창 닫기
                  openCamera(); // 카메라 앱 열기
                },
              ),
            ],
          );
        },
      );
    } else if (status.isDenied) {
      await Permission.camera.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // 카메라 앱 열기 함수
  void openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadAndFetchImage() async {
    // 화면 터치 방지
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    if (_image != null) {
      String uploadUrl = 'http://192.168.35.4:5000/wear_wig';
      try {
        var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
        request.fields['selectedWig'] = selectedWig.toString();
        request.fields['userid'] = UserData.getId(); // id 추가
        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

        request.headers['Connection'] = 'keep-alive';

        var response = await request.send();

        if (response.statusCode == 200) {
          // 화면 터치 해제
          overlayEntry.remove();

          print('이미지 업로드 완료');
          var jpgBytes = await response.stream.toBytes();

          if (jpgBytes.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(imageBytes: jpgBytes),
              ),
            );
          } else {
            print('이미지 바이트가 비어 있음');
          }
        } else {
          print('이미지 업로드 에러: ${response.statusCode}');
        }
      } catch (e) {
        print('네트워크 오류: $e');
      }
    } else {
      overlayEntry.remove();
      print('먼저 이미지를 선택하세요.');
    }
  }

  int selectedWig = 0;

  Widget selectWig(String assetName, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedWig = index;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
            width: (selectedWig == index) ? 2.0 : 0.5,
            color: (selectedWig == index)
                ? Colors.green
                : Colors.blue.shade600),
      ),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              assetName,
              fit: BoxFit.contain,
              width: 120,
              height: 120,
            ),
          ),
          if (selectedWig == index)
            Positioned(
              top: 5,
              right: 5,
              child: Image.asset(
                "assets/images/tick-circle.png",
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100.0), // 여기서 top을 사용하여 아래로 내림
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _image == null
                    ? Text('이미지를 선택하세요.')
                    : Transform.scale(
                  scale: 0.9,
                  child: Image.file(
                    File(_image!.path),
                    width: 400,
                    height: 400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                        ),
                      ),
                      onPressed: _getImageFromGallery,
                      child: Text(
                        '이미지 선택',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                        ),
                      ),
                      onPressed: getCameraImage,
                      child: Text(
                        '카메라로 사진 찍기',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      SizedBox(width: 20),
                      selectWig("assets/images/target1.png", 0),
                      SizedBox(width: 20),
                      selectWig("assets/images/target2.png", 1),
                      SizedBox(width: 20),
                      selectWig("assets/images/target3.png", 2),
                      SizedBox(width: 20),
                      selectWig("assets/images/target4.png", 3),
                      SizedBox(width: 20),
                      selectWig("assets/images/target5.png", 4),
                    ],
                  ),
                ),
                // "가발 착용" button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                        ),
                      ),
                      onPressed: _uploadAndFetchImage,
                      child: Text(
                        '가발 착용',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
