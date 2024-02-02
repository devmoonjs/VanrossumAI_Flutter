// 진단 결과를 이용해 미용용품을 추천하기 위한 getter setter
class DiagnosisResult {
  static String diagnosis = '';

  static String getDiagnosisResult() {
    print(diagnosis);
    return diagnosis;
  }

  static void setDiagnosisResult(String result) {
    diagnosis = result;
    print(diagnosis);
  }
}