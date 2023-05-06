import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/widgets/com_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSide = MediaQuery.of(context).size.width * 0.1;
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(screenSide),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(
                  color: Colors.white,
                )),
                onPressed: () {
                  getImage();
                },
                child: image != null
                    ? Image.file(
                        image,
                        width: 128.0,
                        height: 128.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Image.asset(
                        accountImage,
                        fit: BoxFit.cover,
                        color: Colors.black,
                      )),

            ComTextField(labelText: 'User name'),
            ComTextField(labelText: 'Password'),
            ComTextField(labelText: 'Confirm Password',obscureText: true),
            ComTextField(labelText: 'Nickname'),
            ComTextField(labelText: 'email',keyboardType: TextInputType.emailAddress),
            ComTextField(labelText: 'phone',keyboardType: TextInputType.phone,),
          ],
        ),
      ),
    );
  }

  Future<void> getImage() async {
    /// 可調整來源圖片
    print("touch");
    var source = ImageSource.gallery;
    XFile? imageSelect = await ImagePicker().pickImage(
      source: source,
    );
    image = File(imageSelect!.path);
    setState(() {});
  }
}
