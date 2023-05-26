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
