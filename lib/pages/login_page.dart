import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/models/user.dart';
import 'package:sharing_photo_notes/pages/personal_page.dart';
import 'package:sharing_photo_notes/utils/http_connection.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';
import 'package:sharing_photo_notes/widgets/com_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const tag = 'tag _LoginPageState';
  var image;
  String systemMessage = "";
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
    final screenSide = MediaQuery.of(context).size.width * 0.05;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
                  ComTextField(
                      controller: nicknameController, labelText: 'Nickname'),
                  // ComTextField(controller: emailController,labelText: 'email', keyboardType: TextInputType.emailAddress),
                  // ComTextField(controller: phoneController,labelText: 'phone', keyboardType: TextInputType.phone),
                  // ComTextField(controller: addressController,labelText: 'address'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                            }
                          }),
                      ElevatedButton(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {}),
                    ],
                  ),

                  Text(
                    systemMessage,
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ));
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

  void signUp() async {
    String username = userNameController.text.trim();
    String pass = passwordController.text.trim();
    String nick = nicknameController.text.trim();
    User user = User(
        username: username,
        password: pass,
        nickname: nick,
        status: statusPrivate);
    String json = jsonEncode(user);
    Map<String, String> map = {sAction: sInsert, sContent: sUser};
    LogData().dd(tag, "json", json);
    String back = await HttpConnection().toServer(
        ip: urlIp, path: urlServerUserPath, json: json, headerMap: map);

    ///驗證
    if (back.isNotEmpty) {
      String token = jsonEncode(back);
      LogData().dd(tag, "token", token);

      ///儲存
      saveUser(token);
      clearTextField();
      systemMessage = "";
      passwordController.text = "";
      Navigator.of(context).pushNamed('/Personal', arguments: user);
      // Navigator.of(context).pushNamed('/Edit');
    } else {
      systemMessage = sFail;
    }
    setState(() {});
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
      LogData().d(tag, '已登入');
    } else {
      LogData().d(tag, '無使用者');
    }
  }

  void saveUser(String token) {
    String userName = userNameController.text.trim();
    String nickname = nicknameController.text.trim();
    preferences.setString(sUsername, userName);
    preferences.setString(sNickname, nickname);
    preferences.setBool(sLogin, true);
    preferences.setString(sToken, token);
  }

  void clearTextField() {
    userNameController.text = "";
    passwordController.text = "";
    nicknameController.text = "";
  }
}
