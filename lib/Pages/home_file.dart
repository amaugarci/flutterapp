import 'package:badges/badges.dart';
import 'package:eventhandler/eventhandler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upaychat/Apis/addmycommentapi.dart';
import 'package:upaychat/Apis/mylikedislikeapi.dart';
import 'package:upaychat/Apis/transactionapi.dart';
import 'package:upaychat/Apis/wallet_api.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Events/balanceevent.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/Models/transactionmodel.dart';
import 'package:upaychat/Models/walletmodel.dart';
import 'package:upaychat/Pages/mobile_number_file.dart';
import 'package:upaychat/globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class HomeFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeFileState();
  }
}

class HomeFileState extends State<HomeFile> {
  int segmentedControlValue = 0;
  bool publicPressed = true, privatePressed = false, myTransPressed = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  List<TransactionData> transList = [];
  bool isLoading = true;
  String userid;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    EventHandler().unsubscribe(_onBalanceEventCallback);
    super.dispose();
  }

  @override
  void initState() {
    userid = CommonUtils.getStrUserid();
    _getData();

    EventHandler().subscribe(_onBalanceEventCallback);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        print('Initial FCM!');
        print(message.messageId);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        print('FCM!');
        print(notification.title);
        print(notification.body);
        _getData();
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannel.id,
                notificationChannel.name,
                notificationChannel.description,
                icon: 'notification_icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.messageId);
    });

    super.initState();
  }

  void _onBalanceEventCallback(BalanceEvent event) {
    switch (event.mode) {
      case '':
        setState(() {});
        break;
      case 'wallet':
        _callMyWalletApi();
        break;
      case 'trans':
        _callTransactionApi(false);
        break;
      default:
        _getData();
    }
  }

  Future<void> _getData() async {
    _callTransactionApi(true);
    _callMyWalletApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: MyColors.base_green_color_20,
        height: double.infinity,
        width: double.infinity,
        child: _body(context),
      ),
      drawer: homeNavigationDrawer(context, scaffoldState),
    );
  }

  checkIdentity(Function callback) async {
    CommonUtils.showProgressDialogComplete(context, false);
    String allowed = await CommonUtils.isIdAllowed();
    Navigator.of(context).pop();
    if (allowed != "true") {
      CommonUtils.errorToast(context, allowed);
      return;
    }
    if (callback != null) callback();
  }

  Container homeNavigationDrawer(BuildContext context, GlobalKey<ScaffoldState> scaffoldState) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var _phoneVerified = CommonUtils.phoneVerified();
    var avatar;
    var tmpAvatar = PreferencesManager.getString(StringMessage.profileimage);
    if (tmpAvatar != null && tmpAvatar.isNotEmpty) {
      avatar = Globals.base_url + tmpAvatar;
    }
    return Container(
      width: MediaQuery.of(context).size.width * .7,
      height: double.infinity,
      color: MyColors.navigation_bg_color,
      child: Padding(
        padding: EdgeInsets.only(left: 10, top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed("/editprofile");
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 80.0,
                              width: 80.0,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(60.0),
                                child: avatar == null
                                    ? Image.asset(
                                        CustomImages.default_profile_pic,
                                        fit: BoxFit.cover,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: avatar,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Image.asset(
                                          CustomImages.default_profile_pic,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: MyColors.base_green_color,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Entypo.camera,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      PreferencesManager.getString(StringMessage.username),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        color: MyColors.grey_color,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      PreferencesManager.getString(StringMessage.email),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Doomsday',
                        color: MyColors.grey_color,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              StringMessage.naira + CommonUtils.toCurrency(Globals.walletbalance),
                              style: TextStyle(
                                color: MyColors.grey_color,
                                fontSize: 18,
                                decoration: _phoneVerified ? TextDecoration.none : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              checkIdentity(() {
                                Navigator.of(context).pushNamed('/deposit');
                              });
                            },
                            child: Text(
                              "Deposit",
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                color: MyColors.base_green_color,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Foundation.home,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: MyColors.base_green_color,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  checkIdentity(() {
                    checkPhoneAction('/searchpeople', 'send', true);
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        AntDesign.form,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Send Money',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  checkIdentity(() {
                    checkPhoneAction('/searchpeople', 'request', true);
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Foundation.download,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Request Money',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  CommonUtils.errorToast(context, "Comming soon");
                  // Navigator.pop(context);
                  // Navigator.of(context).pushNamed('/airtime_data', arguments: 'request');
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        AntDesign.mobile1,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Airtime & Data',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  CommonUtils.errorToast(context, "Comming soon");
                  // Navigator.pop(context);
                  // Navigator.of(context).pushNamed('/buy_electricity', arguments: 'request');
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Fontisto.lightbulb,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Buy Electricity',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  CommonUtils.errorToast(context, "Comming soon");
                  // Navigator.pop(context);
                  // Navigator.of(context).pushNamed('/pay_bills', arguments: 'request');
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.money,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Pay Bills',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/transaction");
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        FontAwesome.history,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  checkIdentity(() {
                    checkPhoneAction('/withdraw', '', true);
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        MaterialCommunityIcons.bank_transfer_out,
                        color: MyColors.grey_color,
                        size: 35,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Withdraw',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/notification");
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        Ionicons.notifications_outline,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  checkPhoneAction('/pending', '', true);
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        MaterialIcons.pending_actions,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Pending',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      if (Globals.unreadPending > 0)
                        Container(
                          width: 18,
                          height: 18,
                          padding: EdgeInsets.all(2.0),
                          margin: EdgeInsets.only(left: 0, bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.red[900],
                          ),
                          child: Text(
                            Globals.unreadPending.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed("/setting");
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(
                        MaterialCommunityIcons.cog_sync_outline,
                        color: MyColors.grey_color,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Settings & Help',
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      if (Globals.unreadMsgCount > 0)
                        Container(
                          width: 18,
                          height: 18,
                          padding: EdgeInsets.all(2.0),
                          margin: EdgeInsets.only(left: 0, bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.red[900],
                          ),
                          child: Text(
                            Globals.unreadMsgCount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, left: 40),
                height: 1,
                color: MyColors.grey_color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getData(type) {
    //type=> 0:public, 1: private, 2: mine
    if (type == 0) {
      return transList.where((element) => element.privacy == "public").toList();
    } else if (type == 1) {
      return transList.where((element) => element.privacy == "private").toList();
    } else if (type == 2) {
      return transList.where((element) => element.mine).toList();
    }
    return [];
  }

  _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _createHeader(context),
          _createOptions(context),
          isLoading
              ? CommonUtils.progressDialogBox()
              : Expanded(
                  child: RefreshIndicator(
                    onRefresh: _getData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          publicPressed ? transactionHistory(getData(0)) : Container(),
                          privatePressed ? transactionHistory(getData(1)) : Container(),
                          myTransPressed ? myTransactionHistory(getData(2)) : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _createHeader(BuildContext context) {
    var _phoneVerified = CommonUtils.phoneVerified();
    return Container(
      color: MyColors.base_green_color,
      padding: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              primary: MyColors.base_green_color,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: MyColors.base_green_color),
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            onPressed: () {
              scaffoldState.currentState.openDrawer();
            },
            child: Badge(
              showBadge: (Globals.unreadMsgCount + Globals.unreadPending) > 0,
              badgeContent: Text(
                (Globals.unreadMsgCount + Globals.unreadPending).toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              child: Icon(
                Feather.menu,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    checkPhoneAction(null, '', false);
                  },
                  child: Column(
                    children: [
                      Text(
                        _phoneVerified ? 'Available Balance' : 'Balance not available\n(Verify your phone)',
                        style: TextStyle(
                          color: _phoneVerified ? Colors.white : Colors.grey[200],
                          fontFamily: 'Doomsday',
                        ),
                      ),
                      Text(
                        StringMessage.naira + CommonUtils.toCurrency(Globals.walletbalance),
                        style: TextStyle(
                          color: _phoneVerified ? Colors.white : Colors.grey[350],
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          decoration: _phoneVerified ? TextDecoration.none : TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  checkIdentity(() {
                    Navigator.of(context).pushNamed('/deposit');
                  });
                },
                icon: Image.asset(
                  CustomImages.white_deposit,
                  height: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  checkIdentity(() {
                    checkPhoneAction('/searchpeople', 'send', false);
                  });
                },
                icon: Image.asset(
                  CustomImages.white_pencil_naira,
                  height: 25,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  _createOptions(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.base_green_color),
          color: MyColors.base_green_color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    publicPressed = true;
                    privatePressed = false;
                    myTransPressed = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 2),
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    color: publicPressed == true ? MyColors.base_green_color : Colors.white,
                    border: Border.all(color: MyColors.base_green_color),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    Entypo.globe,
                    color: publicPressed == true ? Colors.white : MyColors.base_green_color,
                    size: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    publicPressed = false;
                    privatePressed = true;
                    myTransPressed = false;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 2),
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  color: privatePressed == true ? MyColors.base_green_color : Colors.white,
                  child: Icon(
                    Feather.user,
                    color: privatePressed == true ? Colors.white : MyColors.base_green_color,
                    size: 25,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    publicPressed = false;
                    privatePressed = false;
                    myTransPressed = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  decoration: BoxDecoration(
                    color: myTransPressed == true ? MyColors.base_green_color : Colors.white,
                    border: Border.all(color: MyColors.base_green_color),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Image.asset(
                    CustomImages.green_naira_note,
                    color: myTransPressed == true ? Colors.white : null,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callMyWalletApi() async {
    if (Globals.isOnline) {
      try {
        WalletApi _walletApi = new WalletApi();
        WalletModel result = await _walletApi.search(context);
        if (result != null && result.status == "true") {
          setState(() {
            Globals.walletbalance = double.parse(result.balance);
          });
          PreferencesManager.setString(StringMessage.paystackPubKey, result.paystackPubKey);
          PreferencesManager.setString(StringMessage.paystackSecKey, result.paystackSecKey);
          if (mounted) setState(() {});
        }
      } catch (e) {
        CommonUtils.errorToast(context, e.toString() ?? "Something went wrong");
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void _callTransactionApi(load) async {
    if (Globals.isOnline) {
      if (load)
        setState(() {
          isLoading = true;
        });
      try {
        TransactionApi _transApi = new TransactionApi();
        TransactionModel result = await _transApi.search(context);
        if (result != null && result.status == "true") {
          setState(() {
            transList = result.transactionData ?? [];
          });
          if (load)
            setState(() {
              isLoading = false;
            });
        }
      } catch (e) {
        if (load)
          setState(() {
            isLoading = false;
          });
        CommonUtils.errorToast(context, e.toString() ?? "Something went wrong");
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void _createCommentDialogBoxAndCallApi(int id) {
    TextEditingController myCommentController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 250,
                height: 250,
                padding: EdgeInsets.all(15),
                child: SizedBox.expand(
                  child: Column(
                    children: [
                      Text(
                        "Add Comment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          decoration: TextDecoration.none,
                          color: MyColors.grey_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 80,
                        color: Colors.white,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: myCommentController,
                          style: TextStyle(fontFamily: 'Doomsday'),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                            ),
                            hintText: 'Enter comment',
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                          primary: MyColors.base_green_color,
                          shape: CustomUiWidgets.basicGreenButtonShape(),
                        ),
                        onPressed: () {
                          if (myCommentController.text.isEmpty) {
                            CommonUtils.errorToast(context, "Enter comment");
                          } else {
                            Navigator.pop(context);
                            addCommentModel(id.toString(), myCommentController.text);
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Doomsday',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            }),
          );
        });
  }

  void addCommentModel(String id, String comment) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddCommentModelApi _commentApi = new AddCommentModelApi();
        CommonModel result = await _commentApi.search(id, comment);
        if (result.status == "true") {
          Navigator.pop(context);
          _callTransactionApi(false);
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

  void _createMyLikePublic(int id, int like) async {
    if (Globals.isOnline) {
      try {
        MyLikeDislikeApi _likeApi = new MyLikeDislikeApi();
        CommonModel result = await _likeApi.search(id.toString(), like.toString());

        if (result.status == "true") {
          _callTransactionApi(false);
        }
      } catch (e) {
        print(e);
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }

  void processPayment(String page, String arguments, bool isPop) {
    if (isPop) {
      Navigator.pop(context);
    }
    Navigator.of(context).pushNamed(page, arguments: arguments);
  }

  void checkPhoneAction(String page, String arguments, bool isPop) async {
    if (CommonUtils.phoneVerified()) {
      processPayment(page, arguments, isPop);
      return;
    }
    String message = "";

    if (arguments == "send") {
      message = StringMessage.send_msg;
    } else if (arguments == "request") {
      message = StringMessage.request_msg;
    } else if (page == "/pending") {
      message = StringMessage.pending_msg;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileNumberFile(
          isExists: false,
          message: message,
          onResponse: (state, _) {
            if (state == true) {
              if (page == null) {
              } else {
                processPayment(page, arguments, isPop);
              }
            }
          },
        ),
      ),
    );
  }

  Widget transactionHistory(List<TransactionData> tranList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
      child: tranList.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tranList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(height: 3, color: MyColors.grey_color),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 55.0,
                        width: 55.0,
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(60.0),
                          child: Image.network(
                            Globals.base_url + tranList[index].to_userimage,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : Center(child: CircularProgressIndicator()),
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              CustomImages.default_profile_pic,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tranList[index].message,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    CommonUtils.timesAgoFeature(tranList[index].timestamp),
                                    style: TextStyle(
                                      fontFamily: 'Doomsday',
                                      color: MyColors.grey_color,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  tranList[index].privacy == 'public'
                                      ? Icon(
                                          Entypo.globe,
                                          color: MyColors.grey_color,
                                          size: 12,
                                        )
                                      : Icon(
                                          SimpleLineIcons.lock,
                                          color: MyColors.base_green_color,
                                          size: 12,
                                        ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                tranList[index].caption,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _createMyLikePublic(tranList[index].id, tranList[index].like);
                                    },
                                    child: tranList[index].like == 0
                                        ? Icon(AntDesign.hearto, color: MyColors.grey_color, size: 20)
                                        : Icon(AntDesign.heart, color: Colors.red, size: 20),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    tranList[index].likecount,
                                    style: TextStyle(
                                      fontFamily: 'Doomsday',
                                      color: MyColors.grey_color,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (tranList[index].showmycomment == false) {
                                          tranList[index].showmycomment = true;
                                        } else {
                                          tranList[index].showmycomment = false;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      FontAwesome.comment_o,
                                      color: MyColors.grey_color,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    tranList[index].commentlist.length.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Doomsday',
                                      color: MyColors.grey_color,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              tranList[index].showmycomment == true
                                  ? Column(
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: tranList[index].commentlist.length,
                                            itemBuilder: (context, ind) {
                                              return Container(
                                                margin: EdgeInsets.all(4),
                                                padding: EdgeInsets.fromLTRB(10, 2, 2, 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    tranList[index].commentlist[ind].user_id != userid
                                                        ? Text(
                                                            tranList[index].commentlist[ind].username,
                                                            style: TextStyle(
                                                              fontFamily: 'Doomsday',
                                                              fontSize: 18,
                                                            ),
                                                          )
                                                        : Container(),
                                                    Text(
                                                      tranList[index].commentlist[ind].comment,
                                                      style: TextStyle(
                                                        fontFamily: 'Doomsday',
                                                        color: MyColors.grey_color,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3, right: 5),
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                        CommonUtils.timesAgoFeature(tranList[index].commentlist[ind].timestamp),
                                                        style: TextStyle(
                                                          fontFamily: 'Doomsday',
                                                          color: Colors.black26,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        SizedBox(height: 5),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                            primary: MyColors.base_green_color,
                                            shape: CustomUiWidgets.basicGreenButtonShape(),
                                          ),
                                          onPressed: () {
                                            _createCommentDialogBoxAndCallApi(tranList[index].id);
                                          },
                                          child: Text(
                                            'Add Comment',
                                            style: TextStyle(
                                              fontFamily: 'Doomsday',
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Text(
              'No data found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Doomsday',
              ),
            ),
    );
  }

  Widget myTransactionHistory(List<TransactionData> tranList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
      child: tranList.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tranList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(height: 3, color: MyColors.grey_color),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tranList[index].username,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            (tranList[index].from_id != userid || tranList[index].username == 'Deposit' ? '+' : '-') + tranList[index].amount,
                            style: TextStyle(
                              fontSize: 16,
                              color: tranList[index].from_id != userid || tranList[index].username == 'Deposit' ? MyColors.base_green_color : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        CommonUtils.formattedTime(tranList[index].timestamp),
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: MyColors.grey_color,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Text(
              'No data found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Doomsday',
              ),
            ),
    );
  }
}
