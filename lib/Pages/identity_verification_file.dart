import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upaychat/Apis/idverificationinfo.dart';
import 'package:upaychat/Apis/network_utils.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';
import 'package:upaychat/CommonUtils/preferences_manager.dart';
import 'package:upaychat/CommonUtils/string_files.dart';
import 'package:upaychat/CustomWidgets/custom_images.dart';
import 'package:upaychat/CustomWidgets/my_colors.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:upaychat/Models/idverificationmodel.dart';
import 'package:upaychat/globals.dart';

class IdentityVerificationFile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IdentityVerificationFileState();
}

const TextStyle _TITLE_STYLE = TextStyle(
  fontFamily: 'Doomsday',
  fontSize: 18,
  color: MyColors.base_green_color,
  fontWeight: FontWeight.bold,
);
const TextStyle _DESC_STYLE = TextStyle(fontFamily: 'Doomsday', fontSize: 13, color: MyColors.grey_color);
const TextStyle _DESC_BOLD_STYLE = TextStyle(fontFamily: 'Doomsday', fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold);
const double _SPACING = 10.0;
const double _TITLE_SPACING = 20.0;

class IdentityVerificationFileState extends State<IdentityVerificationFile> {
  String verification_code = "";
  List<File> gover_files;
  List<File> proof_files;
  List<File> verify_files;
  bool isLoaded = true;
  bool addAddress = true;

  int verifyStatus;
  String verifyMsg;

  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  bool inValidStreet = false;
  bool inValidCity = false;
  bool inValidState = false;
  bool inValidZipCode = false;
  bool inValidCountry = false;
  String selectedCountry;
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    verification_code = CommonUtils.getRandomString(length: 8, isLower: false);
    getVerification();
  }

  getVerification() async {
    setState(() {
      isLoaded = false;
      verifyStatus = -1;
      verifyMsg = "";
    });
    try {
      IDVerificationInfo getInfo = new IDVerificationInfo();
      IDVerificationModel data = await getInfo.search();
      if (data != null && data.status == "true" && data.verificationData != null) {
        var _tmp = data.verificationData;
        verifyStatus = _tmp.status;
        verifyMsg = _tmp.result;
        streetController.text = _tmp.street;
        cityController.text = _tmp.city;
        stateController.text = _tmp.state;
        zipcodeController.text = _tmp.zipcode;
        var country = (_tmp.country ?? '').toLowerCase();
        selectedCountry = country;
      }
    } catch (e) {
      CommonUtils.errorToast(context, e.toString() ?? "Someting went wrong");
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: MyColors.base_green_color,
        centerTitle: true,
        title: new Text(
          'Identity Verification',
          style: TextStyle(
            fontFamily: 'Doomsday',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: MyColors.base_green_color_20,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _body(context),
      ),
    );
  }

  static RoundedRectangleBorder basicGreenButtonShape() {
    return RoundedRectangleBorder(
      side: BorderSide(color: MyColors.base_green_color),
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  selectFile(int type) async {
    //type 1, 2, 3
    setState(() {
      if (type == 1) {
        gover_files = null;
      } else if (type == 2) {
        proof_files = null;
      } else if (type == 3) {
        verify_files = null;
      }
    });
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'gif'],
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      setState(() {
        if (type == 1) {
          gover_files = files;
        } else if (type == 2) {
          proof_files = files;
        } else if (type == 3) {
          verify_files = files;
        }
      });
    }
  }

  _file_selector(BuildContext context, int type) {
    int len = 0;
    var files = (type == 1
        ? gover_files
        : type == 2
            ? proof_files
            : verify_files);
    if (files != null) {
      len = files.length;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      decoration: BoxDecoration(
        color: MyColors.light_grey_color,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          TouchableOpacity(
            activeOpacity: .4,
            onTap: () {
              selectFile(type);
              print("Container clicked");
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 3),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: MyColors.light_grey_divider_color,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Text(
                    "+",
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Doomsday', fontSize: 20),
                  ),
                  Text(
                    "    Add files...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Doomsday',
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            len > 0 ? "$len files selected" : "Add multiple files here",
            style: TextStyle(color: len > 0 ? Colors.black : MyColors.grey_color, fontFamily: 'Doomsday', fontSize: 14, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  submitIdCard() async {
    if (gover_files == null || gover_files.length <= 0) {
      CommonUtils.errorToast(context, StringMessage.enter_government);
      return;
    }
    if (proof_files == null || proof_files.length <= 0) {
      CommonUtils.errorToast(context, StringMessage.enter_proof);
      return;
    }
    if (verify_files == null || verify_files.length <= 0) {
      CommonUtils.errorToast(context, StringMessage.enter_verify);
      return;
    }
    if (Globals.isOnline) {
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
      return;
    }
    try {
      CommonUtils.showProgressDialogComplete(context, false);

      String token = PreferencesManager.getString(StringMessage.token);
      Map<String, String> headers = {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
      var uri = Uri.parse(NetworkUtils.api_url + NetworkUtils.idverify);
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFileSign;
      if (gover_files != null && gover_files.length > 0) {
        await Future.forEach(
          gover_files,
          (image) async {
            var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
            var length = await image.length();
            multipartFileSign = new http.MultipartFile('gover_files[]', stream, length, filename: image.path);
            request.files.add(multipartFileSign);
          },
        );
      }

      if (proof_files != null && proof_files.length > 0) {
        await Future.forEach(
          proof_files,
          (image) async {
            var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
            var length = await image.length();
            multipartFileSign = new http.MultipartFile('proof_files[]', stream, length, filename: image.path);
            request.files.add(multipartFileSign);
          },
        );
      }
      if (verify_files != null && verify_files.length > 0) {
        await Future.forEach(
          verify_files,
          (image) async {
            var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
            var length = await image.length();
            multipartFileSign = new http.MultipartFile('verify_files[]', stream, length, filename: image.path);
            request.files.add(multipartFileSign);
          },
        );
      }

      request.headers.addAll(headers);

      request.fields['verify_code'] = verification_code;
      request.fields['street'] = streetController.text;
      request.fields['city'] = cityController.text;
      request.fields['state'] = stateController.text;
      request.fields['zipcode'] = zipcodeController.text;
      request.fields['country'] = selectedCountry;

      // send
      var response = await request.send();

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        CommonUtils.successToast(context, "Scuccessfully submitted id card");
        // Navigator.pop(context);
        setState(() {
          verifyStatus = Globals.SUBMITTED;
        });
      });
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  Widget verifyResultView() {
    String message = "";
    print(verifyStatus.toString() + ":" + verifyMsg);

    bool _submit = verifyStatus == Globals.SUBMITTED;
    bool _pending = verifyStatus == Globals.PENDING;
    bool _accept = verifyStatus == Globals.ACCEPTED;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .4),
      child: Text(
        _submit
            ? "You sent the Identity Verification Request,\nWe will reply soon."
            : _pending
                ? "We are reviewing your identity now."
                : _accept
                    ? "identity Successfully Verified."
                    : "",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: MyColors.base_green_color,
          fontFamily: 'Doomsday',
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
    );
  }

  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    super.dispose();
  }

  confirmAddress() {
    setState(() {
      inValidStreet = CommonUtils.isEmpty(streetController, 0);
      inValidCity = CommonUtils.isEmpty(cityController, 0);
      inValidState = CommonUtils.isEmpty(stateController, 0);
      inValidZipCode = CommonUtils.isEmpty(zipcodeController, 0);
      inValidCountry = selectedCountry == null || selectedCountry.length <= 0;
    });
    if (inValidStreet || inValidCity || inValidState || inValidZipCode || inValidCountry) return;
    setState(() {
      addAddress = false;
    });
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (scrollController != null) {
        scrollController.jumpTo(0);
        timer.cancel();
      }
    });
  }

  _body(BuildContext context) {
    bool isVisibleVerify = verifyStatus == Globals.DEFAULT || verifyStatus == Globals.REJECTED;
    bool isRejected = verifyStatus == Globals.REJECTED;

    var countries = ["United States", "Nigeria"];
    if (selectedCountry == null) {
      selectedCountry = countries[0];
    } else if (!countries.contains(selectedCountry)) {
      countries.add(selectedCountry);
    }
    return isLoaded
        ? isVisibleVerify
            ? Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: addAddress
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isRejected)
                              Container(
                                color: Colors.red,
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Identity Verification rejected, Please submit again.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Doomsday',
                                        fontSize: 16,
                                      ),
                                    ),
                                    verifyMsg != null
                                        ? Text(verifyMsg,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Doomsday',
                                              fontSize: 16,
                                            ))
                                        : Container(),
                                  ],
                                ),
                              ),
                            SizedBox(height: _TITLE_SPACING),
                            Text(
                              "Let's get your physical address.",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Doomsday',
                                fontSize: 26,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: streetController,
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                              ),
                              cursorColor: MyColors.base_green_color,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: 'Street address',
                                labelText: 'Street address',
                                labelStyle: TextStyle(color: inValidStreet ? Colors.red : MyColors.grey_color),
                                errorText: inValidStreet ? 'Please enter a valid address.' : null,
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: cityController,
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                              ),
                              cursorColor: MyColors.base_green_color,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: 'City',
                                labelText: 'City',
                                labelStyle: TextStyle(color: inValidCity ? Colors.red : MyColors.grey_color),
                                errorText: inValidCity ? 'Please enter a valid city.' : null,
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: stateController,
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                              ),
                              cursorColor: MyColors.base_green_color,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: 'State',
                                labelText: 'State',
                                labelStyle: TextStyle(color: inValidState ? Colors.red : MyColors.grey_color),
                                errorText: inValidState ? 'Please enter a valid state.' : null,
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: zipcodeController,
                              style: TextStyle(
                                fontFamily: 'Doomsday',
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: MyColors.base_green_color,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: MyColors.base_green_color, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                hintText: 'Zip code',
                                labelText: 'Zip code',
                                labelStyle: TextStyle(color: inValidZipCode ? Colors.red : MyColors.grey_color),
                                errorText: inValidZipCode ? 'Please enter a valid Zip code' : null,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: MyColors.light_grey_divider_color,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                value: selectedCountry,
                                iconSize: 30,
                                elevation: 16,
                                style: const TextStyle(
                                  color: MyColors.grey_color,
                                  fontSize: 18,
                                  fontFamily: 'Doomsday',
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    selectedCountry = newValue;
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return countries.map((var item) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width - 90,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: countries.map<DropdownMenuItem<String>>((var value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                textColor: Colors.white,
                                highlightColor: MyColors.base_green_color_20,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                splashColor: MyColors.base_green_color_20,
                                color: MyColors.base_green_color,
                                disabledColor: MyColors.base_green_color,
                                shape: basicGreenButtonShape(),
                                onPressed: confirmAddress,
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Doomsday',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isRejected)
                              Container(
                                color: Colors.red,
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: _TITLE_SPACING),
                                child: Column(
                                  children: [
                                    Text(
                                      "Identity Verification rejected, Please submit again.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Doomsday',
                                        fontSize: 16,
                                      ),
                                    ),
                                    verifyMsg != null
                                        ? Text(verifyMsg,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Doomsday',
                                              fontSize: 16,
                                            ))
                                        : Container(),
                                  ],
                                ),
                              ),
                            Text(
                              "1. Government Issued Identification",
                              style: _TITLE_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            Text.rich(
                              TextSpan(
                                text: "Upload a valid government issued ID, driver's license or passport which includes your ",
                                style: _DESC_STYLE,
                                children: [
                                  TextSpan(
                                    text: "photo, signature, name, ",
                                    style: _DESC_BOLD_STYLE,
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: _DESC_STYLE,
                                  ),
                                  TextSpan(
                                    text: 'date of birth',
                                    style: _DESC_BOLD_STYLE,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: _SPACING),
                            Text(
                              "File formats .PNG, .GIF, .JPG, .PDF (Maximum 5MB).",
                              style: _DESC_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            _file_selector(context, 1),
                            SizedBox(height: _TITLE_SPACING),
                            Text(
                              "2. Proof of Residential Address",
                              style: _TITLE_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            Text(
                              "Upload a document as proof of residential address such as your bank statement (less than 3 month old), utility bill (less than 3 months old) or tax assessment (less than 12 months old) which includes your name and your current address.",
                              style: _DESC_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            Text(
                              "File formats .PNG, .GIF, .JPG, .PDF (Maximum 5MB).",
                              style: _DESC_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            _file_selector(context, 2),
                            SizedBox(height: _TITLE_SPACING),
                            Text(
                              "3. Verification Code Confirmation",
                              style: _TITLE_STYLE,
                            ),
                            SizedBox(height: _SPACING),
                            Text(
                              "Provide a photo of you holding the verification code displayed below in one hand and your ID clearly visible in our other hand.",
                              style: _DESC_STYLE,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                                    padding: EdgeInsets.all(10),
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: MyColors.light_grey_color,
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(
                                        color: MyColors.grey_color,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Verification Code",
                                          style: TextStyle(fontSize: 12, fontFamily: 'Doomsday', color: MyColors.navigation_bg_color),
                                        ),
                                        Container(
                                          height: 100,
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          child: Text(
                                            verification_code,
                                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.navigation_bg_color),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                                    padding: EdgeInsets.all(10),
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: MyColors.light_grey_color,
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(
                                        color: MyColors.grey_color,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(
                                      CustomImages.id_verification,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: _SPACING),
                            _file_selector(context, 3),
                            SizedBox(height: 40),
                            Container(
                              width: double.infinity,
                              child: FlatButton(
                                textColor: Colors.white,
                                highlightColor: MyColors.base_green_color_20,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                splashColor: MyColors.base_green_color_20,
                                color: MyColors.base_green_color,
                                disabledColor: MyColors.base_green_color,
                                shape: basicGreenButtonShape(),
                                onPressed: submitIdCard,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: 'Doomsday',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                ),
              )
            : verifyResultView()
        : CommonUtils.progressDialogBox();
  }
}
