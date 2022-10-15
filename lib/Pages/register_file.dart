import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upaychat/CustomWidgets/custom_ui_widgets.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:upaychat/ValidationAndApis/registervalidation_api.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterFileState();
  }
}

class RegisterFileState extends State<RegisterFile> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
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

  _body(BuildContext context) {
    return Column(
      children: [
        CustomUiWidgets.registerscreenHeader(context),
        Container(
          margin: EdgeInsets.all(18),
          child: Column(
            children: [
              /// FIRST NAME
              Container(
                color: Colors.white,
                child: TextFormField(
                  cursorColor: MyColors.base_green_color,
                  controller: firstNameController,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: 'First Name',
                  ),
                ),
              ),

              /// LAST NAME
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  cursorColor: MyColors.base_green_color,
                  textInputAction: TextInputAction.next,
                  controller: lastNameController,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
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
                    hintText: 'Last Name',
                  ),
                ),
              ),

              /// EMAIL
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                  cursorColor: MyColors.base_green_color,
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
                    hintText: 'Email',
                  ),
                ),
              ),

              /// PASSWORD
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  controller: passwordController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                  ),
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
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: _obscurePassword ? MyColors.grey_color : MyColors.base_green_color,
                      ),
                    ),
                  ),
                ),
              ),

              /// Confirm PASSWORD
              Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 8),
                child: TextField(
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  controller: confirmPasswordController,
                  style: TextStyle(
                    fontFamily: 'Doomsday',
                    fontSize: 20,
                  ),
                  cursorColor: MyColors.base_green_color,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: _obscureConfirmPassword ? MyColors.grey_color : MyColors.base_green_color,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 25),
                child: Text.rich(
                  TextSpan(
                    text: "By proceeding, you agree to our ",
                    style: TextStyle(
                      fontFamily: 'Doomsday',
                      color: MyColors.grey_color,
                    ),
                    children: [
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          decoration: TextDecoration.underline,
                          color: MyColors.grey_color,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => openTerms(),
                      ),
                      TextSpan(
                        text: " and ",
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color: MyColors.grey_color,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy.",
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          decoration: TextDecoration.underline,
                          color: MyColors.grey_color,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () => openPrivacy(),
                      ),
                    ],
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
                  RegisterValidation.checkBasicDetailForRegister(
                      context, firstNameController, lastNameController, emailController, passwordController, confirmPasswordController);
                },
                child: Text(
                  'Continue',
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
    );
  }

  Future<void> openTerms() async {
    const String url = 'http://upaychat.com/legal/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openPrivacy() async {
    const String url = 'http://upaychat.com/privacy/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
