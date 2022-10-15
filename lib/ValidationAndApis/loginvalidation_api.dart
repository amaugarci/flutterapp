import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/login_api.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/Models/loginmodel.dart';
import 'package:upaychat/globals.dart';

class LoginValidationApi {
  static login(BuildContext context, TextEditingController userController, TextEditingController passwordController) async {
    if (Globals.isOnline) {
      if (CommonUtils.isEmpty(userController, 3)) {
        CommonUtils.errorToast(context, StringMessage.enter_correct_emailusrnamemobile);
      } else if (CommonUtils.isEmpty(passwordController, 6)) {
        CommonUtils.errorToast(context, StringMessage.enter_correct_password);
      } else {
        CommonUtils.showProgressDialogComplete(context, false);
        String username = userController.text;
        if (username.startsWith("0") && CommonUtils.validateMobile(username)) username = username.replaceFirst("0", "+234");
        LoginModel result = await LoginApi().search(username, passwordController.text);
        Navigator.pop(context);
        if (result.status == "true") {
          CommonUtils.successToast(context, result.message);
          CommonUtils.saveData(result, context);
        } else {
          CommonUtils.errorToast(context, result.message);
        }
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
