class AddMoneyToWalletModel {
  String status;
  String message;
  String balance;

  AddMoneyToWalletModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      if (status == "true") {
        this.balance = obj['data']['balance'].toString();
      }
    }
  }
}
