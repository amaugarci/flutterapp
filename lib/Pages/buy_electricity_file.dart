import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/interswitch_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class BuyElectricityFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BuyElectricityFileState();
  }
}

class BuyElectricityFileState extends State<BuyElectricityFile> {
  var billers = [];
  var _interswitch = InterswitchUtils.getInstance();
  var selectedBill;
  var billItems;
  int curShowPage = 0; //0: billers, 1: options, 2: payment, 3: complete
  var selectedBillOption;
  var amountController = TextEditingController();
  var billFieldsControllers = <String, TextEditingController>{};
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
          bill = bill.where((element) => element['categoryid'] == "1").toList();
          bill.sort((a, b) => a['billername'].toString().compareTo(b['billername']));
        }
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
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            if (curShowPage == 0)
              Navigator.of(context).pop();
            else
              setState(() {
                curShowPage -= 1;
              });
          },
        ),
        title: new Text(
          'Buy Electricity',
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
            icon: Icon(MaterialCommunityIcons.reload),
            iconSize: 26,
            tooltip: 'Refresh',
            onPressed: () {
              refresh();
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
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
    return path;
  }

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
          selectedBill = curBill;
          curShowPage = 1;
        });
      }
    } catch (e) {
      CommonUtils.errorToast(context, e.toString());
    }
    Navigator.of(context).pop();
  }

  Widget renderItem(billItem) {
    var image = getImageUrl(billItem);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MyColors.light_grey_color)),
      ),
      child: InkWell(
        splashColor: Colors.black.withAlpha(200),
        onTap: () {
          getBillerItemDetail(billItem);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                height: 35,
                width: 40,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: (image ?? ""),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Container(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        billItem['shortName'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  billItem['billername'] ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyColors.base_green_dark_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Doomsday',
                  ),
                ),
              )),
              Icon(
                MaterialIcons.keyboard_arrow_right,
                color: MyColors.grey_color,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderBillsList() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListView.builder(
        itemCount: billers?.length ?? 0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => renderItem(billers[index]),
      ),
    );
  }

  Widget _renderField(Map item, String key) {
    if (item == null || !item.containsKey(key) || item[key] == null || (item[key] as String).isEmpty) return Container();
    if (!billFieldsControllers.containsKey(key)) {
      billFieldsControllers[key] = new TextEditingController();
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item[key] ?? "",
            style: TextStyle(
              color: MyColors.base_green_color,
              fontWeight: FontWeight.bold,
              fontFamily: 'Doomsday',
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: MyColors.light_grey_divider_color,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: TextField(
              controller: billFieldsControllers[key],
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: item[key] ?? "",
              ),
            ),
          ),
        ],
      ),
    );
  }

  _renderCustomFields(Map item) {
    if (item == null) return Container();
    var customerField = ["customerfield1", "customerfield2", "customerfield3"];
    return Column(children: customerField.map((e) => _renderField(item, e)).toList());
  }

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

  continuePayment() {
    // billFieldsControllers
    // selectedBillOption
    String amount = amountController.text;
    if (amount == null || amount.isEmpty) {
      CommonUtils.errorToast(context, "Please input the amount");
      return;
    }
    bool isEmpty = false;
    billFieldsControllers.forEach((key, value) {
      if (value.text == null || value.text.isEmpty) {
        isEmpty = true;
      }
      return;
    });
    if (isEmpty) {
      CommonUtils.errorToast(context, "Please input corrent fields");
      return;
    }
    completePayment();
    // setState(() {
    //   curShowPage = 2;
    // });
  }

  _renderEditAmount() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Amount",
            style: TextStyle(
              color: MyColors.base_green_color,
              fontWeight: FontWeight.bold,
              fontFamily: 'Doomsday',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringMessage.naira,
                style: TextStyle(
                  fontSize: 30,
                  color: MyColors.base_green_color,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 4),
                width: 140,
                child: TextField(
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  completePayment() {
    // if (!formKey.currentState.validate()) {
    //   CommonUtils.errorToast(context, "Please input the correctly card");
    //   return;
    // }
    CommonUtils.showProgressDialogComplete(context, false);
    double amount = double.parse(amountController.text) * 100;
    var data = {"customerId": "0000000001", "amount": amount.toString(), "paymentCode": selectedBillOption['paymentCode']};
    billFieldsControllers.forEach((key, value) {
      if (key == "cusromterfield1" || key.toLowerCase() == "dstv number" || key.toLowerCase() == "phone number") {
        data['customerId'] = value.text.toString();
      }
      data[key] = value.text.toString();
    });
    _interswitch.billPayment(data).then((value) {
      print(value);
      Navigator.of(context).pop();
    }).catchError((error) {
      print(error);
      Navigator.of(context).pop();
    });
  }

  _renderBillOptions() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            color: MyColors.base_green_color_20,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 35,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: (getImageUrl(selectedBill) ?? ""),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Container(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          selectedBill['shortName'] ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Doomsday',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    selectedBill['billername'] ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Doomsday', color: Colors.grey.shade800),
                  ),
                )
              ],
            ),
          ),
          if (curShowPage == 1)
            Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Column(
                children: [
                  _renderCustomFields(selectedBill),
                  _renderOptions(),
                  _renderEditAmount(),
                  Container(
                    width: double.infinity,
                    child: Container(
                      child: FlatButton(
                        textColor: Colors.white,
                        highlightColor: MyColors.base_green_color_20,
                        splashColor: MyColors.base_green_color_20,
                        color: MyColors.base_green_color,
                        disabledColor: MyColors.base_green_color,
                        onPressed: continuePayment,
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Doomsday',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          StringMessage.naira + amountController.text,
                          style: TextStyle(
                            fontSize: 26,
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    themeColor: MyColors.base_green_color,
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card Holder',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
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
                          'Buy ' + StringMessage.naira + amountController.text,
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
        ],
      ),
    );
  }

  _renderBillComplete() {
    return Container();
  }

  void transactionSuccessCallback(payload) {
    final snackBar = SnackBar(
      content: Text(payload.toString()),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void transactionFailureCallback(payload) {
    final snackBar = SnackBar(
      content: Text(payload.toString()),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _body(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: (curShowPage == 0)
            ? _renderBillsList()
            : curShowPage == 1 || curShowPage == 2
                ? _renderBillOptions()
                : _renderBillComplete(),
      ),
    );
  }
}
