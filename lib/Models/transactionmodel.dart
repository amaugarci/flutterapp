class TransactionModel {
  String status;
  String message;
  List<TransactionData> transactionData;

  TransactionModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.transactionData = (obj['data'] as List).map((i) => TransactionData.fromJson(i)).toList();
  }
}

class TransactionData {
  int id;
  String amount;
  String from_id;
  String username;
  String to_userimage;
  String message;
  String privacy;
  String caption;
  int like;
  String likecount;
  String timestamp;
  bool showmycomment = false;
  List<CommentModel> commentlist;
  bool mine;

  TransactionData.fromJson(Map jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        amount = jsonMap['amount'].toString(),
        from_id = jsonMap['from_id'].toString(),
        username = jsonMap['username'].toString(),
        caption = jsonMap['caption'].toString(),
        privacy = jsonMap['privacy'].toString(),
        like = int.parse(jsonMap['like'].toString()),
        likecount = jsonMap['likecount'].toString(),
        timestamp = jsonMap['timestamp'].toString(),
        to_userimage = jsonMap['to_userimage'].toString(),
        message = jsonMap['message'],
        this.commentlist =
            (jsonMap['comments'] as List).map((i) => CommentModel.fromJson(i)).toList(),
        mine = jsonMap['mine'];
}

class CommentModel {
  String user_id;
  String username;
  String comment;
  String timestamp;

  CommentModel.fromJson(Map jsonMap)
      : user_id = jsonMap['user_id'].toString(),
        username = jsonMap['username'].toString(),
        comment = jsonMap['comment'].toString(),
        timestamp = jsonMap['timestamp'].toString();
}
