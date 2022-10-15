class CardListModel {
  String status;
  String message;
  List<CardDetailData> cardlist;

  CardListModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.cardlist = (obj['data'] as List).map((i) => CardDetailData.fromJson(i)).toList();
  }
}

class CardDetailData {
  final int id;
  final String card_number;
  final String expire_date;
  final String cvv;
  final String card_holder;

  CardDetailData(this.id, this.card_number, this.expire_date, this.cvv, this.card_holder);

  CardDetailData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        card_number = jsonMap['card_number'].toString(),
        expire_date = jsonMap['expire_date'].toString(),
        cvv = jsonMap['cvv'].toString(),
        card_holder = jsonMap['card_holder'].toString();
}
