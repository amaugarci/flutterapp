class MessageModel {
  String id = "";
  String text = "";
  bool isRead = false;
  bool isSent = false;
  int unreadMsgCount = 0;
  int sender = 0;

  MessageModel(String id, String text, bool read, bool sent, int unread, int sender) {
    this.id = id;
    this.text = text;
    this.isRead = read;
    this.isSent = sent;
    this.unreadMsgCount = unread;
    this.sender = sender;
  }
}
