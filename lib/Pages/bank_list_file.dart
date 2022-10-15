import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/banklistapi.dart';
import 'package:upaychat/Apis/cardlistapi.dart';
import 'package:upaychat/Apis/deletebankapi.dart';
import 'package:upaychat/Apis/deletecardapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/banklistmodel.dart';
import 'package:upaychat/Models/carddetaildata.dart';
import 'package:upaychat/Pages/add_bank_file.dart';
import 'package:upaychat/Pages/add_card_file.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/globals.dart';

class BankListFile extends StatefulWidget {
  @override
  createState() {
    return BankListFileState();
  }
}

class BankListFileState extends State<BankListFile> {
  List<BankDetailData> banklist = [];
  List<CardDetailData> cardList = [];

  final _SHOW_BANKLIST = 0;
  final _SHOW_CARDLIST = 1;

  @override
  void initState() {
    _callBankListApi();
    _callCardListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  MaterialCommunityIcons.bank,
                  size: 35,
                ),
              ),
              Tab(
                  icon: Icon(
                MaterialCommunityIcons.credit_card,
                size: 35,
              )),
            ],
          ),
          backgroundColor: MyColors.base_green_color,
          centerTitle: true,
          title: new Text(
            'Banks & Cards',
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
                _callBankListApi();
                _callCardListApi();
              },
            ),
            // IconButton(
            //   icon: Icon(MaterialCommunityIcons.bank_plus),
            //   iconSize: 26,
            //   tooltip: 'Add Bank',
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankFile(from: 'add'))).then((data) {
            //       if (data != null) {
            //         _callBankListApi();
            //       }
            //     });
            //   },
            // ),
            // IconButton(
            //   icon: Icon(MaterialCommunityIcons.credit_card_plus),
            //   tooltip: 'Add Card',
            //   iconSize: 30,
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => AddCardFile(from: 'add'))).then((data) {
            //       if (data != null) {
            //         _callCardListApi();
            //       }
            //     });
            //   },
            // ),
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              color: MyColors.base_green_color_20,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(child: _body(context, _SHOW_BANKLIST)),
            ),
            Container(
              color: MyColors.base_green_color_20,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(child: _body(context, _SHOW_CARDLIST)),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderBankItem(BuildContext context, int index) {
    index = index - 1;
    final bool isAdd = index < 0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      elevation: 4,
      child: InkWell(
        splashColor: MyColors.base_green_color.withAlpha(200),
        onTap: () {
          if (isAdd) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankFile(from: 'add'))).then((data) {
              if (data != null) _callBankListApi();
            });
          }
        },
        onLongPress: () {
          if (!isAdd) {
            unlinkBank(banklist[index]);
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 14, 10, 10),
          child: isAdd
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        MaterialCommunityIcons.bank_plus,
                        size: 35,
                        color: MyColors.base_green_color,
                      ),
                      Text(
                        "Add New Bank",
                        style: TextStyle(
                          color: MyColors.base_green_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Doomsday',
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banklist[index].bank_name,
                              style: TextStyle(
                                color: MyColors.grey_color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Doomsday',
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    CommonUtils.bankNumberHolder(banklist[index].account_no),
                                    style: TextStyle(
                                      color: MyColors.grey_color,
                                      fontSize: 18,
                                      fontFamily: 'Doomsday',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    banklist[index].account_holder_name,
                                    style: TextStyle(
                                      color: MyColors.grey_color,
                                      fontSize: 16,
                                      fontFamily: 'Doomsday',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget renderCardItem(BuildContext context, int index) {
    index = index - 1;
    final bool isAdd = index < 0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      elevation: 4,
      child: InkWell(
        splashColor: MyColors.base_green_color.withAlpha(200),
        onTap: () {
          if (isAdd) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddCardFile(from: 'add'))).then((data) {
              if (data != null) _callCardListApi();
            });
          }
        },
        onLongPress: () {
          if (!isAdd) {
            unlinkCard(cardList[index]);
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 14, 10, 10),
          child: isAdd
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        MaterialCommunityIcons.credit_card_plus,
                        size: 35,
                        color: MyColors.base_green_color,
                      ),
                      Text(
                        "Add New Card",
                        style: TextStyle(
                          color: MyColors.base_green_color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Doomsday',
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CommonUtils.cardNumberHolder(cardList[index].card_number),
                              style: TextStyle(
                                color: MyColors.grey_color,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Doomsday',
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              cardList[index].card_holder,
                              style: TextStyle(
                                color: MyColors.grey_color,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Doomsday',
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Exp. Date: " + cardList[index].expire_date,
                                    style: TextStyle(
                                      color: MyColors.grey_color,
                                      fontSize: 18,
                                      fontFamily: 'Doomsday',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "CVV/CCV: " + "•••",
                                    // "CVV/CCV: " + cardList[index].cvv,
                                    style: TextStyle(
                                      color: MyColors.grey_color,
                                      fontSize: 18,
                                      fontFamily: 'Doomsday',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _body(BuildContext context, int _SHOW_TYPE) {
    final bool _isBank = _SHOW_TYPE == _SHOW_BANKLIST;
    var listData = _isBank ? banklist : cardList;

    return Container(
      alignment: Alignment.center,
      child: Container(
          child: Container(
              margin: EdgeInsets.only(top: 10, left: 8, right: 8),
              child: ListView.builder(
                itemCount: (listData?.length ?? 0) + 1,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: _isBank ? renderBankItem : renderCardItem,
              ))),
    );
  }

  void _callBankListApi() async {
    bool isError = false;
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, true);
        BankListApi _bankListApi = new BankListApi();
        BankListModel result = await _bankListApi.search();
        if (result.status == "true") {
          if (result.banklist.isNotEmpty) {
            banklist = result.banklist;
          }
        } else {
          isError = true;
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        isError = true;
        print(e);
      }
      Navigator.pop(context);
    } else {
      isError = true;
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
    if (isError) {
      setState(() {
        banklist.clear();
      });
    }
  }

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

  void unlinkBank(BankDetailData data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Confirm',
          style: TextStyle(color: Colors.black54, fontSize: 18, fontFamily: "Doomsday"),
        ),
        content: Text(
          'Do you want to unlink this bank ?',
          style: TextStyle(fontSize: 16, fontFamily: "Doomsday"),
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
              style: TextStyle(fontSize: 18, fontFamily: "Doomsday"),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: MyColors.base_green_color,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
              deleteBank(data);
            },
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 18, fontFamily: "Doomsday"),
            ),
          ),
        ],
      ),
    );
  }

  void unlinkCard(CardDetailData data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Confirm',
          style: TextStyle(color: Colors.black54, fontSize: 18, fontFamily: "Doomsday"),
        ),
        content: Text(
          'Do you want to unlink this card ?',
          style: TextStyle(fontSize: 16, fontFamily: "Doomsday"),
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
              style: TextStyle(fontSize: 18, fontFamily: "Doomsday"),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: MyColors.base_green_color,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
              deleteCard(data);
            },
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 18, fontFamily: "Doomsday"),
            ),
          ),
        ],
      ),
    );
  }

  deleteBank(BankDetailData data) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);

        DeleteBankApi _cardListApi = new DeleteBankApi();
        bool result = await _cardListApi.search(data.id);
        if (result) {
          CommonUtils.successToast(context, StringMessage.delete_success);
        } else {
          CommonUtils.errorToast(context, StringMessage.error);
        }
        _callBankListApi();
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  deleteCard(CardDetailData data) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);

        DeleteCardApi _cardListApi = new DeleteCardApi();
        bool result = await _cardListApi.search(data.id);
        if (result) {
          CommonUtils.successToast(context, StringMessage.delete_success);
        } else {
          CommonUtils.errorToast(context, StringMessage.error);
        }
        _callCardListApi();
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
