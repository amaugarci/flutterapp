class Globals {
  static const int APP_SERVER = 2; //0: local server, 1: dev server, 2: live server
  static const bool DEBUGGING = true;
  static bool isInForeground = true;
  static DateTime typingDate;
  static int unreadMsgCount = 0;
  static int unreadPending = 0;
  static double walletbalance = 0;
  static bool isOnline = true;
  static List<String> result;

  // ignore: non_constant_identifier_names
  static int DEFAULT = -1;
  // ignore: non_constant_identifier_names
  static int SUBMITTED = 0;
  // ignore: non_constant_identifier_names
  static int PENDING = 1;
  // ignore: non_constant_identifier_names
  static int ACCEPTED = 2;
  // ignore: non_constant_identifier_names
  static int REJECTED = 3;

  // static String clientId = 'IKIA9614B82064D632E9B6418DF358A6A4AEA84D7218';
  // static String secretKey = 'XCTiBtLy1G9chAnyg0z3BcaFK4cVpwDg/GTw2EmjTZ8=';
  // mine test
  // static String clientId = 'IKIA755CF8F873F68B562FC8B48DC92D2F761FC61BEF';
  // static String secretKey = '5CDDD85E2F5114716651BC296E96FB98C642353D';
  // live
  static String clientId = 'IKIA7427FA36382909CEC2073068057BE45A7845FA71';
  static String secretKey = 'PnfNzJcZ8gQnYDK+m/9U2Epc3kdp9Ix5LV9hnItyHn4=';
  static String signatureMethod = 'SHA1';
  static String terminalId = '3DMO0001';
  // 3QTI0001
  // static String hostname = 'sandbox.interswitchng.com';
  static String hostname = 'api.interswitchng.com';

  static const String local_server = 'http://192.168.107.160:8000';
  static const String dev_server = 'http://dev.upaychat.com';
  static const String live_server = 'http://admin.upaychat.com';

  static const String base_url = Globals.APP_SERVER == 0
      ? local_server
      : Globals.APP_SERVER == 1
          ? dev_server
          : live_server;
}
