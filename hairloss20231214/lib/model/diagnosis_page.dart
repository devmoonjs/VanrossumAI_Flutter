import 'dart:io';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:hairloss/const/colors.dart';

class DiagnosisPage extends StatelessWidget {
  final String diagnosisResult;
  final File? image;
  final List<String> symptomList1;
  final List<String> symptomList2;
  final List<String> symptomList3;
  final List<String> symptomList4;
  final List<String> symptomList5;
  final List<String> symptomList6;
  final List<String> label = ['미세각질', '피지과다', '모낭사이홍반', '모낭홍반농포', '비듬', '탈모'];
  final List<String> label2 = ['양호', '경증', '중등도', '중증'];

  DiagnosisPage(
      this.diagnosisResult,
      this.image,
      this.symptomList1,
      this.symptomList2,
      this.symptomList3,
      this.symptomList4,
      this.symptomList5,
      this.symptomList6,
      );

  List<Segment> createSegments(List<String> symptomList) {
    return [
      Segment(value: int.parse(symptomList[0]), color: Colors.green, label: Text("양호"), valueLabel: Text("${symptomList[0]}%")),
      Segment(value: int.parse(symptomList[1]), color: Colors.yellow, label: Text("경증"), valueLabel: Text("${symptomList[1]}%")),
      Segment(value: int.parse(symptomList[2]), color: Colors.orange, label: Text("중등도"), valueLabel: Text("${symptomList[2]}%")),
      Segment(value: int.parse(symptomList[3]), color: Colors.red, label: Text("중증"), valueLabel: Text("${symptomList[3]}%")),
    ];
  }

  findToplabel2(List<String> symptomList) {
    int maxIndex = 0;
    int maxValue = int.parse(symptomList[0]);

    for (int i = 1; i < symptomList.length; i++) {
      int currentValue = int.parse(symptomList[i]);

      if (currentValue > maxValue) {
        maxValue = currentValue;
        maxIndex = i;
      }
    }

    return maxIndex;
  }
  @override
  Widget build(BuildContext context) {

    final List<int> toplabel2 = [
      findToplabel2(symptomList1),
      findToplabel2(symptomList2),
      findToplabel2(symptomList3),
      findToplabel2(symptomList4),
      findToplabel2(symptomList5),
      findToplabel2(symptomList6),
    ];

    final List<List<Segment>> allSegments = [
      createSegments(symptomList1),
      createSegments(symptomList2),
      createSegments(symptomList3),
      createSegments(symptomList4),
      createSegments(symptomList5),
      createSegments(symptomList6),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("진단결과"),
        backgroundColor: PRIMARY_COLOR,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: (label.length * 2) + 4, // 레이블과 프로그레스 바, 이미지, 진단 텍스트, 선을 모두 출력하기 위해 +4
        itemBuilder: (context, index) {
          if (index == 0) {
            // 첫 번째 항목: 이미지 출력
            if (image != null) {
              return Transform.scale(
                scale: 0.9, // 10% 축소
                child: Image.file(
                  image!,
                  width: 400,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              );
            }
          } else if (index == 1) {
            // 두 번째 항목: 이미지와 진단 텍스트 사이에 선 그리기
            return Divider(
              height: 2, // 선의 두께 설정
              color: Colors.grey,
            );
          } else if (index == 2) {
            // 세 번째 항목: 최종 진단 텍스트 출력
            return Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '최종진단: $diagnosisResult',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          } else if (index == 3) {
            // 네 번째 항목: 진단 텍스트와 '미세각질' 사이에 선 그리기
            return Divider(
              height: 2, // 선의 두께 설정
              color: Colors.grey,
            );
          } else {
            // 나머지 항목: 레이블과 프로그레스 바 출력
            final adjustedIndex = index - 4;
            if (adjustedIndex % 2 == 0) {
              // 짝수 인덱스일 때 레이블 출력
              final labelIndex = adjustedIndex ~/ 2;
              final topLabelIndex = toplabel2[labelIndex]; // toplabel2의 해당 인덱스 값을 가져옴
              final combinedLabel = "${label[labelIndex]}: ${label2[topLabelIndex]}"; // label과 label2 값을 합침
              return Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                child: Text(
                  combinedLabel, // 합쳐진 레이블 출력
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              // 홀수 인덱스일 때 프로그레스 바 출력
              final progressBarIndex = (adjustedIndex - 1) ~/ 2;
              return Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                child: Column(
                  children: [
                    PrimerProgressBar(segments: allSegments[progressBarIndex]),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}