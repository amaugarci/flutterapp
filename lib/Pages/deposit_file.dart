import 'dart:convert';

import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:upaychat/Apis/addmoneytowalletapi.dart';
import 'package:upaychat/Apis/addupdatecarddetail.dart';
import 'package:upaychat/Apis/cardlistapi.dart';
import 'package:upaychat/Apis/stripepayapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Events/balanceevent.dart';
import 'package:upaychat/Models/addmoneytowalletmodel.dart';
import 'package:upaychat/Models/carddetaildata.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:upaychat/globals.dart';

class DepositFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DepositFileState();
  }
}

class DepositFileState extends State<DepositFile> {
  TextEditingController amountController = TextEditingController();
  double amount = 0.00;
  double totalAmount = 0.00;

  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isCard = false;

  final PaystackPlugin plugin = PaystackPlugin();
  int curIndex = 0;

  @override
  void initState() {
    curIndex = 0;
    print(PreferencesManager.getString(StringMessage.paystackPubKey));
    plugin.initialize(publicKey: PreferencesManager.getString(StringMessage.paystackPubKey));
    super.initState();
    _callCardListApi();
  }

  List<CardDetailData> cardList = [];

  void _callCardListApi() async {
    bool isError = false;
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, true);
        CardListApi _cardListApi = new CardListApi();
        CardListModel result = await _cardListApi.search();
        if (result.status == "true") {
          if (result.cardlist.isNotEmpty) {
            cardList = result.cardlist;
          } else {
            isError = true;
          }
        } else {
          isError = true;
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        print(e);
        isError = true;
      }
      Navigator.pop(context);
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
      isError = true;
    }
    if (isError) {
      cardList.clear();
    }
  }

  final CarouselController _controller = CarouselController();
  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      curIndex = index;
    });
  }

  Widget paymentDetail() {
    double fee = getFee();
    final double WIDTH = MediaQuery.of(context).size.width;

    return Container(
      width: WIDTH,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(
        color: MyColors.base_green_color,
        borderRadius: new BorderRadius.all(const Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ' Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Doomsday', color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                width: 170,
                child: Text(
                  StringMessage.naira + CommonUtils.toCurrency(amount),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          Container(height: 1, color: MyColors.light_grey_divider_color, margin: EdgeInsets.only(top: 15, bottom: 15)),
          Row(
            children: [
              Expanded(
                child: Text(
                  ' Charges',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Doomsday', color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                width: 170,
                child: Text(
                  StringMessage.naira + CommonUtils.toCurrency(fee),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          Container(height: 1, color: MyColors.light_grey_divider_color, margin: EdgeInsets.only(top: 15, bottom: 15)),
          Row(
            children: [
              Expanded(
                child: Text(
                  ' Total',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                width: 170,
                child: Text(
                  StringMessage.naira + CommonUtils.toCurrency(totalAmount),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getFee() {
    try {
      double fee = amount * 0.039 + 100;
      // if (amount >= 2500.0) fee = amount * 0.015 + 100;
      // if (fee > 2000) fee = 2000;
      // else if (amount > 5000.0) fee = 26.88;
      return fee;
    } catch (e) {}
    return 0;
  }

  var selectedCard;
  var map = new Map();

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '#### #### #### 0000', translator: <String, RegExp>{'0': RegExp(r'[0-9]'), '#': RegExp(r'[0-9•]')});
  final TextEditingController _expiryDateController = MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cvvCodeController = MaskedTextController(mask: '0000');

  FocusNode cvvFocusNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();
  FocusNode payButtonNode = FocusNode();

  CardDetailData getCard(id) {
    try {
      return cardList.firstWhere((element) => element.id == id);
    } catch (e) {}
    return new CardDetailData(0, '', '', '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Deposit',
          style: TextStyle(fontFamily: 'Doomsday', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (isCard) {
              setState(() {
                isCard = false;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: !isCard
          ? Container(
              height: double.infinity,
              color: MyColors.base_green_color_20,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      StringMessage.naira + CommonUtils.toCurrency(Globals.walletbalance),
                      style: TextStyle(
                        color: MyColors.base_green_color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '(Available Balance)',
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
                          fontSize: 24,
                        ),
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            String prev = text;
                            text = text.replaceAll(',', '');
                            text = text.replaceAll('.', '');
                            if (text.length >= 10) text = text.substring(0, 9);
                            double value = int.parse(text).toDouble() / 100;
                            if (value > 3000000) {
                              text = text.substring(0, 8);
                              value = int.parse(text).toDouble() / 100;
                            }
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
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                          primary: MyColors.base_green_color,
                          shape: CustomUiWidgets.basicGreenButtonShape(),
                        ),
                        onPressed: () {
                          try {
                            if (amountController.text.isEmpty) {
                              CommonUtils.errorToast(context, StringMessage.enter_amount);
                            } else {
                              amount = double.parse(amountController.text.replaceAll(',', ''));
                              if (amount < 500.0) {
                                CommonUtils.errorToast(context, StringMessage.enter_correct_amount);
                              } else {
                                double fee = getFee();

                                totalAmount = amount + fee;
                                totalAmount = (totalAmount * 100).round() / 100;
                                if (amount > 1000000) {
                                  CommonUtils.errorToast(context, 'You cannot add more than ${StringMessage.naira}1,000,000');
                                } else {
                                  // cardNumber = '';
                                  // expiryDate = '';
                                  // cvvCode = '';
                                  // cardHolderName = '';
                                  setState(() {
                                    isCard = true;
                                  });
                                }
                              }
                            }
                          } catch (e) {
                            print(e);
                            CommonUtils.errorToast(context, StringMessage.enter_correct_amount);
                          }
                        },
                        child: Text(
                          'Add money',
                          style: TextStyle(
                            fontFamily: 'Doomsday',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              FontAwesome.cc_visa,
                              size: 40,
                              color: MyColors.base_green_color,
                            ),
                          ),
                          Expanded(
                            child: Icon(
                              FontAwesome.cc_mastercard,
                              size: 40,
                              color: MyColors.base_green_color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: Container()),
                    Container(height: 100),
                    Text(
                      "3.9% + NGN 100",
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.grey_color,
                      ),
                    ),
                    Text(
                      "Processing fee",
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                        color: MyColors.grey_color,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Cards are charged in USD and settled in Naira by default, but you can also request to get settled in USD. Your bank will determine the exchanged rate.",
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        fontSize: 18,
                        color: MyColors.grey_color,
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      paymentDetail(),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
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
                                getCard(selectedCard).card_number != null && getCard(selectedCard).card_number.isNotEmpty
                                    ? CommonUtils.cardNumberHolder(getCard(selectedCard).card_number)
                                    : 'Add New Card',
                                style: TextStyle(
                                  fontFamily: 'Doomsday',
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              onSelected: (id) {
                                selectedCard = id;
                                var card = getCard(id);
                                _cardNumberController.text = CommonUtils.cardNumberHolder(card.card_number);
                                _expiryDateController.text = card.expire_date.toString();
                                _cvvCodeController.text = card.cvv.toString();
                                _cardHolderNameController.text = card.card_holder.toString();
                              },
                              child: Icon(Icons.arrow_drop_down),
                              itemBuilder: (context) =>
                                  cardList.map((card) => PopupMenuItem(value: card.id, child: Text(CommonUtils.cardNumberHolder(card.card_number)))).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _cardNumberController,
                        cursorColor: MyColors.base_green_color,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(expiryDateNode);
                        },
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          hintText: 'Card number',
                        ),
                        onChanged: (text) {
                          setState(() {
                            selectedCard = null;
                          });
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (String value) {
                          // Validate less that 13 digits +3 white spaces
                          if (value.isEmpty || value.length < 16) {
                            return "Please input a valid number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _expiryDateController,
                              cursorColor: MyColors.base_green_color,
                              focusNode: expiryDateNode,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(cvvFocusNode);
                              },
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  selectedCard = null;
                                });
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
                                hintText: 'Expiry MM/YY',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "Please input a valid date";
                                }

                                final DateTime now = DateTime.now();
                                final List<String> date = value.split(RegExp(r'/'));
                                final int month = int.parse(date.first);
                                final int year = int.parse('20${date.last}');
                                final DateTime cardDate = DateTime(year, month);

                                if (cardDate.isBefore(now) || month > 12 || month == 0) {
                                  return "Please input a valid date";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              obscureText: true,
                              focusNode: cvvFocusNode,
                              controller: _cvvCodeController,
                              cursorColor: MyColors.base_green_color,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(cardHolderNode);
                              },
                              onChanged: (text) {
                                setState(() {
                                  selectedCard = null;
                                });
                              },
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                                color: Colors.black,
                              ),
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
                                hintText: 'CVV',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (String value) {
                                if (value.isEmpty || value.length < 3) {
                                  return "Please input a valid CVV";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _cardHolderNameController,
                        cursorColor: MyColors.base_green_color,
                        focusNode: cardHolderNode,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          fontSize: 20,
                          color: Colors.black,
                        ),
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
                          hintText: 'Card holder',
                        ),
                        onChanged: (text) {
                          setState(() {
                            selectedCard = null;
                          });
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(payButtonNode);
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          focusNode: payButtonNode,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: MyColors.base_green_color,
                          ),
                          child: const Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Doomsday',
                              fontSize: 20,
                              package: 'flutter_credit_card',
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState.validate()) {
                              CommonUtils.errorToast(context, "Please input the correctly card");
                              return;
                            }
                            if (selectedCard != null && selectedCard > 0) {
                              CardDetailData card = cardList.firstWhere((element) => element.id == selectedCard);
                              if (card != null) {
                                _callPaymentGateway(totalAmount, amount, 'stripe', card, false);
                                return;
                              }
                            }
                            addCard((CardDetailData card) {
                              print("card");
                              _callPaymentGateway(totalAmount, amount, 'stripe', card, true);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void addCard(Function callback) async {
    var cardNumber = _cardNumberController.text;
    var cardHolderName = _cardHolderNameController.text;
    var expiryDate = _expiryDateController.text;
    var cvvCode = _cvvCodeController.text;

    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddUpdateCardDetailApi _addCardDetail = new AddUpdateCardDetailApi();
        CommonModel result;

        result = await _addCardDetail.search("addcard", '', cardNumber, cardHolderName, expiryDate, cvvCode);

        if (result.status == "true") {
          Map map = Map.from(result.data);
          var id = map.containsKey("id") ? map['id'] : 0;
          CardDetailData card = new CardDetailData(id, cardNumber, expiryDate, cvvCode, cardHolderName);
          print(card);
          callback(card);
          return;
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

  _callPaymentGateway(double totalAmount, double amount, String mode, CardDetailData cardData, bool isLoading) async {
    if (Globals.isOnline) {
      try {
        if (!isLoading) {
          CommonUtils.showProgressDialogComplete(context, false);
        }
        if (mode == 'stripe') {
          StripePayApiRequest _stripePayApi = new StripePayApiRequest();

          CommonModel result = await _stripePayApi.search(
              totalAmount, PreferencesManager.getString(StringMessage.email), cardData.card_number, cardData.expire_date, cardData.cvv);
          if (result.status == "true") {
            _showDialog(totalAmount, amount, mode);
          } else {
            Navigator.pop(context);
            CommonUtils.errorToast(context, result.message);
          }
        } else {
          Map accessCode = await createAccessCode();
          print(accessCode);
          print(PreferencesManager.getString(StringMessage.email));
          Charge charge = Charge()
            ..amount = (totalAmount * 100).round()
            ..accessCode = accessCode["data"]["access_code"]
            ..email = PreferencesManager.getString(StringMessage.email);
          CheckoutResponse response = await plugin.checkout(
            context,
            method: CheckoutMethod.card,
            charge: charge,
          );
          print(response);
          if (response.status) {
            _showDialog(totalAmount, amount, mode);
          } else {
            Navigator.pop(context);
            CommonUtils.errorToast(context, response.message);
          }
        }
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void _showDialog(double totalAmount, double amount, String mode) async {
    if (Globals.isOnline) {
      AddMoneyWalletApi _walletApi = new AddMoneyWalletApi();
      AddMoneyToWalletModel result = await _walletApi.search(totalAmount, amount, mode, "", "");
      if (result.status == "true") {
        Navigator.pop(context);
        setState(() {
          amountController.text = "";
          setState(() {
            Globals.walletbalance = double.parse(result.balance);
          });
        });
        EventHandler().send(BalanceEvent(''));
        CommonUtils.successToast(context, "Your payment has been successfully processed.");
        Navigator.pop(context);
      } else {
        CommonUtils.errorToast(context, result.message);
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  createAccessCode() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + PreferencesManager.getString(StringMessage.paystackSecKey)
    };
    print('paystackSecKey');
    print(headers);
    Map data = {
      "amount": (totalAmount * 100).round(),
      "email": PreferencesManager.getString(StringMessage.email),
    };
    String payload = json.encode(data);
    http.Response response = await http.post(
      Uri.parse('https://api.paystack.co/transaction/initialize'),
      headers: headers,
      body: payload,
    );
    return jsonDecode(response.body);
  }
}
