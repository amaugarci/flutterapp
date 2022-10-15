import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Pages/mobile_number_file.dart';
import 'package:upaychat/Pages/password_update_file.dart';
import 'package:upaychat/ValidationAndApis/loginvalidation_api.dart';

class LoginFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginFileState();
  }
}

class LoginFileState extends State<LoginFile> {
  bool _obscureText = true;
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(child: _body(context)),
      ),
    );
  }

  forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileNumberFile(
          isExists: true,
          onResponse: (state, phone) {
            if (state == true) {
              updatePassword(phone);
            }
          },
        ),
      ),
    );
  }

  updatePassword(String phone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordUpdateFile(
          mobilenumber: phone,
        ),
      ),
    );
  }

  final snackBar = SnackBar(
    content: Text(
      "sfsdf",
      style: TextStyle(color: Colors.black),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22))),
    backgroundColor: Colors.white70,
    action: SnackBarAction(
      textColor: Colors.blueAccent,
      label: "Buy",
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    duration: Duration(days: 365),
  );
  _body(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomUiWidgets.loginscreenHeader(context),
          Container(
            margin: EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TextFormField(
                    cursorColor: MyColors.base_green_color,
                    controller: userController,
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintText: 'Email, username or phone number',
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 8),
                  child: TextFormField(
                    obscureText: _obscureText,
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                    ),
                    controller: passwordController,
                    cursorColor: MyColors.base_green_color,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: _obscureText ? MyColors.grey_color : MyColors.base_green_color,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                InkWell(
                  onTap: forgotPassword,
                  child: Text(
                    'Forgot your password ?',
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      color: MyColors.base_green_color,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                    primary: MyColors.base_green_color,
                    shape: CustomUiWidgets.basicGreenButtonShape(),
                  ),
                  onPressed: () {
                    LoginValidationApi.login(context, userController, passwordController);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
