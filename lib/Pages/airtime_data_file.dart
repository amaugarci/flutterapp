import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/interswitch_utils.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class AirtimeDataFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AirtimeDataFileState();
  }
}

class AirtimeDataFileState extends State<AirtimeDataFile> {
  var _interswitch = InterswitchUtils.getInstance();
  List billers;
  var selectedBillerId;
  bool isAirtime = true;
  bool saveBeneficiary = true;
  var amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    try {
      CommonUtils.showProgressDialogComplete(context, true);

      Map tmpBillers = await _interswitch.getBillers();
      if (tmpBillers.containsKey("error")) {
        print(tmpBillers['error']);
        CommonUtils.errorToast(context, tmpBillers['error']['message'] ?? "Something went wrong");
      } else {
        List bill = tmpBillers['billers'];
        if (bill != null) {
          bill = bill.where((element) => element['categoryid'] == "4").toList();
          bill.sort((a, b) => a['billername'].toString().compareTo(b['billername']));
        }
        print(bill.toString());
        setState(() {
          billers = bill;
        });
      }
      Navigator.of(context).pop();
    } catch (err) {
      print(err);
      Navigator.of(context).pop();
      CommonUtils.errorToast(context, err.toString() ?? "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Airtime and Data',
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
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
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

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void pickFromContacts() async {
    final PermissionStatus permissionStatus = await getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.of(context).pushNamed('/pickcontact', arguments: {
        'onContactPicked': (mobile) {
          userController.text = mobile;
        }
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  final TextEditingController userController = new TextEditingController();
  List getProviders() {
    if (billers == null) return [];
    return billers.where((element) {
      String type = element['type'];
      if (isAirtime) {
        return type == "MO";
      }
      return element['type'] == "MP" || element['type'] == "";
    }).toList();
  }

  getImageUrl(var data) {
    String path;
    try {
      if (data.containsKey("mediumImageId"))
        path = data['mediumImageId'];
      else if (data.containsKey("smallImageId"))
        path = data['smallImageId'];
      else if (data.containsKey("largeImageId"))
        path = data['largeImageId'];
      else
        return null;

      path = "https://quickteller.sandbox.interswitchng.com/Content/Images/Downloaded/$path.png";
    } catch (e) {}
    if (path == null) path = "";
    return path;
  }

  var selectedBillOption;
  strMenuItem(var item) {
    try {
      String name = item['paymentitemname'];
      String currency = item['currencySymbol'];
      double tmpamount = (double.parse(item['amount']) / 100);
      if (tmpamount > 0) return name + " (" + currency + tmpamount.toString() + ")";
      return name;
    } catch (e) {
      return "";
    }
  }

  var billItems;
  getBillerItemDetail(var curBill) async {
    CommonUtils.showProgressDialogComplete(context, false);
    try {
      String billerid = curBill['billerid'];
      Map tmpDetail = await _interswitch.getBillerDetail(billerid);
      if (tmpDetail.containsKey("error")) {
        CommonUtils.errorToast(context, tmpDetail['error']['message']);
      } else {
        List paymentitems = tmpDetail['paymentitems'];
        setState(() {
          billItems = paymentitems;
          selectedBillerId = billerid;
        });
      }
    } catch (e) {
      CommonUtils.errorToast(context, e.toString());
    }
    Navigator.of(context).pop();
  }

  _renderOptions() {
    double amount = 0;
    List tmpBillItems = billItems;
    if (tmpBillItems == null || tmpBillItems.length <= 0) return Container();

    if (selectedBillOption == null) {
      selectedBillOption = tmpBillItems[0];
      amount = double.parse(selectedBillOption['amount']) / 100;
    }
    amountController.text = amount.toString();
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select an option",
            style: TextStyle(
              color: MyColors.base_green_color,
              fontWeight: FontWeight.bold,
              fontFamily: 'Doomsday',
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: MyColors.light_grey_divider_color,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              value: selectedBillOption['paymentitemid'],
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(
                color: MyColors.grey_color,
                fontSize: 18,
                fontFamily: 'Doomsday',
              ),
              onChanged: (String newValue) {
                setState(() {
                  selectedBillOption = tmpBillItems.singleWhere((element) => element['paymentitemid'] == newValue);
                  double amount = double.parse(selectedBillOption['amount']) / 100;
                  amountController.text = amount.toString();
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return tmpBillItems.map((var item) {
                  return Container(
                    width: MediaQuery.of(context).size.width - 90,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      strMenuItem(item),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList();
              },
              items: tmpBillItems == null
                  ? []
                  : tmpBillItems.map<DropdownMenuItem<String>>((var value) {
                      return DropdownMenuItem<String>(
                        value: value['paymentitemid'],
                        child: Text(strMenuItem(value)),
                      );
                    }).toList(),
            ),
          )
        ],
      ),
    );
  }

  var product_code;

  completePayment() {
    if (CommonUtils.isEmpty(userController, 0)) {
      CommonUtils.errorToast(context, "Please input the phone number");
      return;
    }
    if (selectedBillerId == null || (selectedBillerId as String).isEmpty) {
      CommonUtils.errorToast(context, "Please choose the Network Provider");
      return;
    }
    if (isAirtime) {
      if (CommonUtils.isEmpty(amountController, 0) || double.parse(amountController.text) <= 0) {
        CommonUtils.errorToast(context, "Please input the amount");
        return;
      }
    } else {
      if (selectedBillOption == null) {
        CommonUtils.errorToast(context, "Please choose the option");
        return;
      }
    }
    CommonUtils.showProgressDialogComplete(context, false);
    var amount;
    if (isAirtime) {
      amount = (double.parse(amountController.text) * 100).toString();
    } else {
      amount = selectedBillOption['amount'];
      product_code = selectedBillOption['paymentCode'];
    }
    var data = {"customerId": userController.text, "amount": amount, "paymentCode": product_code};
    _interswitch.billPayment(data).then((value) {
      print(value);
      Navigator.of(context).pop();
    }).catchError((error) {
      print(error);
      Navigator.of(context).pop();
    });
  }

  _body(BuildContext context) {
    List lstData = getProviders();
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mobile Number",
              style: TextStyle(
                color: MyColors.base_green_color,
                fontSize: 18,
                fontFamily: 'Doomsday',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyColors.light_grey_divider_color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          // filterSearchResults(value);
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
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.base_green_color),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Phone Number',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: pickFromContacts,
                    splashColor: MyColors.base_green_color_20,
                    child: Container(
                      width: 45,
                      height: 45,
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: MyColors.light_grey_divider_color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        MaterialCommunityIcons.account,
                        color: MyColors.base_green_color,
                        size: 35,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Select Network Provider",
              style: TextStyle(
                color: MyColors.base_green_color,
                fontFamily: 'Doomsday',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: lstData
                  .map<Widget>(
                    (e) => Expanded(
                      child: InkWell(
                        onTap: () {
                          if (isAirtime) {
                            setState(() {
                              selectedBillerId = e['billerid'];
                              product_code = e['productCode'];
                            });
                          } else {
                            getBillerItemDetail(e);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: selectedBillerId != e['billerid']
                              ? BoxDecoration()
                              : BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  border: Border.all(
                                    color: MyColors.base_green_color,
                                    width: 2,
                                  ),
                                ),
                          child: getImageUrl(e) != null
                              ? Image.network(
                                  getImageUrl(e),
                                )
                              : Text(
                                  e['billername'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.grey[300],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isAirtime = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: !isAirtime
                            ? BoxDecoration()
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                  color: MyColors.base_green_color,
                                  width: 2,
                                ),
                              ),
                        child: Text(
                          "Airtime",
                          style: TextStyle(
                            color: isAirtime ? MyColors.base_green_color : MyColors.grey_color,
                            fontFamily: 'Doomsday',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isAirtime = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: isAirtime
                            ? BoxDecoration()
                            : BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                  color: MyColors.base_green_color,
                                  width: 2,
                                ),
                              ),
                        child: Text(
                          "Data",
                          style: TextStyle(
                            color: isAirtime ? MyColors.grey_color : MyColors.base_green_color,
                            fontFamily: 'Doomsday',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Amount",
              style: TextStyle(
                color: MyColors.base_green_color,
                fontFamily: 'Doomsday',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            isAirtime
                ? Container(
                    padding: EdgeInsets.only(left: 4),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.base_green_color,
                        fontFamily: 'Doomsday',
                        fontSize: 30,
                      ),
                      controller: amountController,
                      keyboardType: TextInputType.number,
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
                  )
                : _renderOptions(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Container(
                child: FlatButton(
                  textColor: Colors.white,
                  highlightColor: MyColors.base_green_color_20,
                  splashColor: MyColors.base_green_color_20,
                  color: MyColors.base_green_color,
                  disabledColor: MyColors.base_green_color,
                  onPressed: completePayment,
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
