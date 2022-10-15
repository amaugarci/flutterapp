import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    PreferencesManager.setBool(StringMessage.firstTimeLogin, true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(CustomImages.splash),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    primary: MyColors.base_green_color,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: MyColors.base_green_color),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 22, color: Colors.white, fontFamily: 'Doomsday'),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: MyColors.base_green_color),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 22,
                      color: MyColors.base_green_color,
                      fontFamily: 'Doomsday',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
