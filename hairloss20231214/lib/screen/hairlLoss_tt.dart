import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:hairloss/model/diagnosis_page.dart';
import 'package:hairloss/screen/temp_result_for_supplies.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hairloss/const/colors.dart';
import '../menuPage/login_tmp.dart';

class hairLoss extends StatefulWidget {
  @override
  _hairLossState createState() => _hairLossState();
}

class _hairLossState extends State<hairLoss> {
  String userid = UserData.getId();
  File? _image;
  final picker = ImagePicker();
  String diagnosisResult = '';
  List<String> symptomList1 = [];
  List<String> symptomList2 = [];
  List<String> symptomList3 = [];
  List<String> symptomList4 = [];
  List<String> symptomList5 = [];
  List<String> symptomList6 = [];

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Flask 서버에서 진단 결과를 가져오는 함수
  Future<void> _uploadImage() async {
    // 로딩 중 화면 터치 방지
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

    String apiUrl = 'http://192.168.35.4:5000/upload';
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    request.fields['userid'] = userid;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        var data = json.decode(jsonResponse);

        setState(() {
          diagnosisResult = data['message'];
          DiagnosisResult.setDiagnosisResult(data['message']);
          symptomList1 = data['predict1'].split(',');
          symptomList2 = data['predict2'].split(',');
          symptomList3 = data['predict3'].split(',');
          symptomList4 = data['predict4'].split(',');
          symptomList5 = data['predict5'].split(',');
          symptomList6 = data['predict6'].split(',');
        });

        // 터치 방지 해제
        overlayEntry.remove();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisPage(
              diagnosisResult,
              _image,
              symptomList1,
              symptomList2,
              symptomList3,
              symptomList4,
              symptomList5,
              symptomList6,
            ),
          ),
        );
      } else {
        setState(() {
          diagnosisResult = '서버 오류: ${response.statusCode}';
        });

        overlayEntry.remove();
      }
    } catch (e) {
      setState(() {
        diagnosisResult = '오류: $e';
      });

      overlayEntry.remove();
    }
  }

  Future getCameraImage() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      openCamera(); // 카메라 앱 열기
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('두피 진단'),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('이미지를 선택하세요.')
                : Padding(
              padding: EdgeInsets.all(8.0), // Add your desired padding value
              child: Image.file(
                _image!,
                width: 400,
                height: 280,
                fit: BoxFit.cover,
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
                SizedBox(width: 5),
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
              ]
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                ),
              ),
              onPressed: _uploadImage,
              child: Text(
                '진단 시작',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}