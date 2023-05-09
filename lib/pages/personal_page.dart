import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/config/colors_constants.dart';
import 'package:sharing_photo_notes/models/user.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String username = '1';
    String nickname = '2';
    String password = '3';

    ///解析換頁帶來資料
    if (ModalRoute.of(context)?.settings.arguments != null) {
      User user = ModalRoute.of(context)?.settings.arguments as User;

      String username = user.username;
      String nickname = user.nickname;
      String password = user.password;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(username), Text(password), Text(nickname)],
          ),
        ),
      ),
    );
  }
}
