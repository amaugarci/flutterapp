import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/notificationapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/notificationmodel.dart';
import 'package:upaychat/globals.dart';

class NotificationFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationFile> {
  List<NotificationData> notificationlist = [];
  bool isLoaded = false;
  bool isData = false;
  String msg;

  @override
  void initState() {
    _callNotificationData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Notification',
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
        margin: EdgeInsets.all(10),
        child: isLoaded
            ? Container(
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 2),
                child: isLoaded && isData
                    ? ListView.builder(
                        itemCount: notificationlist.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    notificationlist[index].notification,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    CommonUtils.timesAgoFeature(notificationlist[index].timestamp),
                                    style: TextStyle(
                                      color: MyColors.grey_color,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                    : Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
              )
            : CommonUtils.progressDialogBox());
  }

  void _callNotificationData() async {
    if (Globals.isOnline) {
      try {
        NotificationApi _notificationApi = new NotificationApi();

        NotificationModel result = await _notificationApi.search();
        if (result.status == "true") {
          if (result.notificationlist.isNotEmpty) {
            notificationlist = result.notificationlist;
            isData = true;
          } else {
            msg = "No data found";
          }
        } else {
          msg = result.message;
        }
        setState(() {
          isLoaded = true;
        });
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, e.toString());
        setState(() {
          isLoaded = true;
          msg = "No data found";
        });
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
