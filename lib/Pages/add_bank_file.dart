import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/Apis/addupdatebankdetail.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/banklistmodel.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/globals.dart';

class AddBankFile extends StatefulWidget {
  final String from;
  final BankDetailData bankdata;

  const AddBankFile({Key key, this.from, this.bankdata}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAddBankFile();
  }
}

class AddAddBankFile extends State<AddBankFile> {
  TextEditingController banknamecontroller = TextEditingController(),
      accountholdernamecontroller = TextEditingController(),
      accountnumbercontroller = TextEditingController(),
      confirmaccountnumbercontroller = TextEditingController();
  String status = "Continue";
  String msg = "Add a bank";

  @override
  void initState() {
    if (widget.from == 'edit') {
      banknamecontroller.text = widget.bankdata.bank_name;
      accountholdernamecontroller.text = widget.bankdata.account_holder_name;
      accountnumbercontroller.text = widget.bankdata.account_no;
      confirmaccountnumbercontroller.text = widget.bankdata.account_no;
      status = "Update";
      msg = "Update bank details";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Bank Account',
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
        child: SingleChildScrollView(child: _body(context)),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              margin: EdgeInsets.only(top: 30, bottom: 10, left: 5, right: 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Icon(
                    SimpleLineIcons.lock,
                    color: MyColors.base_green_color,
                    size: 90,
                  ),
                  SizedBox(height: 10),
                  Text(
                    msg,
                    style: TextStyle(
                      color: MyColors.grey_color,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Doomsday',
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    margin: const EdgeInsets.only(left: 12, top: 10, right: 12),
                    alignment: Alignment.center,
                    child: TextFormField(
                      cursorColor: MyColors.base_green_color,
                      controller: banknamecontroller,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        hintText: 'Bank Name',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    margin: const EdgeInsets.only(left: 12, top: 10, right: 12),
                    alignment: Alignment.center,
                    child: TextFormField(
                      cursorColor: MyColors.base_green_color,
                      controller: accountholdernamecontroller,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        hintText: 'Account Holder Name',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    margin: const EdgeInsets.only(left: 12, top: 10, right: 12),
                    alignment: Alignment.center,
                    child: TextFormField(
                      cursorColor: MyColors.base_green_color,
                      controller: accountnumbercontroller,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        hintText: 'Account Number',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    margin: const EdgeInsets.only(left: 12, top: 10, right: 12),
                    alignment: Alignment.center,
                    child: TextFormField(
                      cursorColor: MyColors.base_green_color,
                      controller: confirmaccountnumbercontroller,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        hintText: 'Confirm Account Number',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: FlatButton(
                      textColor: Colors.white,
                      highlightColor: MyColors.base_green_color_20,
                      padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                      splashColor: MyColors.base_green_color_20,
                      color: MyColors.base_green_color,
                      disabledColor: MyColors.base_green_color,
                      shape: CustomUiWidgets.basicGreenButtonShape(),
                      onPressed: () {
                        _validatefieldandaddorupdateaccount();
                      },
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Doomsday'),
                      ),
                    ),
                  ),
                ],
              )),
            )),
      ],
    ));
  }

  void _validatefieldandaddorupdateaccount() {
    try {
      String bankname = banknamecontroller.text;
      String accountholdername = accountholdernamecontroller.text;
      String accountnumber = accountnumbercontroller.text;
      String confirmaccountnumber = confirmaccountnumbercontroller.text;
      if (bankname.isEmpty || bankname == null) {
        CommonUtils.errorToast(context, "Enter bank name");
      } else if (accountholdername.isEmpty || accountholdername == null) {
        CommonUtils.errorToast(context, "Enter account holder name");
      } else if (accountnumber.isEmpty || accountnumber == null) {
        CommonUtils.errorToast(context, "Enter account number");
      } else if (confirmaccountnumber.isEmpty || confirmaccountnumber == null) {
        CommonUtils.errorToast(context, "Enter confirm account number");
      } else if (confirmaccountnumber != accountnumber) {
        CommonUtils.errorToast(context, "Account number not matched");
      } else {
        if (widget.from == 'edit') {
          _callApiForAddOrUpdate('updatebank');
        } else {
          _callApiForAddOrUpdate('addbank');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _callApiForAddOrUpdate(String status) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddUpdateBankDetailApi _addBankDetail = new AddUpdateBankDetailApi();
        CommonModel result;
        if (widget.from == "edit") {
          result = await _addBankDetail.search(
              status, widget.bankdata.id.toString(), banknamecontroller.text, accountholdernamecontroller.text, accountnumbercontroller.text);
        } else {
          result = await _addBankDetail.search(status, '', banknamecontroller.text, accountholdernamecontroller.text, accountnumbercontroller.text);
        }

        if (result.status == "true") {
          Navigator.pop(context);
          CommonUtils.successToast(context, result.message);
          Navigator.of(context).pop('yes');
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
}
