import 'package:dotted_line/dotted_line.dart';
import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/Apis/payapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Events/balanceevent.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/globals.dart';

class RequestMoneyFile extends StatefulWidget {
  final int userId;
  final String username;

  const RequestMoneyFile({Key key, this.userId, this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RequestMoneyFileState();
  }
}

class RequestMoneyFileState extends State<RequestMoneyFile> {
  bool isGeneratingCode = false;
  bool isPrivacyPublic = true;
  bool isPrivacyPrivate = false;

  TextEditingController amountController = TextEditingController(), descriptionController = TextEditingController();

  @override
  void initState() {
    if (PreferencesManager.getString(StringMessage.defaultprivacy) == "public") {
      isPrivacyPublic = true;
      isPrivacyPrivate = false;
    } else {
      isPrivacyPublic = false;
      isPrivacyPrivate = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.base_green_color_20,
        child: Column(
          children: [
            CustomUiWidgets.paymentrequestscreenHeader(context),
            Expanded(
              child: _body(context),
            ),
          ],
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: MyColors.light_grey_divider_color,
            height: 2,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 8, right: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.username,
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      color: MyColors.base_green_color,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      StringMessage.naira,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 4),
                      width: 110,
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 20,
                        ),
                        controller: amountController,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            String prev = text;
                            text = text.replaceAll(',', '');
                            text = text.replaceAll('.', '');
                            if (text.length >= 9) text = text.substring(0, 8);
                            double value = int.parse(text).toDouble() / 100;
                            text = CommonUtils.toCurrency(value);
                            if (prev != text) {
                              amountController.text = text;
                              amountController.selection = TextSelection.collapsed(offset: text.length);
                            }
                          }
                        },
                        inputFormatters: [amountValidator],
                        keyboardType: TextInputType.number,
                        cursorColor: MyColors.base_green_color,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "0.00",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: MyColors.light_grey_divider_color,
            height: 2,
          ),
          SizedBox(height: 5),
          Container(
            color: MyColors.light_grey_divider_color,
            height: 2,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 3, right: 3),
              child: TextFormField(
                cursorColor: MyColors.base_green_color,
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 18,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: ' What is it for?',
                ),
              ),
            ),
          ),
          Container(
            color: MyColors.light_grey_divider_color,
            height: 2,
          ),
          Container(
            height: 110,
            child: Column(
              children: [
                Container(
                  height: 20,
                  color: MyColors.base_green_color_20,
                  alignment: Alignment.centerRight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Entypo.globe,
                        size: 10,
                        color: MyColors.base_green_color,
                      ),
                      SizedBox(width: 2),
                      Text(
                        PreferencesManager.getString(StringMessage.defaultprivacy),
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: MyColors.grey_color,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: MyColors.base_green_color,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      primary: MyColors.base_green_color,
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (amountController.text.isEmpty || amountController.text == '0.00') {
                        CommonUtils.errorToast(context, StringMessage.enter_amount);
                      } else if (descriptionController.text.isEmpty) {
                        CommonUtils.errorToast(context, 'What is it for?');
                      } else {
                        _openPrivacyDialogBox();
                      }
                    },
                    child: Text(
                      'Request',
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openPrivacyDialogBox() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 320,
                width: 300,
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: SizedBox.expand(
                  child: Column(
                    children: [
                      Text(
                        "Who can see this?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isPrivacyPublic = true;
                                isPrivacyPrivate = false;
                                PreferencesManager.setString(StringMessage.defaultprivacy, 'public');
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Entypo.globe,
                                  size: 30,
                                  color: MyColors.base_green_color,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Public",
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          decoration: TextDecoration.none,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Visible to everyone on the internet",
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          decoration: TextDecoration.none,
                                          color: Colors.black45,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                isPrivacyPublic
                                    ? Icon(
                                        MaterialIcons.check,
                                        color: MyColors.base_green_color,
                                        size: 30,
                                      )
                                    : SizedBox(width: 25),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.black,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isPrivacyPublic = false;
                                isPrivacyPrivate = true;
                                PreferencesManager.setString(StringMessage.defaultprivacy, 'private');
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  SimpleLineIcons.lock,
                                  color: MyColors.base_green_color,
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Private",
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          decoration: TextDecoration.none,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        "Visible to sender and recipient only",
                                        style: TextStyle(
                                          fontFamily: 'Doomsday',
                                          decoration: TextDecoration.none,
                                          color: Colors.black45,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                isPrivacyPrivate
                                    ? Icon(
                                        MaterialIcons.check,
                                        color: MyColors.base_green_color,
                                        size: 30,
                                      )
                                    : SizedBox(width: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                          primary: MyColors.base_green_color,
                          shape: CustomUiWidgets.basicGreenButtonShape(),
                        ),
                        onPressed: processPayment,
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: 'Doomsday',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  void processPayment() {
    if (isPrivacyPrivate) {
      _callApiForPay("private");
    } else {
      _callApiForPay("public");
    }
  }

  void _callApiForPay(String privacy) async {
    if (Globals.isOnline) {
      Navigator.pop(context);
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        PayApiRequest _payApi = new PayApiRequest();
        String username = widget.username;
        if (widget.userId == -1 && username.startsWith("0") && CommonUtils.validateMobile(username)) username = username.replaceFirst("0", "+234");
        CommonModel result =
            await _payApi.search(amountController.text.replaceAll(',', ''), privacy, descriptionController.text, widget.userId.toString(), username, 'request');
        if (result.status == "true") {
          Navigator.pop(context);
          Navigator.pop(context);
          EventHandler().send(BalanceEvent('trans'));

          String msg =
              'You requested ${StringMessage.naira + CommonUtils.toCurrency(double.parse(amountController.text.replaceAll(',', '')))} \n from ${widget.username}';
          CommonUtils.successToast(context, msg);
        } else {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
