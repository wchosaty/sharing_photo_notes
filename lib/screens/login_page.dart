import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/ServerConnection/http_connection.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/models/user.dart';
import 'package:sharing_photo_notes/widgets/com_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var image;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late SharedPreferences preferences;
  late String username;
  late String password;
  late String nickname;
  late bool login;

  @override
  void initState() {
    super.initState();

    /// 有await 不能直接寫在iniState
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    var screenSide = MediaQuery
        .of(context)
        .size
        .width * 0.1;
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(screenSide),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                shape: CircleBorder(
                    side: BorderSide(width: 2.5, color: Colors.black)),
                onPressed: () {
                  getImage();
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: image != null
                      ? Image.file(
                    image,
                    width: 70.0,
                    height: 70.0,
                    fit: BoxFit.fitHeight,
                  )
                      : Image.asset(
                    accountImage,
                    fit: BoxFit.cover,
                    color: Colors.black,
                  ),
                ),
              ),
              ComTextField(
                  controller: userNameController, labelText: 'User name'),
              ComTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true),
              // ComTextField(controller: confirmPasswordController,labelText: 'Confirm Password', obscureText: true),
              ComTextField(
                  controller: nicknameController, labelText: 'Nickname'),
              // ComTextField(controller: emailController,labelText: 'email', keyboardType: TextInputType.emailAddress),
              // ComTextField(controller: phoneController,labelText: 'phone', keyboardType: TextInputType.phone),
              // ComTextField(controller: addressController,labelText: 'address'),
              ElevatedButton(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (checkKeyInData(userNameController.text) &&
                        checkKeyInData(passwordController.text) &&
                        checkKeyInData(nicknameController.text)) {
                      signUp();
                      saveUser();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    /// 可調整來源圖片
    var source = ImageSource.gallery;
    XFile? imageSelect = await ImagePicker().pickImage(
      source: source,
    );
    image = File(imageSelect!.path);
    setState(() {});
  }

  bool checkKeyInData(String checkString) {
    bool returnVal = false;
    String s = checkString.trim();
    if (s.isNotEmpty) returnVal = true;
    return returnVal;
  }

  void signUp() {
    String user = userNameController.text.trim();
    String pass = passwordController.text.trim();
    String nick = nicknameController.text.trim();
    String json = jsonEncode( User(username: user,password: pass,nickname: nick) );
    var backJson = HttpConnection().toServer(urlIp, urlServerUserPath, json);
    ///測試
    print('backString : $backJson');
  }

  void logIn() {
    String user = userNameController.text.trim();
    String pass = passwordController.text.trim();
    String nick = nicknameController.text.trim();
  }

  Future loadUser() async {
    preferences = await SharedPreferences.getInstance();
    username = preferences.getString("username") ?? "";
    password = preferences.getString("password") ?? "";
    nickname = preferences.getString("nickname") ?? "";
    login = preferences.getBool("login") ?? false;

    if (checkKeyInData(username) &&
        checkKeyInData(password) &&
        checkKeyInData(nickname) &&
        login) {
      print('已有登入');
    } else {
      print('無使用者登入');
    }
  }

  void saveUser() {
    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();
    String nickname = nicknameController.text.trim();
    preferences.setString('userName', userName);
    preferences.setString('password', password);
    preferences.setString('nickname', nickname);
    preferences.setBool('login', true);
  }

}
