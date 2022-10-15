import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upaychat/CommonUtils/common_utils.dart';

import 'imagepickerdialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  ImagePickerHandler(this._listener, this._controller);
  compressedImage(String path) async {
    var target = CommonUtils.getTargetPath(path);
    File compressedFile = await FlutterImageCompress.compressAndGetFile(path, target);
    return compressedFile;
  }

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25);
    if (image != null) _listener.userImage(await compressedImage(image.path));
    // cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (image != null) _listener.userImage(await compressedImage(image.path));
    //cropImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );
    _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
