import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/mytransactionapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/mytransactionmodel.dart';
import 'package:upaychat/globals.dart';

class TransactionHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TransactionHistoryState();
  }
}

class TransactionHistoryState extends State<TransactionHistory> {
  bool isLoaded = false;
  List<MyTransactionData> myTransactionList = [];

  @override
  void initState() {
    super.initState();
    _callApiForPendingFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Transaction History',
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

  String number_format(double value, int count, String comma1, String comma2) {
    return value.toString();
  }

  String getMessage(MyTransactionData data) {
    String message = "";
    String userid = CommonUtils.getStrUserid();

    Transaction transaction = data.tran;
    User transUser = data.user;

    switch (transaction.transaction_type) {
      case 'pay':
        if (transaction.user_id == userid) {
          message = "You paid ₦" + number_format(transaction.amount, 2, '.', ',') + " to " + transUser.firstname + " " + transUser.lastname;
        } else {
          message = transUser.firstname + " " + transUser.lastname + " paid you ₦" + number_format(transaction.amount, 2, '.', ',');
        }
        break;

      case 'request':
        if (transaction.user_id == userid) {
          message = "You requested ₦" + number_format(transaction.amount, 2, '.', ',') + " from " + transUser.firstname + " " + transUser.lastname;
        } else {
          message = transUser.firstname + " " + transUser.lastname + " requested ₦" + number_format(transaction.amount, 2, '.', ',') + " from you";
        }
        break;
      case "withdrawal":
        message = "You transferred ₦" + number_format(transaction.amount, 2, '.', ',') + " to your bank";
        break;

      case "wallet":
        message = "You added ₦" + number_format(transaction.amount, 2, '.', ',') + " to your wallet";
        break;

      case "takeback":
        message = "You take back ₦" + number_format(transaction.amount, 2, '.', ',') + " from " + transUser.firstname + " " + transUser.lastname;
        break;
    }
    return message;
  }

  _body(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: isLoaded
            ? Container(
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 2, right: 2),
                child: myTransactionList.isNotEmpty
                    ? ListView.builder(
                        itemCount: myTransactionList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.only(top: 10),
                            child: InkWell(
                              splashColor: MyColors.base_green_color.withAlpha(200),
                              onTap: () {
                                Navigator.of(context).pushNamed('/transaction_detail', arguments: myTransactionList[index]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              getMessage(myTransactionList[index]),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        CommonUtils.timesAgoFeature(myTransactionList[index].tran.created_at),
                                        style: TextStyle(
                                          color: MyColors.grey_color,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(
                            fontFamily: 'Doomsday',
                            color: MyColors.grey_color,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              )
            : CommonUtils.progressDialogBox());
  }

  void _callApiForPendingFile() async {
    if (Globals.isOnline) {
      try {
        setState(() {
          isLoaded = false;
        });
        myTransactionList.clear();
        MyTransactionApi _myTransApi = new MyTransactionApi();
        MyTransactionModel result = await _myTransApi.search();
        if (result.status == "true") {
          if (result.myTransactionData.isNotEmpty) {
            myTransactionList.addAll(result.myTransactionData);
            setState(() {
              isLoaded = true;
            });
          } else {
            setState(() {
              isLoaded = true;
            });
          }
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
