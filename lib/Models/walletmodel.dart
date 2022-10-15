class WalletModel {
  String status;
  String message;
  String balance;
  String paystackPubKey;
  String paystackSecKey;

  WalletModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      this.balance = obj["data"]["balance"].toString();
      this.paystackPubKey = obj["data"]["paystackPubKey"].toString();
      this.paystackSecKey = obj["data"]["paystackSecKey"].toString();
    }
  }
}
