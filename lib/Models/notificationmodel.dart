class NotificationModel {
  String status;
  String message;
  List<NotificationData> notificationlist;

  NotificationModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.notificationlist = (obj['data'] as List).map((i) => NotificationData.fromJson(i)).toList();
  }
}

class NotificationData {
  final int id;
  final String notification;
  final String timestamp;

  NotificationData(this.id, this.notification, this.timestamp);

  NotificationData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        notification = jsonMap['notification'].toString(),
        timestamp = jsonMap['created_at'].toString();
}
