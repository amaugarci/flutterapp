import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:upaychat/Apis/usercheckapi.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/loginmodel.dart';
import 'package:upaychat/Pages/add_bank_file.dart';
import 'package:upaychat/Pages/add_card_file.dart';
import 'package:upaychat/Pages/airtime_data_file.dart';
import 'package:upaychat/Pages/bank_list_file.dart';
import 'package:upaychat/Pages/buy_electricity_file.dart';
import 'package:upaychat/Pages/change_password_file.dart';
import 'package:upaychat/Pages/contact_us_file.dart';
import 'package:upaychat/Pages/deposit_file.dart';
import 'package:upaychat/Pages/edit_profile.dart';
import 'package:upaychat/Pages/faq_file.dart';
import 'package:upaychat/Pages/forgot_password.dart';
import 'package:upaychat/Pages/home_file.dart';
import 'package:upaychat/Pages/identity_verification_file.dart';
import 'package:upaychat/Pages/login_file.dart';
import 'package:upaychat/Pages/notification_page.dart';
import 'package:upaychat/Pages/offline_file.dart';
import 'package:upaychat/Pages/password_update_file.dart';
import 'package:upaychat/Pages/pay_bills_file.dart';
import 'package:upaychat/Pages/pending_file.dart';
import 'package:upaychat/Pages/pick_contact_file.dart';
import 'package:upaychat/Pages/register_file.dart';
import 'package:upaychat/Pages/search_people_file.dart';
import 'package:upaychat/Pages/setting_file.dart';
import 'package:upaychat/Pages/splash_screen.dart';
import 'package:upaychat/Pages/transaction_detail_file.dart';
import 'package:upaychat/Pages/transaction_file.dart';
import 'package:upaychat/Pages/withdraw_file.dart';

import 'regexinputformatter.dart';

const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,3})?\$');

final formatCurrency = new NumberFormat("#,##0.00", "en_US");
const BankNumShowCount = 4;
const CardNumShowCount = 4;

class CommonUtils {
  static const int CHECK_ONLINE_SECONDS = 5;
  static const int ONLINE_STATUS = 0;
  static const int OFFLINE_STATUS = -1;
  static const int TYPING_STATUS = 1;
  static const String USERID_PREFIX = "user_";
  static final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          MaterialCommunityIcons.wifi_off,
          color: Colors.white,
          size: 26,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'You are offline, Check your internet.',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Doomsday',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    duration: Duration(days: 365),
    backgroundColor: Colors.red,
  );

  static String fbUser(String id) {
    return USERID_PREFIX + id;
  }

  static String idFromFB(String str) {
    return str.replaceAll(USERID_PREFIX, "");
  }

  static String getStrUserid() {
    int userid = getUserid();
    if (userid == 0) return null;
    return userid.toString();
  }

  static int getUserid() {
    try {
      int userid = PreferencesManager.getInt(StringMessage.id);
      if (userid == null || userid == 0) return 0;
      return userid;
    } catch (e) {}
    return 0;
  }

  static dynamic returnRoutes(BuildContext context) {
    return {
      '/splashscreensec': (context) => SplashScreen(),
      '/login': (context) => LoginFile(),
      '/register': (context) => RegisterFile(),
      '/home': (context) => HomeFile(),
      '/forgotpassword': (context) => ForgotPassword(),
      '/passwordupdate': (context) => PasswordUpdateFile(),
      '/setting': (context) => SettingFile(),
      '/editprofile': (context) => EditProfile(),
      '/transaction': (context) => TransactionHistory(),
      '/addcard': (context) => AddCardFile(),
      '/addbank': (context) => AddBankFile(),
      '/changepassword': (context) => ChangePasswordFile(),
      '/searchpeople': (context) => SearchPeopleFile(),
      '/pending': (context) => PendingFile(),
      '/deposit': (context) => DepositFile(),
      '/withdraw': (context) => Withdraw(),
      '/banklist': (context) => BankListFile(),
      '/notification': (context) => NotificationFile(),
      '/faq': (context) => FaqFile(),
      '/contactus': (context) => ContactUsFile(),
      '/pickcontact': (context) => PickContactFile(),
      '/airtime_data': (context) => AirtimeDataFile(),
      '/buy_electricity': (context) => BuyElectricityFile(),
      '/pay_bills': (context) => PayBillsFile(),
      '/identity_verification': (context) => IdentityVerificationFile(),
      '/transaction_detail': (context) => TransactionDetail(),
      '/offline': (context) => OfflineFile(),
    };
  }

  static errorToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 0,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20);
  }

  static messageToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black26,
        textColor: Colors.white,
        fontSize: 20);
  }

  static successToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.base_green_color,
        textColor: Colors.white,
        fontSize: 20);
  }

  static String toCurrency(double amount) {
    return formatCurrency.format(amount);
  }

  static bool validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!(regex.hasMatch(email)))
      return false;
    else
      return true;
  }

  static bool validateMobile(String mobile) {
    String pattern = r'(^([0]|[+]234|[+]1)[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (mobile != null && mobile.isNotEmpty) {
      return regExp.hasMatch(mobile);
    }
    return false;
  }

  static bool isEmpty(TextEditingController controller, int length) {
    String text = controller.text;
    if (text.isEmpty || text.length < length) {
      return true;
    } else {
      return false;
    }
  }

  static void saveData(LoginModel result, BuildContext context) {
    PreferencesManager.setBool(StringMessage.isLogin, true);
    PreferencesManager.setInt(StringMessage.id, result.id);
    PreferencesManager.setString(StringMessage.firstname, result.firstname);
    PreferencesManager.setString(StringMessage.token, result.token);
    PreferencesManager.setString(StringMessage.roll, result.roll);
    PreferencesManager.setString(StringMessage.profileimage, result.profile_image);
    PreferencesManager.setString(StringMessage.lastname, result.lastname);
    PreferencesManager.setString(StringMessage.username, result.username);
    PreferencesManager.setString(StringMessage.email, result.email);
    PreferencesManager.setString(StringMessage.birthday, result.birthday);
    PreferencesManager.setString(StringMessage.mobile, result.mobile);
    PreferencesManager.setString(StringMessage.defaultprivacy, 'public');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c) => HomeFile()), (route) => false);
  }

  static void logout(BuildContext context) async {
    PreferencesManager.setBool(StringMessage.isLogin, false);
    await FirebaseMessaging.instance.deleteToken();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginFile()), (route) => false);
  }

  static void showProgressDialogComplete(BuildContext context, bool isDelay) async {
    if (isDelay) {
      await Future.delayed(Duration(milliseconds: 150));
    }
    try {
      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
            return Center(
              child: Container(
                height: 65,
                width: 65,
                child: SpinKitChasingDots(
                  color: MyColors.base_green_color,
                  size: 50.0,
                ),
              ),
            );
          });
    } catch (e) {
      print(e);
    }
  }

  static progressDialogBox() {
    return Center(
      child: Container(
        height: 65,
        width: 65,
        child: SpinKitChasingDots(
          color: MyColors.base_green_color,
          size: 50.0,
        ),
      ),
    );
  }

  static String timesAgoFeature(String fromDate) {
    try {
      DateTime dateTime = DateTime.parse(fromDate);
      var locale = 'en';
      String timeMsg = timeago.format(dateTime, locale: locale);
      return timeMsg;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String formattedTime(String fromDate) {
    try {
      DateTime dateTime = DateTime.parse(fromDate);
      dateTime = dateTime.add(DateTime.now().timeZoneOffset);
      final format = new DateFormat('dd/MM/yyyy hh:mm');
      return format.format(dateTime);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String formattedDate(DateTime dateTime) {
    try {
      dateTime = dateTime.add(DateTime.now().timeZoneOffset);
      final format = new DateFormat('dd/MM/yyyy');
      return format.format(dateTime);
    } catch (e) {
      print(e);
      return "";
    }
  }

  static String dbFormattedDate(DateTime dateTime) {
    try {
      dateTime = dateTime.add(DateTime.now().timeZoneOffset);
      final format = new DateFormat('yyyy-MM-dd');
      return format.format(dateTime);
    } catch (e) {
      print(e);
      return "";
    }
  }

  static bool checkStringId(String str) {
    return str != null && str.isNotEmpty && int.parse(str) > 0;
  }

  static const _upper_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const _lower_chars = 'abcdefghijklmnopqrstuvwxyz';
  static const _number_chars = '1234567890';

  static String getRandomString({int length, bool isUpper = true, bool isLower = true, bool isNum = true}) {
    Random _rnd = Random();
    String _chars = "";
    if (isUpper) _chars += _upper_chars;
    if (isLower) _chars += _lower_chars;
    if (isNum) _chars += _number_chars;
    if (_chars == null || _chars.isEmpty) return "";
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static String bankNumberHolder(String banknumber) {
    int len = max(0, banknumber.length - BankNumShowCount);
    return "•••••••" + banknumber.substring(len);
  }

  static String cardNumberHolder(String cardnumber) {
    cardnumber = cardnumber.replaceAll(" ", "");
    int len = max(0, cardnumber.length - CardNumShowCount);
    return "•••• •••• •••• " + cardnumber.substring(len);
  }

  static Future<String> isIdAllowed() async {
    UserCheckApi checkApi = new UserCheckApi();
    var res = await checkApi.search();
    if (res.status == "true") {
      if (res.data['user_status'] == "off") {
        return "Please complete your identity verification on settings page.";
      }
    }
    return "true";
  }

  static bool phoneVerified() {
    String mobileNumber = PreferencesManager.getString(StringMessage.mobile);
    return mobileNumber != null && mobileNumber != "null" && mobileNumber.isNotEmpty;
  }

  static getTargetPath(String path) {
    return path.replaceAll(".jpg", "1.jpg").replaceAll(".png", "1.png").replaceAll(".gif", "1.gif");
  }
}
