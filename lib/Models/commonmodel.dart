class CommonModel {
  String status;
  String message;
  dynamic data;
  CommonModel(String status, String message, dynamic data) {
    this.status = status;
    this.message = message;
    this.data = data;
  }
  CommonModel.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"].toString();
      this.message = obj["message"].toString();
      this.data = obj["data"];
    }
  }
}
