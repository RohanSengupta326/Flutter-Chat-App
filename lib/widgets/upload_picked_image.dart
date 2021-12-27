import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget {
  final void Function(XFile? image) imagePicker;
  UploadImage(this.imagePicker);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  XFile? _pickedImage;
  void uplaodImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? dp = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(
      () {
        _pickedImage = dp;
      },
    );
    widget.imagePicker(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _pickedImage != null
              ? FileImage(
                  File(_pickedImage!.path),
                )
              : const AssetImage('assets/images/userdp.png')
                  as ImageProvider<Object>?,
        ),
        TextButton.icon(
          onPressed: uplaodImage,
          icon: Icon(Icons.image),
          label: Text('Upload profile picture'),
        ),
      ],
    );
  }
}
