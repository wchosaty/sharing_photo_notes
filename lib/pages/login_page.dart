import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/config/http_constants.dart';
import 'package:sharing_photo_notes/config/model_constants.dart';
import 'package:sharing_photo_notes/config/string_constants.dart';
import 'package:sharing_photo_notes/config/widget_constants.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/models/transfer_image.dart';
import 'package:sharing_photo_notes/models/user.dart';
import 'package:sharing_photo_notes/pages/home_page.dart';
import 'package:sharing_photo_notes/utils/access_file.dart';
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
  var avatar;
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
  late String token;
  late bool login;

  @override
  void initState() {
    super.initState();
    initialData();

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
                  InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: avatar != null
                        ? ClipOval(
                        child: Image.file(avatar,fit: BoxFit.cover,height: 50,width: 50,),
                        )
                        : Image.asset(
                      imageAccount,
                      fit: BoxFit.cover,
                      color: Colors.black,
                      height: 50,width: 50,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          child: const Text(
                            sSignUp,
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
                          child: const Text(
                            sSignIn,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            if (checkKeyInData(userNameController.text) &&
                                checkKeyInData(passwordController.text) ) {
                              logIn();
                            }
                          }),
                    ],
                  ),

                  Text(
                    systemMessage,
                    style: const TextStyle(color: Colors.black87),
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
    avatar = File(imageSelect!.path);
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
    Map<String, String> headerMap = {sAction: sInsert, sContent: sUser};
    LogData().dd(tag, "json", json);
    String back = await HttpConnection().toServer(
        ip: urlIp, path: urlServerUserPath, json: json, headerMap: headerMap);

    ///驗證
    if (back.isNotEmpty) {
      String token = back.trim();
      LogData().dd(tag, "token", token);
      saveUser(token);

      /// avatar
      var image_name = int.parse(token);
      if(avatar != null){
        Uint8List avatarImage = await avatar.readAsBytes();
        TransferImage transfer = TransferImage(image: avatarImage, image_name: image_name, username: username);
        String json = jsonEncode(transfer);
        LogData().dd(tag, "json avatar", json);
        Map<String, String> headerMap = {sAction: sInsert, sContent: sImage,};
        String backAvatar = await HttpConnection().toServer(
            ip: urlIp, path: urlServerUserPath, json: json, headerMap: headerMap);
        if(backAvatar.isNotEmpty) {
          LogData().dd(tag, "backAvatar.isNotEmpty", backAvatar);
        }
        AccessFile().saveImage(username,avatarImage);
      }
      MyApp.localUser = username;
      clearTextField();
      systemMessage = "";
      systemMessage = "";
      passwordController.text = "";
      Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      systemMessage = sFail;
    }
    setState(() {});
  }

  Future<void> logIn() async {
    String keyInUsername = userNameController.text.trim();
    String pass = passwordController.text.trim();
    String token = preferences.getString(sToken) ?? "";
    if(token.isNotEmpty ) {
      LogData().dd(tag, "token", token);
      User user = User(
          username: keyInUsername,
          password: pass,
          nickname: "",
          token: token,
          );
      String json = jsonEncode(user);
      Map<String, String> headerMap = {sAction: sQuery, sContent: sUser,sType: sLogin};
      LogData().dd(tag, "json", json);
      String back = await HttpConnection().toServer(
          ip: urlIp, path: urlServerUserPath, json: json, headerMap: headerMap);
      if(back.isNotEmpty) {
        MyApp.localUser = keyInUsername;
        preferences.setBool(sLogin, true);
        Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context) => HomePage()));
      }else {
        LogData().dd(tag, sLogin,sFail);

        setState(() {
          clearTextField();
          systemMessage = "";
          systemMessage = "";
          passwordController.text = "";
          systemMessage = sFail;
        });
      }
    }
    
  }

  Future  saveUser(String token) async{
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

  void initialData() async{
    preferences = await SharedPreferences.getInstance();
  }


}
