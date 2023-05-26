import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_photo_notes/pages/browse_page.dart';
import 'package:sharing_photo_notes/pages/edit_page.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';
import 'package:sharing_photo_notes/pages/personal_page.dart';
import 'package:sharing_photo_notes/pages/welcome_page.dart';
import 'package:sharing_photo_notes/utils/log_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static String localUser = '';

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/Login': (context) => LoginPage(),
        '/Personal': (context) => PersonalPage(),
        '/Edit': (context) => EditPage(),
        '/Browse': (context) => BrowsePage(),
      },
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: WelcomePage(),
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   static const tag = 'tag _HomePageState';
//   late Widget currentPage;
//   late SharedPreferences preferences;
//   int _currentIndex = 0;
//   final pages = [LoginPage(),BrowsePage(),PersonalPage()];
//
//   @override
//   void initState() {
//     super.initState();
//     currentPage = LoginPage();
//     loadUser();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       /// BottomNavigationBar
//       bottomNavigationBar: BottomNavigationBar(items: [
//         BottomNavigationBarItem(icon: Icon(Icons.logout),label: 'logout'),
//         BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Browse'),
//         BottomNavigationBarItem(icon: Icon(Icons.edit_document),label: 'Edit'),
//       ],
//         currentIndex: _currentIndex,
//         onTap: _onItemClick,
//       ),
//       body: SafeArea(
//         child: Container(
//           /// BottomNavigationBar
//           child: pages[_currentIndex],
//
//           // child: LoginPage(),
//         ),
//       ),
//     );
//   }
//   Future loadUser() async {
//     preferences = await SharedPreferences.getInstance();
//     String username = preferences.getString("username") ?? "";
//     String nickname = preferences.getString("nickname") ?? "";
//     String token = preferences.getString("token") ?? "";
//     bool login = preferences.getBool("login") ?? false;
//
//     if (checkString(username) &&
//         checkString(nickname) &&
//         checkString(token) &&
//         login) {
//       LogData().d(tag, '已登入');
//       /// pushReplacementNamed 會清除push的stack頁面 /pushRepNamed 不會
//       // Navigator.of(context).pushReplacementNamed('/Personal', arguments: username );
//       MyApp.localUser = username.trim();
//       setState(() {
//         _currentIndex = 2;
//       });
//     } else {
//       LogData().d(tag, '無使用者');
//     }
//
//   }
//   bool checkString(String checkString) {
//     bool returnVal = false;
//     String s = checkString.trim();
//     if (s.isNotEmpty) returnVal = true;
//     return returnVal;
//   }
//
//   void _onItemClick(int value) {
//     setState(() {
//       _currentIndex = value;
//     });
//   }
// }