import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/addupdatecarddetail.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/carddetaildata.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:upaychat/globals.dart';

class AddCardFile extends StatefulWidget {
  final String from;
  final CardDetailData carddata;

  const AddCardFile({Key key, this.from, this.carddata}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddCardFileState();
  }
}

class AddCardFileState extends State<AddCardFile> {
  String status = "Continue";
  String msg = "Add a card";

  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  @override
  void initState() {
    if (widget.from == 'edit') {
      cardNumber = widget.carddata.card_number;
      expiryDate = widget.carddata.expire_date;
      cvvCode = widget.carddata.cvv;
      cardHolderName = widget.carddata.card_holder;
      status = "Update";
      msg = "Update card details";
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
          'Add a New Card',
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  _body(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          CreditCardWidget(
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            cardBgColor: MyColors.base_green_color,
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
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                primary: MyColors.base_green_color,
              ),
              child: Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                    package: 'flutter_credit_card',
                  ),
                ),
              ),
              onPressed: () {
                addCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void addCard() async {
    if (!formKey.currentState.validate()) {
      CommonUtils.errorToast(context, "Please input the correctly card");
      return;
    }
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddUpdateCardDetailApi _addCardDetail = new AddUpdateCardDetailApi();
        CommonModel result;
        if (widget.from == "edit") {
          // result = await _addCardDetail.search("updatecard", widget.carddata.id.toString(), cardNumber, cardHolderName, expiryDate, cvvCode);
        } else {
          result = await _addCardDetail.search("addcard", '', cardNumber, cardHolderName, expiryDate, cvvCode);
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
