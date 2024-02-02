import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:hairloss/const/colors.dart';

import '../menuPage/login_tmp.dart';

class progressStatus extends StatefulWidget {
  @override
  _ProgressStatusState createState() => _ProgressStatusState();
}

class _ProgressStatusState extends State<progressStatus> {
  String userId = UserData.getId();
  List<File> imageFiles = [];
  List<String> textData = [];

  Future<void> downloadAndExtractZip() async {
    try {
      print(userId);
      final response = await http.get(
        Uri.parse('http://192.168.35.4:5000/progress_status?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempZipFile = File('${tempDir.path}/images.zip');

        await tempZipFile.writeAsBytes(response.bodyBytes, flush: true);

        final archive = ZipDecoder().decodeBytes(tempZipFile.readAsBytesSync());

        imageFiles.clear();
        textData.clear();

        for (final file in archive) {
          final fileContent = file.content as List<int>;

          if (file.name.endsWith('.jpg')) {
            final imageFile = File('${tempDir.path}/${file.name}');
            await imageFile.writeAsBytes(fileContent, flush: true);
            imageFiles.add(imageFile);
          } else if (file.name == 'analysisinfo.txt') {
            final text = String.fromCharCodes(fileContent);
            final decodedText = utf8.decode(fileContent);
            textData = decodedText.split('\n');
          }
        }

        setState(() {});
      } else {
        // HTTP 요청이 실패한 경우 간단한 오류 메시지를 AlertDialog로 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('오류 발생!!'),
              content: Text('HTTP request failed with status: ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // 네트워크 오류 등의 예외가 발생한 경우 간단한 오류 메시지를 AlertDialog로 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류 발생!!'),
            content: Text('Error: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100.0), // 여기서 top을 사용하여 아래로 내림
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // 원하는 값으로 변경
                  ),
                ),
                onPressed: downloadAndExtractZip,
                child: Text(
                  '경과 데이터 가져오기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (imageFiles.isNotEmpty)
                Column(
                  children: [
                    for (var i = 0; i < imageFiles.length; i++)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.file(
                              imageFiles[i],
                              width: 400,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            textData[i],
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 10),
                          Image.asset(
                            'assets/images/down_arrow.png',
                            width: 50.0,
                            height: 50.0,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
