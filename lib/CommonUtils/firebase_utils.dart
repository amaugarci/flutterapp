import 'package:upaychat/Apis/usersearchapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/Models/usersearchmodel.dart';
import 'package:upaychat/globals.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference firebaseRef = FirebaseDatabase.instance.reference();
final DatabaseReference _messageRef = firebaseRef.child("messages");
final DatabaseReference _statusRef = firebaseRef.child("status");

class FirebaseUtils {
  static bool isUpdate = true;

  static void readMessages(String c1, c2) {
    c1 = CommonUtils.fbUser(c1);
    c2 = CommonUtils.fbUser(c2);
    String userid = CommonUtils.getStrUserid();
    _messageRef.child(c1).child(c2).once().then((res) {
      Map data = Map.from(res.value);
      data.forEach((key, value) {
        Map tmp = Map.from(value);
        if (tmp.containsKey("sender") && tmp['sender'] != userid) {
          _messageRef.child(c1).child(c2).child(key).update({"sent": true, "read": true});
        }
      });
    });
  }

  static void receiveMessages(DataSnapshot querySnapshot, String userid) {
    isUpdate = !isUpdate;
    if (isUpdate) {
      return;
    }
    var data = querySnapshot.value;
    data.forEach((key, value) {
      if (value == null) return;
      var curUser = CommonUtils.idFromFB(key);

      value.forEach((k, v) {
        var curSubuser = CommonUtils.idFromFB(k);
        String childKey1 = "";
        String childKey2 = "";

        if (curUser == userid || curSubuser == userid) {
          childKey1 = curUser;
          childKey2 = curSubuser;
        } else {
          return;
        }
        v.forEach((k, v) {
          Map vTmp = Map.from(v);
          if (vTmp.containsKey("sender") && vTmp['sender'] != userid) {
            _messageRef.child(CommonUtils.fbUser(childKey1)).child(CommonUtils.fbUser(childKey2)).child(k).update({"sent": true});
          }
        });
      });
    });
  }

  static void updateState() {
    try {
      print("running timer => " + Globals.isInForeground.toString());
      if (!Globals.isInForeground) return;

      String userid = CommonUtils.getStrUserid();
      if (userid == null || userid == "0" || userid.isEmpty) return;

      _messageRef.once().then((result) => receiveMessages(result, userid));

      var now = DateTime.now();
      int status = CommonUtils.ONLINE_STATUS;
      if (Globals.typingDate != null) {
        var later = Globals.typingDate.add(const Duration(seconds: 10));
        bool checkDate = later.isAfter(now);
        if (checkDate) {
          status = CommonUtils.TYPING_STATUS;
        }
        print(now.toString() + " " + later.toString() + " " + checkDate.toString());
      }

      _statusRef.child(CommonUtils.fbUser(userid)).set(
        {
          'status': status,
          'date': now.toString(),
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<DataSnapshot> checkOnline(userid) {
    return _statusRef.child(CommonUtils.fbUser(userid)).once();
  }

  static Future<int> getUnreadMessages() async {
    String userid = CommonUtils.getStrUserid();
    if (userid == null) return Future.error("null");
    if (Globals.result == null) {
      UserSearchApi _searchApi = new UserSearchApi();
      UserSearchModel data = await _searchApi.search(roll: 'all');
      Globals.result = data.userList.map((e) => e.user_id.toString()).toList();
    }

    var querySnapshot = await _messageRef.once();
    var unreadMsgCount = 0;
    var data = querySnapshot.value;
    data.forEach((key, value) {
      if (value == null) return;
      var curUser = CommonUtils.idFromFB(key);
      try {
        if (Globals.result.where((element) => element == curUser).toList().length <= 0) {
          return;
        }
      } catch (e) {}

      value.forEach((k, v) {
        var curSubuser = CommonUtils.idFromFB(k);
        if (curUser != userid && curSubuser != userid) {
          return;
        }
        Map<dynamic, dynamic> vdata = Map.from(v);
        vdata.forEach((key, value) {
          if (value == null) return;
          try {
            Map item = Map.from(value);
            if (item['sender'] != userid && !item['read']) {
              unreadMsgCount += 1;
            }
          } catch (e) {}
        });
      });
    });
    return Future.value(unreadMsgCount);
  }

  static void deleteMessage(String c1, String c2) {
    _messageRef.child(CommonUtils.fbUser(c1)).child(CommonUtils.fbUser(c2)).remove();
  }

  static DatabaseReference getMessageRef(String c1, String c2) {
    return _messageRef.child(CommonUtils.fbUser(c1)).child(CommonUtils.fbUser(c2));
  }

  static void sendMessage(String c1, String c2, String c3, Map<String, Object> updateData) {
    _messageRef.child(CommonUtils.fbUser(c1)).child(CommonUtils.fbUser(c2)).child(c3).set(updateData);
  }

  static Stream<Event> onValueListener(String tmpChild1, String tmpChild2) {
    return _messageRef.child(CommonUtils.fbUser(tmpChild1)).child(CommonUtils.fbUser(tmpChild2)).onValue;
  }

  static Future<DataSnapshot> getMessage(String c1, String c2) {
    return _messageRef.child(CommonUtils.fbUser(c1)).child(CommonUtils.fbUser(c2)).get();
  }
}
