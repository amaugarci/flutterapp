class BankListModel {
  String status;
  String message;
  List<BankDetailData> banklist;

  BankListModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.banklist = (obj['data'] as List).map((i) => BankDetailData.fromJson(i)).toList();
  }
}

class BankDetailData {
  final int id;
  final String bank_name;
  final String account_holder_name;
  final String account_no;

  BankDetailData(this.id, this.bank_name, this.account_holder_name, this.account_no);

  BankDetailData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        bank_name = jsonMap['bank_name'].toString(),
        account_holder_name = jsonMap['account_holder_name'].toString(),
        account_no = jsonMap['account_no'].toString();
}
