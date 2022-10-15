import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/addupdatebankdetail.dart';
import 'package:upaychat/Apis/banklistapi.dart';
import 'package:upaychat/Apis/withdrawamountreqapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Events/balanceevent.dart';
import 'package:upaychat/Models/addmoneytowalletmodel.dart';
import 'package:upaychat/Models/banklistmodel.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/globals.dart';

class Withdraw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WithdrawFileState();
  }
}

class WithdrawFileState extends State<Withdraw> {
  TextEditingController amountController = TextEditingController();
  TextEditingController bankAccountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController confirmAccountController = TextEditingController();
  double amount = 0.00;
  String bankAccount = '';
  String bankName = '';
  String accountNumber = '';
  String confirmAccountNumber = '';
  bool isNew = true;
  List<BankDetailData> banklist = [];
  bool isLoaded = false;
  bool showMsg = false;
  String msg;

  @override
  void initState() {
    _callBankListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Withdraw',
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
        height: double.infinity,
        color: MyColors.base_green_color_20,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                StringMessage.naira + CommonUtils.toCurrency(Globals.walletbalance),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.base_green_color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(Available Balance)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  color: MyColors.grey_color,
                  fontSize: 16,
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(8, 13, 5, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: amountController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                  ),
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 10), // control your hints text size
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    hintText: "0.00",
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                  'Select Bank Account',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    color: MyColors.grey_color,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(8, 13, 5, 0),
                padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(color: MyColors.grey_color, width: 2.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        bankAccount == '' ? 'Add New Bank Account' : bankAccount,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      onSelected: (bank) {
                        // bankAccountController.text = bank.account_no;
                        bankNameController.text = bank.bank_name;
                        accountNumberController.text = bank.account_no;
                        confirmAccountController.text = bank.account_no;

                        setState(() {
                          isNew = false;
                          bankAccount = bank.account_no;
                          bankName = bank.bank_name;
                          confirmAccountNumber = bank.account_no;
                          accountNumber = bank.account_no;
                        });
                      },
                      child: Icon(Icons.arrow_drop_down),
                      itemBuilder: (context) => banklist.map((bank) => PopupMenuItem(value: bank, child: Text(bank.account_no))).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // color: Colors.white,
                margin: EdgeInsets.fromLTRB(8, 13, 5, 0),
                child: TextField(
                  readOnly: !isNew,
                  textAlign: TextAlign.left,
                  controller: bankNameController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                    height: 0.8,
                  ),
                  onChanged: (text) {
                    bankName = text;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    hintText: "Bank Name",
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(8, 13, 5, 0),
                child: TextField(
                  readOnly: !isNew,
                  textAlign: TextAlign.left,
                  controller: accountNumberController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                    height: 0.8,
                  ),
                  onChanged: (text) {
                    accountNumber = text;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 10),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    hintText: "Account Number",
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(8, 13, 5, 0),
                child: TextField(
                  readOnly: !isNew,
                  textAlign: TextAlign.left,
                  controller: confirmAccountController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                    height: 0.8,
                  ),
                  onChanged: (text) {
                    confirmAccountNumber = text;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    hintText: "Confirm Account Number",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25, left: 10, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                    primary: MyColors.base_green_color,
                    shape: CustomUiWidgets.basicGreenButtonShape(),
                    minimumSize: Size(double.infinity, 30),
                  ),
                  onPressed: () {
                    try {
                      if (amountController.text.isEmpty) {
                        CommonUtils.errorToast(context, StringMessage.enter_amount);
                      } else {
                        double withdrawAmount = double.parse(amountController.text.replaceAll(',', ''));
                        if (withdrawAmount < 500.0) {
                          CommonUtils.errorToast(context, StringMessage.enter_correct_amount);
                        } else {
                          if (withdrawAmount > Globals.walletbalance) {
                            CommonUtils.errorToast(context, "Cannot request more than wallet balance");
                          } else {
                            if (bankName == '') {
                              CommonUtils.errorToast(context, "Please enter bank name");
                            } else if (accountNumber == '') {
                              CommonUtils.errorToast(context, "Please enter account number");
                            } else if (confirmAccountNumber == '') {
                              CommonUtils.errorToast(context, "Please confirm account number");
                            } else if (accountNumber != confirmAccountNumber) {
                              CommonUtils.errorToast(context, "Account Number not match.");
                            } else {
                              if (isNew) {
                                _callApiForAddOrUpdate('addbank', withdrawAmount);
                              } else {
                                _requestForPayment(withdrawAmount);
                              }
                            }
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                      CommonUtils.errorToast(context, StringMessage.enter_correct_amount);
                    }
                  },
                  child: Text(
                    'Withdraw',
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callBankListApi() async {
    if (Globals.isOnline) {
      try {
        setState(() {
          banklist.clear();
          isLoaded = false;
          showMsg = false;
        });
        BankListApi _bankListApi = new BankListApi();
        BankListModel result = await _bankListApi.search();
        if (result.status == "true") {
          if (result.banklist.isNotEmpty) {
            banklist = result.banklist;
          } else {
            setState(() {
              showMsg = true;
              msg = "No data found";
            });
          }
          setState(() {
            isLoaded = true;
          });
        } else {
          setState(() {
            isLoaded = true;
            showMsg = true;
            msg = result.message;
          });
        }
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, e.toString() ?? "Someting went wrong");
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void _callApiForAddOrUpdate(String status, double withdrawAmount) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddUpdateBankDetailApi _addBankDetail = new AddUpdateBankDetailApi();
        CommonModel result;
        result = await _addBankDetail.search(status, '', bankName, '', accountNumber);

        if (result.status == "true") {
          Navigator.pop(context);
          CommonUtils.successToast(context, result.message);
          _requestForPayment(withdrawAmount);
          // Navigator.of(context).pop('yes');
        } else {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        CommonUtils.errorToast(context, StringMessage.network_server_error);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void _requestForPayment(double withdrawAmountPayment) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        WithdrawAmountRequestApi _request = new WithdrawAmountRequestApi();
        AddMoneyToWalletModel result = await _request.search(withdrawAmountPayment.toString());
        Navigator.pop(context);
        if (result.status == "true") {
          setState(() {
            amountController.text = "";
            setState(() {
              Globals.walletbalance = double.parse(result.balance);
            });
          });
          EventHandler().send(BalanceEvent('wallet'));
          CommonUtils.successToast(context, result.message);
          Navigator.pop(context);
        } else {
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        Navigator.pop(context);
        CommonUtils.errorToast(context, StringMessage.network_server_error);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
