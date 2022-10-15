// class MyTransactionModel {
//   String status;
//   String message;
//   List<MyTransactionData> myTransactionData;

//   MyTransactionModel.map(dynamic obj) {
//     this.status = obj["status"].toString();
//     this.message = obj["message"].toString();
//     this.myTransactionData =
//         (obj['data'] as List).map((i) => MyTransactionData.fromJson(i)).toList();
//   }
// }

// class MyTransactionData {
//   int id;
//   String amount;
//   String timestamp;
//   String to_userimage;
//   String privacy;

//   MyTransactionData.fromJson(dynamic jsonMap)
//       : id = int.parse(jsonMap['id'].toString()),
//         amount = jsonMap['amount'].toString(),
//         timestamp = jsonMap['timestamp'].toString(),
//         to_userimage = jsonMap['to_userimage'].toString(),
//         message = jsonMap['message'].toString(),
//         privacy = jsonMap['privacy'].toString();
// }

class MyTransactionModel {
  String status;
  String message;
  List<MyTransactionData> myTransactionData;

  MyTransactionModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.myTransactionData = (obj['data'] as List).map((i) => MyTransactionData.fromJson(i)).toList();
  }
}

class MyTransactionData {
  Transaction tran;
  User user;

  MyTransactionData.fromJson(dynamic jsonMap)
      : tran = Transaction.fromJson(jsonMap['tran']),
        user = User.fromJson(jsonMap['user']);
}

class Transaction {
  int id;
  String user_id;
  String touser_id;
  String transaction_type;
  double amount;
  String caption;
  String privacy;
  int status;
  int likes;
  String created_at;

  Transaction.fromJson(dynamic jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        user_id = jsonMap['user_id'].toString(),
        touser_id = jsonMap['touser_id'].toString(),
        transaction_type = jsonMap['transaction_type'].toString(),
        amount = double.parse(jsonMap['amount'].toString()),
        caption = jsonMap['caption'].toString(),
        privacy = jsonMap['privacy'].toString(),
        status = int.parse(jsonMap['status'].toString()),
        likes = int.parse(jsonMap['likes'].toString()),
        created_at = jsonMap['created_at'].toString();
}

class User {
  int id;
  String avatar;
  String name;
  String firstname;
  String lastname;
  String username;
  String mobile;
  String email;
  String roll_id;
  String roll;
  String user_status;
  String currency_code;

  User.fromJson(dynamic jsonMap)
      : id = int.parse(jsonMap['id'].toString()),
        avatar = jsonMap['avatar'].toString(),
        name = jsonMap['name'].toString(),
        firstname = jsonMap['firstname'].toString(),
        lastname = jsonMap['lastname'].toString(),
        username = jsonMap['username'].toString(),
        mobile = jsonMap['avatar'].toString(),
        email = jsonMap['email'].toString(),
        roll_id = jsonMap['roll_id'].toString(),
        roll = jsonMap['roll'].toString(),
        user_status = jsonMap['user_status'].toString(),
        currency_code = jsonMap['currency_code'].toString();
}
