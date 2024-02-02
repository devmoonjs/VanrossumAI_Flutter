import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hairloss/const/colors.dart';

class ResultPage extends StatelessWidget {
  final Uint8List imageBytes;

  ResultPage({required this.imageBytes});

  Future<void> _saveAsJpeg() async {
    final image = img.decodeImage(imageBytes);
    if (image != null) {
      final jpegImage = img.encodeJpg(image);

      // 파일 저장 권한을 요청
      final permissionStatus = await Permission.storage.request();

      if (permissionStatus.isGranted) {
        try {
          final result = await ImageGallerySaver.saveImage(Uint8List.fromList(jpegImage));
          if (result != null && result['isSuccess']) {
            // 이미지가 성공적으로 저장된 경우
            Fluttertoast.showToast(
              msg: '이미지가 저장되었습니다.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );

            // 이미지를 열기
            await OpenFile.open(result['filePath']);
          } else {
            // 이미지 저장 실패
            Fluttertoast.showToast(
              msg: '이미지를 저장하는 중에 오류가 발생했습니다(권한 오류).',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } catch (e) {
          // 이미지 저장 중에 오류 발생
          Fluttertoast.showToast(
            msg: '이미지를 저장하는 중에 오류가 발생했습니다(예외 발생).',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        // 권한이 거부된 경우
        Fluttertoast.showToast(
          msg: '파일 저장 권한이 거부되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }

  Future<void> _shareImage() async {
    // Uint8List 형식의 이미지를 JPEG 형식으로 변환
    final image = img.decodeImage(imageBytes);
    if (image != null) {
      final jpegImage = img.encodeJpg(image);

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/result.jpg';

      // JPEG 이미지를 파일로 저장
      final File file = File(filePath);
      await file.writeAsBytes(jpegImage);

      // 이미지를 공유
      await Share.shareFiles([filePath], text: '공유할 이미지');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('착용 결과'),
        backgroundColor: PRIMARY_COLOR,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.memory(imageBytes),
            SizedBox(height: 20),
            Row(
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
                  onPressed: _saveAsJpeg,
                  child: Text(
                    '저장',
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
                  onPressed: _shareImage,
                  child: Text(
                    '공유',
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
    );
  }
}
