import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/forgotpasswordapi.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Models/commonmodel.dart';
import 'package:upaychat/globals.dart';

class PasswordUpdateFile extends StatefulWidget {
  final String mobilenumber;

  const PasswordUpdateFile({Key key, this.mobilenumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PasswordUpdateFileState();
  }
}

class PasswordUpdateFileState extends State<PasswordUpdateFile> {
  bool _obscureText = true;
  TextEditingController passwordController = TextEditingController(), confirmpasswordController = TextEditingController();

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

  _body(BuildContext context) {
    {
      return Container(
        child: Column(
          children: [
            CustomUiWidgets.updatepasswordscreenHeader(context),
            updatepasswordscreen_bodypart(context),
          ],
        ),
      );
    }
  }

  updatepasswordscreen_bodypart(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Text(
              'NEW PASSWORD',
              style: TextStyle(
                fontFamily: 'Doomsday',
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
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
                  icon: _obscureText
                      ? Icon(
                          Icons.remove_red_eye,
                          color: MyColors.grey_color,
                        )
                      : Icon(
                          Icons.remove_red_eye,
                          color: MyColors.base_green_color,
                        ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Text(
              'VERIFY PASSWORD',
              style: TextStyle(
                fontFamily: 'Doomsday',
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: TextFormField(
              obscureText: _obscureText,
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 20,
              ),
              controller: confirmpasswordController,
              cursorColor: MyColors.base_green_color,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: 'Confirm password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: _obscureText
                      ? Icon(
                          Icons.remove_red_eye,
                          color: MyColors.grey_color,
                        )
                      : Icon(
                          Icons.remove_red_eye,
                          color: MyColors.base_green_color,
                        ),
                ),
              ),
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
              shape: CustomUiWidgets.basicGreenButtonShape(),
              onPressed: () {
                String password = passwordController.text;
                String confirmpassword = confirmpasswordController.text;
                if (password.isEmpty || password == null || password.length < 6) {
                  CommonUtils.errorToast(context, 'please enter correct password');
                } else if (password != confirmpassword) {
                  CommonUtils.errorToast(context, 'Password not matched');
                } else {
                  _updatemypassword();
                }
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
        ],
      ),
    );
  }

  void _updatemypassword() async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        ForgotPasswordApi _forgotpasswordfapi = new ForgotPasswordApi();
        CommonModel result = await _forgotpasswordfapi.search(widget.mobilenumber, passwordController.text);
        if (result.status == "true") {
          Navigator.pop(context);
          Navigator.pop(context);
          CommonUtils.successToast(context, "Password change successfully, please login again");
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
}
