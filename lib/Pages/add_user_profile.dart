import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/imagepicker.dart';
import 'package:upaychat/CustomWidgets/cupertino_date.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/ValidationAndApis/registervalidation_api.dart';

class AddUserProfile extends StatefulWidget {
  final Map map;

  AddUserProfile({Key key, @required this.map}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddUserProfileState();
  }
}

class AddUserProfileState extends State<AddUserProfile> with TickerProviderStateMixin, ImagePickerListener {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  File _image;
  ImagePickerHandler imagePicker;
  AnimationController _controller;

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    userNameController.text = widget.map['firstname'] + widget.map['lastname'];
    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();

    super.initState();
  }

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

  DateTime birthday;

  _body(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          color: MyColors.base_green_color,
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Profile',
                      style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 8, right: 8),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Text(
                  "Help people know it\`s you \n they\`re paying",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors.grey_color, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Doomsday'),
                ),
              ),
              SizedBox(height: 2),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width / 3,
                child: Stack(
                  children: [
                    Positioned(
                      child: _image == null
                          ? Image.asset(
                              CustomImages.default_profile_pic,
                              fit: BoxFit.fill,
                            )
                          : new Container(
                              height: 120.0,
                              width: 120.0,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(const Radius.circular(80.0)),
                              ),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(80.0),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                  height: 120,
                                  width: 120,
                                ),
                              )),
                    ),
                    Positioned(
                      bottom: 100,
                      right: 10,
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

              /// FIRST NAME
              Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: userNameController,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.zero),
                    ),
                    hintText: 'Username',
                  ),
                ),
              ),

              /// Date of Birth
              CupertinoDateTextBox(
                initialValue: birthday,
                onDateChange: (DateTime dob) {
                  setState(() {
                    birthday = dob;
                  });
                },
                hintText: birthday != null ? CommonUtils.formattedDate(birthday) : "0/0/0000",
                fontSize: 18,
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
                    RegisterValidation.userNameValidation(context, userNameController, birthday, widget.map, _image);
                  },
                  child: Text(
                    'Complete Registration',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Doomsday'),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  @override
  userImage(File _image) {
    setState(() {
      if (_image != null) {
        this._image = _image;
      }
    });
  }
}
