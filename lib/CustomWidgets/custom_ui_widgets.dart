import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Pages/splash_screen.dart';
import 'package:upaychat/ValidationAndApis/changepasswordvalidation.dart';

class CustomUiWidgets {
  /// LOGIN SCREEN
  static Container loginscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Login',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/register');
              },
              child: Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//// REGISTER SCREEN HEADER
  static Container registerscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Register',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// FORGOT PASSWORD SCREEN
  static Container forgotpasswordscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Doomsday',
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Forgot Password',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UPDATE PASSWORD CHANGE PASSWORD SCREEN
  static Container updatepasswordscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColors.base_green_color),
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static RoundedRectangleBorder basicGreenButtonShape() {
    return RoundedRectangleBorder(
      side: BorderSide(color: MyColors.base_green_color),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  /// CHANGE PASSWORD
  static Container changepasswordscreenBodypart(
      BuildContext context, TextEditingController oldpassword, TextEditingController newpassword, TextEditingController confirmpassword) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'Current',
              style: TextStyle(
                color: MyColors.grey_color,
                fontSize: 20,
                fontFamily: 'Doomsday',
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: TextField(
              obscureText: true,
              controller: oldpassword,
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0)),
                hintText: 'Old Password',
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'Enter New Password',
              style: TextStyle(
                color: MyColors.grey_color,
                fontSize: 20,
                fontFamily: 'Doomsday',
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: TextField(
              obscureText: true,
              controller: newpassword,
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 18,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0)),
                hintText: 'New Password',
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'Verify Password',
              style: TextStyle(
                color: MyColors.grey_color,
                fontSize: 20,
                fontFamily: 'Doomsday',
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: TextField(
              obscureText: true,
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 18,
              ),
              controller: confirmpassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0)),
                hintText: 'Confirm New Password',
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Changing password will delete all your active sessions',
            style: TextStyle(
              fontFamily: 'Doomsday',
              color: MyColors.grey_color,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: FlatButton(
              textColor: Colors.white,
              highlightColor: MyColors.base_green_color_20,
              padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
              splashColor: MyColors.base_green_color_20,
              color: MyColors.base_green_color,
              disabledColor: MyColors.base_green_color,
              shape: basicGreenButtonShape(),
              onPressed: () {
                ChangePasswordValidation.changepassword(context, oldpassword, newpassword, confirmpassword);
              },
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Text.rich(
              TextSpan(
                text: "If you forgot your current password, please log out and at top right corner click ",
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 16,
                  color: MyColors.grey_color,
                ),
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 16,
                      color: MyColors.grey_color,
                    ),
                  ),
                  TextSpan(
                    text: 'Forgot Password',
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: " link.",
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 16,
                      color: MyColors.grey_color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

///// SearchPeople header

  static Container searchPeopleHeader(BuildContext context, String mode) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              mode == 'request' ? 'Request Money' : 'Send Money',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///// PAY OR REQUEST
  static Container payrequestscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Send Money',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //// ALL DONE
  static Container alldonescreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      height: 100,
      child: Container(),
    );
  }

  static Container alldonescreenBodypart(BuildContext context, String msg) {
    // Toggles the password show status
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height / 1.5,
            alignment: Alignment.center,
            color: Colors.white,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Feather.check_circle,
                  color: MyColors.base_green_color,
                  size: 120,
                ),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColors.base_green_color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: FlatButton(
                textColor: Colors.white,
                highlightColor: MyColors.base_green_color_20,
                padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                splashColor: MyColors.base_green_color_20,
                color: MyColors.base_green_color,
                disabledColor: MyColors.base_green_color,
                shape: basicGreenButtonShape(),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
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
    );
  }

  ///// PAYMENT REQUEST
  static Container paymentrequestscreenHeader(BuildContext context) {
    return Container(
      color: MyColors.base_green_color,
      height: 100,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: EdgeInsets.all(15),
                primary: MyColors.base_green_color,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            width: double.infinity,
            child: Text(
              'Request Money',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
