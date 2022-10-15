import 'dart:convert';
import 'dart:io';

import 'package:eventhandler/eventhandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart' as http;
import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/imagepicker.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/cupertino_date.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/Events/balanceevent.dart';
import 'package:upaychat/globals.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  ImagePickerHandler imagePicker;
  AnimationController _controller;
  DateTime birthday;
  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      userNameController = TextEditingController(),
      emailController = TextEditingController();

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();

    firstNameController.text = PreferencesManager.getString(StringMessage.firstname);
    lastNameController.text = PreferencesManager.getString(StringMessage.lastname);
    userNameController.text = PreferencesManager.getString(StringMessage.username);
    emailController.text = PreferencesManager.getString(StringMessage.email);
    String dob = PreferencesManager.getString(StringMessage.birthday);
    if (dob != null && dob != "null" && dob.isNotEmpty && dob != "0000-00-00") {
      try {
        birthday = DateTime.parse(dob);
      } catch (e) {}
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Doomsday',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            textColor: Colors.white,
            highlightColor: MyColors.base_green_color_20,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            splashColor: MyColors.base_green_color_20,
            color: MyColors.base_green_color,
            disabledColor: MyColors.base_green_color,
            shape: CircleBorder(side: BorderSide(color: MyColors.base_green_color)),
            onPressed: () {
              checkemailorusernameempty(context, firstNameController, lastNameController, birthday, _image);
            },
            child: Text(
              'Done',
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
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              child: Stack(
                children: [
                  Positioned(
                    child: InkWell(
                      onTap: () {
                        imagePicker.showDialog(context);
                      },
                      child: _image == null
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 120.0,
                              width: 120.0,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(60.0),
                                child: Image.network(
                                  Globals.base_url + PreferencesManager.getString(StringMessage.profileimage),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) =>
                                      (loadingProgress == null) ? child : Center(child: CircularProgressIndicator()),
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    CustomImages.default_profile_pic,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 15),
                              height: 120.0,
                              width: 120.0,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(60.0),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        imagePicker.showDialog(context);
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: MyColors.base_green_color,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Entypo.camera,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                imagePicker.showDialog(context);
              },
              child: Text(
                "Change Profile Photo",
                style: TextStyle(
                  fontFamily: 'Doomsday',
                  color: MyColors.base_green_color,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                    cursorColor: MyColors.base_green_color,
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(
                        color: MyColors.grey_color,
                        fontSize: 18,
                        fontFamily: 'Doomsday',
                      ),
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.grey_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                    cursorColor: MyColors.base_green_color,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(
                        color: MyColors.grey_color,
                        fontSize: 18,
                        fontFamily: 'Doomsday',
                      ),
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.grey_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // CupertinoDateTextBox(
                  //   initialValue: birthday,
                  //   onDateChange: (DateTime dob) {
                  //     setState(() {
                  //       birthday = dob;
                  //     });
                  //   },
                  //   hintText: birthday != null ? CommonUtils.formattedDate(birthday) : "0/0/0000",
                  //   fontSize: 18,
                  //   enabled: false,
                  // ),
                  // SizedBox(height: 10),
                  TextFormField(
                    controller: userNameController,
                    enabled: false,
                    cursorColor: MyColors.grey_color,
                    style: TextStyle(
                      color: MyColors.grey_color,
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: MyColors.grey_color,
                        fontSize: 18,
                        fontFamily: 'Doomsday',
                      ),
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.grey_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    enabled: false,
                    cursorColor: MyColors.grey_color,
                    style: TextStyle(
                      color: MyColors.grey_color,
                      fontFamily: 'Doomsday',
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: MyColors.grey_color,
                        fontSize: 18,
                        fontFamily: 'Doomsday',
                      ),
                      contentPadding: EdgeInsets.all(0),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.grey_color),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "You can be paid using your username, email, or phone number.",
                      style: TextStyle(
                        color: MyColors.grey_color,
                        fontSize: 18,
                        fontFamily: 'Doomsday',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      if (_image != null) {
        this._image = _image;
      }
    });
  }

  void checkemailorusernameempty(
      BuildContext context, TextEditingController firstNameController, TextEditingController lastNameController, DateTime birthday, File image) async {
    if (Globals.isOnline) {
      if (CommonUtils.isEmpty(firstNameController, 3)) {
        CommonUtils.errorToast(context, StringMessage.firstname_Error);
      } else if (CommonUtils.isEmpty(lastNameController, 3)) {
        CommonUtils.errorToast(context, StringMessage.lastname_Error);
        // } else if (birthday == null) {
        //   CommonUtils.errorToast(context, StringMessage.dob_Error);
      } else {
        CommonUtils.showProgressDialogComplete(context, false);
        try {
          String token = PreferencesManager.getString(StringMessage.token);
          Map<String, String> headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
          var uri = Uri.parse(NetworkUtils.api_url + NetworkUtils.updateprofile);
          var request = new http.MultipartRequest("POST", uri);

          print("URL: " + NetworkUtils.api_url + NetworkUtils.updateprofile);

          // multipart that takes file
          var multipartFileSign;
          if (image != null) {
            var stream = new http.ByteStream(Stream.castFrom(image.openRead()));

            var length = await image.length();
            multipartFileSign = new http.MultipartFile('profile_image', stream, length, filename: image.path);

            // add file to multipart
            request.files.add(multipartFileSign);
          }

          request.headers.addAll(headers);

          request.fields['firstname'] = firstNameController.text;
          request.fields['lastname'] = lastNameController.text;
          request.fields['birthday'] = birthday == null ? "" : birthday.toString();

          // send
          var response = await request.send();

          // listen for response
          response.stream.transform(utf8.decoder).listen((value) {
            try {
              print(value);
              final body = json.decode(value);

              String status = body['status'];
              String msg = body['message'];

              if (status == "true") {
                CommonUtils.successToast(context, "Profile Updated");
                PreferencesManager.setString(StringMessage.firstname, firstNameController.text);
                PreferencesManager.setString(StringMessage.lastname, lastNameController.text);
                PreferencesManager.setString(StringMessage.profileimage, body['profile_image']);
                PreferencesManager.setString(StringMessage.birthday, CommonUtils.dbFormattedDate(birthday));
                EventHandler().send(BalanceEvent(''));
                Navigator.pop(context);
              } else {
                CommonUtils.errorToast(context, msg);
              }
            } catch (e) {
              print(e);
            }
            Navigator.pop(context);
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
