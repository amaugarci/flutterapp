import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upaychat/Apis/usersearchapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/usersearchmodel.dart';
import 'package:upaychat/globals.dart';

import 'request_money_file.dart';
import 'send_money_file.dart';

class SearchPeopleFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPeopleFileState();
  }
}

class SearchPeopleFileState extends State<SearchPeopleFile> {
  bool dataLoaded = false;
  List<UserList> extraList = [];
  List<UserList> allTopList = [];
  List<UserList> topList = [];
  UserList unregisteredUser;
  UserList extraUser;
  String mode;
  final TextEditingController userController = new TextEditingController();

  @override
  void initState() {
    _callAllUsersBeneficiary();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mode = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: _body(context)),
      ),
    );
  }

  Widget _renderLineAngle(double width) {
    return Container(
      height: 11,
      margin: EdgeInsets.symmetric(horizontal: 4),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(top: 4),
              height: 1,
              color: Colors.grey,
            ),
          ),
          Positioned(
            left: (width - 14) / 2,
            bottom: -7,
            child: Transform.rotate(
              angle: 45 / 180 * pi,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _renderComments() {
    final double DEVICE_WIDTH = MediaQuery.of(context).size.width;
    final double _WIDTH = DEVICE_WIDTH * 2 / 3;
    return Container(
      padding: EdgeInsets.fromLTRB(4, 2, 4, 4),
      margin: EdgeInsets.only(left: (DEVICE_WIDTH - _WIDTH) / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset.fromDirection(1, 3),
          ),
        ],
      ),
      width: _WIDTH,
      child: Container(
        child: Column(
          children: [
            _renderLineAngle(_WIDTH),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Type in phone#, username, email or choose an existing beneficiory below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Doomsday',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomUiWidgets.searchPeopleHeader(context, mode),
          dataLoaded
              ? Container(
                  margin: EdgeInsets.fromLTRB(18, 10, 18, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 6),
                          child: TextFormField(
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: userController,
                            style: TextStyle(
                              fontFamily: 'Doomsday',
                              fontSize: 18,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: MyColors.base_green_color),
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              ),
                              hintText: '@username, phone or email',
                              suffixIcon: IconButton(
                                onPressed: pickFromContacts,
                                icon: Icon(
                                  Icons.contacts,
                                  color: MyColors.base_green_color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _renderComments(),
                        SizedBox(height: 30),
                        if (unregisteredUser != null)
                          Card(
                            elevation: 4,
                            margin: EdgeInsets.only(top: 10),
                            color: MyColors.base_green_color,
                            shadowColor: MyColors.light_grey_color,
                            child: InkWell(
                              splashColor: Colors.white.withAlpha(150),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => mode == 'request'
                                            ? RequestMoneyFile(
                                                userId: -1,
                                                username: unregisteredUser.email ?? unregisteredUser.mobile,
                                              )
                                            : SendMoneyFile(
                                                userId: -1,
                                                username: unregisteredUser.email ?? unregisteredUser.mobile,
                                              )));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(80.0),
                                        child: Image.asset(
                                          CustomImages.default_profile_pic,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        (mode == 'request' ? "Request from " : "Send to ") + (unregisteredUser.email ?? unregisteredUser.mobile),
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (extraUser != null)
                          Card(
                            elevation: 4,
                            margin: EdgeInsets.only(top: 10),
                            color: MyColors.base_green_color,
                            shadowColor: MyColors.light_grey_color,
                            child: InkWell(
                              splashColor: Colors.white.withAlpha(150),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => mode == 'request'
                                            ? RequestMoneyFile(
                                                userId: extraUser.user_id,
                                                username: extraUser.username,
                                              )
                                            : SendMoneyFile(
                                                userId: extraUser.user_id,
                                                username: extraUser.username,
                                              )));
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(80.0),
                                        child: Image.asset(
                                          CustomImages.default_profile_pic,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        (mode == 'request' ? "Request from " : "Send to ") + extraUser.username,
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          color: MyColors.grey_color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Container(
                          child: ListView.builder(
                              itemCount: topList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Card(
                                      elevation: 4,
                                      child: InkWell(
                                        splashColor: MyColors.base_green_color.withAlpha(200),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => mode == 'request'
                                                      ? RequestMoneyFile(
                                                          userId: topList[index].user_id,
                                                          username: topList[index].firstname + ' ' + topList[index].lastname,
                                                        )
                                                      : SendMoneyFile(
                                                          userId: topList[index].user_id,
                                                          username: topList[index].firstname + ' ' + topList[index].lastname,
                                                        )));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(border: Border.all(color: MyColors.light_grey_divider_color)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    margin: EdgeInsets.all(5),
                                                    height: 40.0,
                                                    width: 40.0,
                                                    child: ClipRRect(
                                                      borderRadius: new BorderRadius.circular(60.0),
                                                      child: Image.network(
                                                        Globals.base_url + topList[index].profile_image,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context, child, loadingProgress) =>
                                                            (loadingProgress == null) ? child : Center(child: CircularProgressIndicator()),
                                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                                          CustomImages.default_profile_pic,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        topList[index].username ?? "",
                                                        style: TextStyle(
                                                          fontFamily: 'Doomsday',
                                                          color: MyColors.grey_color,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      Text(
                                                        topList[index].firstname + " " + topList[index].lastname,
                                                        style: TextStyle(
                                                          fontFamily: 'Doomsday',
                                                          color: MyColors.grey_color,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: MyColors.light_grey_divider_color,
                                      height: 1,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
              : CommonUtils.progressDialogBox(),
        ],
      ),
    );
  }

  void _callAllUsersBeneficiary() async {
    if (Globals.isOnline) {
      try {
        UserSearchApi _searchApi = new UserSearchApi();
        UserSearchModel result = await _searchApi.search();
        if (result.status == "true") {
          for (int i = 0; i < result.userList.length; i++)
            if (result.userList[i].is_extra)
              extraList.add(result.userList[i]);
            else
              allTopList.add(result.userList[i]);
          topList.addAll(allTopList);
          if (mounted) {
            setState(() {
              dataLoaded = true;
            });
          }
        } else if (mounted) {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        if (mounted) CommonUtils.errorToast(context, StringMessage.network_server_error);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void pickFromContacts() async {
    final PermissionStatus permissionStatus = await getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.of(context).pushNamed('/pickcontact', arguments: {
        'onContactPicked': (mobile) {
          userController.text = mobile;
          filterSearchResults(mobile);
        }
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void filterSearchResults(String query) {
    unregisteredUser = null;
    topList = [];
    extraUser = null;
    if (query.startsWith("0")) query = query.replaceFirst("0", "+234");
    if (allTopList.isNotEmpty) {
      if (query.isEmpty)
        topList.addAll(allTopList);
      else
        allTopList.forEach((model) {
          if ((query.startsWith("@") && model.username.toLowerCase() == query.substring(1).toLowerCase()) ||
              model.mobile.toLowerCase() == query.toLowerCase() ||
              model.email.toLowerCase() == query.toLowerCase()) topList.add(model);
        });
    }
    if (topList.isEmpty && query.isNotEmpty) {
      extraList.forEach((model) {
        if ((query.startsWith("@") && model.username.toLowerCase() == query.substring(1).toLowerCase()) ||
            model.mobile.toLowerCase() == query.toLowerCase() ||
            model.email.toLowerCase() == query.toLowerCase()) extraUser = model;
      });
      if (extraUser == null) {
        if (CommonUtils.validateEmail(query))
          unregisteredUser = new UserList(null, null, null, null, userController.text, null, null, false);
        else if (CommonUtils.validateMobile(query)) unregisteredUser = new UserList(null, null, null, null, null, userController.text, null, false);
      }
    }
    setState(() {});
  }

  Future<PermissionStatus> getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      final Map<Permission, PermissionStatus> permissionStatus = await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.restricted;
    } else {
      return permission;
    }
  }
}
