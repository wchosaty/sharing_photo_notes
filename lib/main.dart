import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/models/user.dart';
import 'package:sharing_photo_notes/pages/edit_page.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';
import 'package:sharing_photo_notes/pages/personal_page.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/Login': (context) => LoginPage(),
        '/Personal': (context) => PersonalPage(),
        '/Edit': (context) => EditPage(),
      },
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const tag = 'tag _HomePageState';
  late Widget currentPage;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    currentPage = LoginPage();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: currentPage,
        ),
      ),
    );
  }
  Future loadUser() async {
    preferences = await SharedPreferences.getInstance();
    String username = preferences.getString("username") ?? "";
    String nickname = preferences.getString("nickname") ?? "";
    String token = preferences.getString("token") ?? "";
    bool login = preferences.getBool("login") ?? false;

    if (checkString(username) &&
        checkString(nickname) &&
        checkString(token) &&
        login) {
      LogData().d(tag, '已登入');
      /// pushReplacementNamed 會清除push的stack頁面 /pushRepNamed 不會
      Navigator.of(context).pushReplacementNamed('/Edit',
          arguments: User(username: username, nickname: nickname, token: token) );
    } else {
      LogData().d(tag, '無使用者');
    }

  }
  bool checkString(String checkString) {
    bool returnVal = false;
    String s = checkString.trim();
    if (s.isNotEmpty) returnVal = true;
    return returnVal;
  }
}