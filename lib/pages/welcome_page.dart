import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/main.dart';
import 'package:sharing_photo_notes/pages/home_page.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  static const tag = 'tag _WelcomePageState';
  late SharedPreferences preferences;
  bool toHomePageFlag = false;
  bool toLoginPageFlag = false;

  @override
  void initState() {
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 500)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(toLoginPageFlag){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        }
        // Main
        else if(toHomePageFlag){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        }else{
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WaitPage(),
          );
        }
      },
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
      MyApp.localUser = username.trim();
      // setState(() {});
       // Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context) => HomePage()));
        toHomePageFlag = true;

    } else {
      LogData().d(tag, '無使用者');
      // Navigator.pushReplacement(context as BuildContext, MaterialPageRoute(builder: (context) => LoginPage()));
      toLoginPageFlag = true;
    }
  }

  bool checkString(String checkString) {
    bool returnVal = false;
    String s = checkString.trim();
    if (s.isNotEmpty) returnVal = true;
    return returnVal;
  }
}

class WaitPage extends StatelessWidget {
  const WaitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(100),
      child: Column(children: [
        Text("Welcome"),
        Text(MyApp.localUser),
      ],),
    );
  }
}
