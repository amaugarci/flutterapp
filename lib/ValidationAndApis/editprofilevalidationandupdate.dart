import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/globals.dart';

class EditProfileValidation {
  static checkemailorusernameempty(
      BuildContext context, TextEditingController firstNameController, TextEditingController lastNameController, File images) async {
    if (Globals.isOnline) {
      if (CommonUtils.isEmpty(firstNameController, 3)) {
        CommonUtils.errorToast(context, StringMessage.firstname_Error);
      } else if (CommonUtils.isEmpty(lastNameController, 3)) {
        CommonUtils.errorToast(context, StringMessage.lastname_Error);
      } else {
        CommonUtils.showProgressDialogComplete(context, false);
        try {
          var stream = new http.ByteStream(Stream.castFrom(images.openRead()));

          var length = await images.length();
          String token = PreferencesManager.getString(StringMessage.token);
          Map<String, String> headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
          var uri = Uri.parse(NetworkUtils.api_url + NetworkUtils.updateprofile);
          var request = new http.MultipartRequest("POST", uri);

          print("URL: " + NetworkUtils.api_url + NetworkUtils.updateprofile);

          // multipart that takes file
          var multipartFileSign = new http.MultipartFile('profile_image', stream, length, filename: images.path);

          // add file to multipart
          request.files.add(multipartFileSign);

          request.headers.addAll(headers);

          request.fields['firstname'] = firstNameController.text;
          request.fields['lastname'] = lastNameController.text;

          // send
          var response = await request.send();

          print(response.statusCode);

          // listen for response
          response.stream.transform(utf8.decoder).listen((value) {
            try {
              print(value);
              final body = json.decode(value);

              String status = body['status'];
              String msg = body['message'];

              if (status == "true") {
                PreferencesManager.setString(StringMessage.firstname, firstNameController.text);
                PreferencesManager.setString(StringMessage.lastname, lastNameController.text);
                PreferencesManager.setString(StringMessage.profileimage, body['profile_image']);
                Navigator.pop(context);
                CommonUtils.successToast(context, "Saved");
              } else {
                Navigator.pop(context);
                CommonUtils.errorToast(context, msg);
              }
            } catch (e) {
              print(e);
              Navigator.pop(context);
            }
          });
        } catch (e) {
          print(e);
          Navigator.pop(context);
        }
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
}
