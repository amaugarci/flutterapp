import 'MessageModel.dart';

class UserSearchModel {
  String status;
  String message;
  List<UserList> userList;

  UserSearchModel.map(dynamic obj) {
    this.status = obj["status"].toString();
    this.message = obj["message"].toString();
    this.userList =
        (obj['data'] as List).map((i) => UserList.fromJson(i)).toList();
  }
}

class UserList {
  final int user_id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String mobile;
  final String profile_image;
  final bool is_extra;
  MessageModel lastMessage;

  UserList(
    this.user_id,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.mobile,
    this.profile_image,
    this.is_extra,
  );

  UserList.fromJson(Map jsonMap)
      : user_id = int.parse(jsonMap['user_id'].toString()),
        firstname = jsonMap['firstname'].toString(),
        lastname = jsonMap['lastname'].toString(),
        username = jsonMap['username'].toString(),
        email = jsonMap['email'].toString(),
        mobile = jsonMap['mobile'].toString(),
        profile_image = jsonMap['profile_image'].toString(),
        is_extra = jsonMap['extra'];
}
