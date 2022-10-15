import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';

class ChangePasswordFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordFileState();
  }
}

class ChangePasswordFileState extends State<ChangePasswordFile> {
  TextEditingController oldpassword = new TextEditingController();
  TextEditingController newpassword = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();

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
      return Column(
        children: [
          Container(
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
                    'Change Password',
                    textAlign: TextAlign.center,
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
          ),
          CustomUiWidgets.changepasswordscreenBodypart(context, oldpassword, newpassword, confirmpassword),
        ],
      );
    }
  }
}
