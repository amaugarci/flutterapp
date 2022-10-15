import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/globals.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class SettingFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingFileState();
  }
}

class SettingFileState extends State<SettingFile> {
  bool idVerified = true;
  @override
  void initState() {
    super.initState();
    checkID();
  }

  checkID() async {
    String idStatus = await CommonUtils.isIdAllowed();
    setState(() {
      idVerified = (idStatus == "true");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Settings & Help',
          style: TextStyle(
            fontFamily: 'Doomsday',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Text(
              '   Settings',
              style: TextStyle(
                fontFamily: 'Doomsday',
                color: MyColors.grey_color,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/editprofile");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                FontAwesome5Regular.user,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                  if (!idVerified)
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/identity_verification');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  AntDesign.idcard,
                                  color: MyColors.base_green_color,
                                  size: 30,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Identity Verification",
                                  style: TextStyle(
                                    fontFamily: 'Doomsday',
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  MaterialIcons.keyboard_arrow_right,
                                  color: MyColors.grey_color,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!idVerified)
                    Container(
                      color: MyColors.light_grey_divider_color,
                      height: 1,
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/banklist');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                MaterialCommunityIcons.credit_card_multiple_outline,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Bank & Cards",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/notification");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Ionicons.notifications_outline,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Notification",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/changepassword');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Ionicons.key_outline,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Change Password",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Text(
              '   Help',
              style: TextStyle(
                fontFamily: 'Doomsday',
                color: MyColors.grey_color,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/faq");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                AntDesign.questioncircleo,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "FAQ",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/contactus");
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Ionicons.chatbubbles_outline,
                                color: MyColors.base_green_color,
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Chat with us",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Globals.unreadMsgCount > 0
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.red[900],
                                  ),
                                  child: Text(
                                    Globals.unreadMsgCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Do you want to Logout?',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                            ),
                          ),
                          content: Text(
                            'We hate to see you leave...',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MyColors.base_green_color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MyColors.base_green_color,
                              ),
                              onPressed: () {
                                CommonUtils.logout(context);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(5, 8, 3, 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Sign out of Upaychat",
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  color: MyColors.base_green_color,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                MaterialIcons.keyboard_arrow_right,
                                color: MyColors.grey_color,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyColors.light_grey_divider_color,
                    height: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
