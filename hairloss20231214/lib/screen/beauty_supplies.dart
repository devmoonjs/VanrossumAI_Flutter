import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:hairloss/screen/temp_result_for_supplies.dart';

class beautysupplies extends StatefulWidget {
  @override
  _BeautySuppliesState createState() => _BeautySuppliesState();
}

class _BeautySuppliesState extends State<beautysupplies> {
  late String symptom;

  @override
  void initState() {
    super.initState();
    String diagnosisResult = DiagnosisResult.getDiagnosisResult();
    symptom = diagnosisResult.isNotEmpty ? diagnosisResult : '양호';
  }
  Future<List<String>?> fetchCrawledData() async {

    var url = Uri.parse('http://192.168.35.4:5000/beauty_supplies?symptom=$symptom');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<String> lines = response.body.split('\n');

      List<String> products = [];
      String product = '';

      for (var line in lines) {
        if (line.trim().isNotEmpty) {
          product += line + '\n';
        } else {
          products.add(product.trim());
          product = '';
        }
      }

      if (product.isNotEmpty) {
        products.add(product.trim());
      }

      print(products.length); // 제품 수 출력

      return products;
    } else {
      throw Exception('데이터를 불러오는 데 실패했습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: FutureBuilder<List<String>?>(
            future: fetchCrawledData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('에러: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                List<String> products = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                          '$symptom관련 미용 용품',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length-1,
                        itemBuilder: (context, index) {
                          List<String> productInfo = products[index].split('\n');
                          if (productInfo.length >= 3) {
                            String imageUrl = productInfo[3];
                            String productLink = productInfo[2];

                            return InkWell(
                              onTap: () {
                                // 외부 쇼핑몰로 이동하는 로직
                                // productLink를 사용하여 외부 링크로 이동하는 코드
                                // 예를 들어, launch URL을 사용하여 외부 브라우저로 이동
                                launch(productLink);
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        imageUrl.isNotEmpty
                                            ? SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                            : SizedBox(width: 100, height: 100),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                productInfo[0],
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                '가격: ${productInfo[1]}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text('데이터가 없습니다'));
              }
            },
          ),
        )
    );
  }
}