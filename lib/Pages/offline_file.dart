import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/globals.dart';

class OfflineFile extends StatefulWidget {
  const OfflineFile({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OfflineFileState();
  }
}

class OfflineFileState extends State<OfflineFile> {
  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Globals.isOnline == true) {
      closePageSync();
    }
  }

  closePageSync() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: MyColors.base_green_color_20,
          height: double.infinity,
          width: double.infinity,
          child: _body(context),
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.base_green_color,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              child: Image.asset(
                CustomImages.offline_phone,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Text(
              "Oops!   You are offline, \n Please check your internet connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(10),
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text(
                'Close App',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ));
  }
}
