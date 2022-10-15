class FaqModel {
  String status;
  String message;
  List<FaqData> faqlist;

  FaqModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.faqlist = (obj['data'] as List).map((i) => FaqData.fromJson(i)).toList();
  }
}

class FaqData {
  String id;
  String question;
  String answer;
  bool show = false;

  FaqData.fromJson(Map jsonMap)
      : id = jsonMap['id'].toString(),
        question = jsonMap['question'].toString(),
        answer = jsonMap['answer'].toString();
}
