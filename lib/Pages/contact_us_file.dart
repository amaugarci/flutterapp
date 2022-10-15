import 'package:flutter/material.dart';
import 'package:upaychat/Apis/usersearchapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/firebase_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/usersearchmodel.dart';
import 'package:upaychat/ListItems/chatListItem.dart';
import 'package:upaychat/globals.dart';

class ContactUsFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactUsFileState();
  }
}

class ContactUsFileState extends State<ContactUsFile> {
  bool isLoaded = false;

  String userid;

  bool isCustomer;
  List<UserList> supporters = [];
  List<UserList> customers = [];

  Future<void> getSupporters() async {
    if (Globals.isOnline) {
      try {
        UserSearchApi _searchApi = new UserSearchApi();
        UserSearchModel result = await _searchApi.search(roll: 'supporter');
        supporters = [];
        if (result.status == "true") {
          for (int i = 0; i < result.userList.length; i++) {
            if (result.userList[i].user_id != CommonUtils.getUserid()) {
              supporters.add(result.userList[i]);
            }
          }
        } else {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, StringMessage.network_server_error);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  Future<void> getCustomers() async {
    if (Globals.isOnline) {
      try {
        UserSearchApi _searchApi = new UserSearchApi();
        UserSearchModel result = await _searchApi.search(roll: 'customer');
        customers = [];
        if (result.status == "true") {
          var users = result.userList;
          for (int i = 0; i < users.length; i++) {
            var snapshots = await FirebaseUtils.getMessage(users[i].user_id.toString(), userid);
            if (snapshots.exists) customers.add(users[i]);
          }
        } else {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, StringMessage.network_server_error);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  @override
  void initState() {
    userid = CommonUtils.getStrUserid();
    isCustomer = PreferencesManager.getString(StringMessage.roll) == 'customer';
    refresh();
    super.initState();
  }

  refresh() async {
    setState(() {
      isLoaded = false;
    });
    await (isCustomer ? getSupporters() : getCustomers());
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          isCustomer ? "Support" : 'Customers',
          style: TextStyle(
            fontFamily: 'Doomsday',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                refresh();
              }),
        ],
      ),
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    var listData = List.from(isCustomer ? supporters : customers);
    return isLoaded
        ? ListView.builder(
            itemCount: listData.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = listData[index];
              return ChatListItem(
                key: Key(item.user_id.toString()),
                data: item,
                isCustomer: isCustomer,
              );
            })
        : CommonUtils.progressDialogBox();
  }
}
