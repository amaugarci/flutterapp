import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:upaychat/Apis/pendingrequestapi.dart';
import 'package:upaychat/Apis/usercheckapi.dart';
import 'package:upaychat/Apis/wallet_api.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/Models/pendingrequestmodel.dart';
import 'package:upaychat/Models/walletmodel.dart';
import 'package:upaychat/Pages/splash_screen.dart';
import 'package:upaychat/CommonUtils/firebase_utils.dart';
import 'package:upaychat/globals.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  Widget screenView;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UpayChat',
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: _navigator,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(child: screenView),
      ),
      routes: CommonUtils.returnRoutes(context),
    );
  }

  Timer timerOnline;
  Timer timer_15;
  @override
  void initState() {
    FirebaseUtils.updateState();
    getUnreadMessages();
    checkOnline();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    // runs every $CommonUtils.CHECK_ONLINE_SECONDS second
    timerOnline = Timer.periodic(Duration(seconds: CommonUtils.CHECK_ONLINE_SECONDS), (timer) {
      bool isLogin = PreferencesManager.getBool(StringMessage.isLogin);
      if (Globals.isOnline && isLogin) {
        FirebaseUtils.updateState();
        getUnreadMessages();
      }
    });
    timer_15 = Timer.periodic(Duration(seconds: 10), (timer) {
      bool isLogin = PreferencesManager.getBool(StringMessage.isLogin);
      if (Globals.isOnline && isLogin) {
        getPendingRequest();
        getCurWalletBalance();
      }
    });
    handleTimeout();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  StreamSubscription<ConnectivityResult> networkConnection;
  void checkOnline() async {
    try {
      rootScaffoldMessengerKey.currentState.clearSnackBars();
    } catch (e) {}
    networkEventListener(await Connectivity().checkConnectivity());
    networkConnection = Connectivity().onConnectivityChanged.listen(networkEventListener);
  }

  void networkEventListener(ConnectivityResult result) async {
    var connected = false;
    if (result == ConnectivityResult.mobile) {
      connected = true;
    } else if (result == ConnectivityResult.wifi) {
      connected = true;
    }
    if (Globals.isOnline != connected) {
      Globals.isOnline = connected;
      // if (connected == false) {
      //   _navigator.currentState.pushNamed('/offline');
      // }
      if (!connected) {
        rootScaffoldMessengerKey.currentState.showSnackBar(CommonUtils.snackBar);
      } else {
        rootScaffoldMessengerKey.currentState.clearSnackBars();
      }
      await Future.delayed(Duration(milliseconds: 300));
    }
  }

  void getUnreadMessages() {
    FirebaseUtils.getUnreadMessages().then((value) {
      setState(() {
        Globals.unreadMsgCount = value;
      });
    }).catchError((err) {
      print("unread msg: " + err.toString());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Globals.isInForeground = state == AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (networkConnection != null) {
      networkConnection.cancel();
    }
    super.dispose();
  }

  handleTimeout() async {
    try {
      await PreferencesManager.init();
      bool isFirstTime = PreferencesManager.getBool(StringMessage.firstTimeLogin);
      if (isFirstTime == false || isFirstTime == null) {
      } else {
        bool isLogin = PreferencesManager.getBool(StringMessage.isLogin);
        if (Globals.isOnline && isLogin) {
          UserCheckApi checkApi = new UserCheckApi();
          var res = await checkApi.search();
          if (res.status == "true") {
            _navigator.currentState.pushReplacementNamed('/home');
            return;
          } else {
            PreferencesManager.setBool(StringMessage.isLogin, false);
            CommonUtils.errorToast(context, res.message);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    PreferencesManager.setBool(StringMessage.isLogin, false);
    setState(() {
      screenView = SplashScreen();
    });
  }

  getPendingRequest() async {
    int count = 0;
    try {
      PendingRequestApi _requestApi = new PendingRequestApi();
      PendingRequestModel result = await _requestApi.search().timeout(Duration(seconds: 2));
      if (result.status == "true") {
        if (result.pendingRequestList.isNotEmpty) {
          var pendingRequest = result.pendingRequestList;
          int userid = CommonUtils.getUserid();
          count = pendingRequest.where((element) => element.fromuser_id != userid).length;
        }
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      Globals.unreadPending = count;
    });
  }

  getCurWalletBalance() async {
    double balance = 0;
    try {
      if (Globals.isOnline) {
        WalletApi _walletApi = new WalletApi();
        WalletModel result = await _walletApi.search(context);
        if (result != null && result.status == "true") {
          balance = double.parse(result.balance);
        }
      }
    } catch (e) {}
    setState(() {
      Globals.walletbalance = balance;
    });
  }
}
