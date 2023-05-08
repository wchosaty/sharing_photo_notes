import 'package:flutter/material.dart';
import 'package:sharing_photo_notes/pages/login_page.dart';
import 'package:sharing_photo_notes/pages/personal_page.dart';
import 'pages/home_page.dart';

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
        '/Home': (context) =>  HomePage(),
        '/Login': (context) => LoginPage(),
        '/Personal': (context) => PersonalPage(),
      },
      home: HomePage(),
    );
  }
}
